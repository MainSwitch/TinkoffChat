//
//  MultipeerCommunicator.swift
//  tinkoffChat
//
//  Created by Anton on 25/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol CommunicationDelegate: class {
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    func failedToStartBrowsingForUser(error: Error)
    func failedToStartAdvertising(error: Error)
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    func invitationWasReceived(fromPeer: String)
    func connectedWithPeer(peerID: MCPeerID, session: MCSession)
    func didNotConnect(toPeer: String)
}

protocol Communicator {
    func sendMessage(string: String,
                     to userID: String,
                     completionHandler: ((_ success: Bool, _ error: Error?) -> Void)?)
    var delegate: CommunicationDelegate? {get set}
    var online: Bool {get set}
}

class MultipeerCommunicator: NSObject,
                                MCSessionDelegate,
                                MCNearbyServiceBrowserDelegate,
                                MCNearbyServiceAdvertiserDelegate,
                                Communicator {
    weak var delegate: CommunicationDelegate?
    var dialogWithPeer: FoundPeer!
    var session: MCSession!
    var sendSession: MCSession!
    var peer: MCPeerID!
    var browser: MCNearbyServiceBrowser!
    var advertiser: MCNearbyServiceAdvertiser!
    var foundPeers = [MCPeerID]()
    var invitationHandler: ((Bool, MCSession?) -> Void)!
    var userName = UserDefaults.standard.string(forKey: "name") ?? UIDevice.current.name
    var online: Bool = false

    override init() {
        super.init()
        peer = MCPeerID(displayName: userName)
        session = MCSession(peer: peer)
        session.delegate = self
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: "tinkoff-chat")
        browser.delegate = self
        advertiser = MCNearbyServiceAdvertiser(peer: peer,
                                               discoveryInfo: ["userName": userName],
                                               serviceType: "tinkoff-chat")
        advertiser.delegate = self
    }
    // MARK: MCNearbyServiceBrowserDelegate method implementation
    func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String: String]?) {
        foundPeers.append(peerID)
        delegate?.didFoundUser(userID: peerID.displayName, userName: info?["userName"])
    }
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        for (index, aPeer) in foundPeers.enumerated() where aPeer == peerID {
            foundPeers.remove(at: index)
            break
        }
        delegate?.didLostUser(userID: peerID.displayName)
    }
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        delegate?.failedToStartBrowsingForUser(error: error)
    }
    // MARK: MCNearbyServiceAdvertiserDelegate method implementation
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping ((Bool, MCSession?) -> Void)) {
        self.invitationHandler = invitationHandler
        delegate?.invitationWasReceived(fromPeer: peerID.displayName)
    }
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        delegate?.failedToStartAdvertising(error: error)
    }
    // MARK: MCSessionDelegate method implementation
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected to session: \(String(describing: session))")
            delegate?.connectedWithPeer(peerID: peerID, session: session)
        case MCSessionState.connecting:
            print("Connecting to session: \(String(describing: session))")
        default:
            delegate?.didNotConnect(toPeer: peerID.displayName)
        }
    }
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let json = try? JSONSerialization.jsonObject(with: data) as? [String: String]
        if let model = json {
            let parsModel = JsonMessage(eventType: model?["eventType"] ?? "",
                                        messageId: model?["messageId"] ?? "" ,
                                        text: model?["text"] ?? "")
            delegate?.didReceiveMessage(text: parsModel.text, fromUser: peerID.displayName, toUser: self.userName )
        }
    }
    func session(_ session: MCSession,
                 didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 with progress: Progress) { }
    func session(_ session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 at localURL: URL?,
                 withError error: Error?) { }
    func session(_ session: MCSession,
                 didReceive stream: InputStream,
                 withName streamName: String,
                 fromPeer peerID: MCPeerID) { }
    // MARK: Custom method implementation
    func sendMessage(string: String,
                     to userID: String,
                     completionHandler: ((Bool, Error?) -> Void)?) {
        var peersArray = [MCPeerID]()
        var sendError: Error?
        var succsess = false
        self.foundPeers.forEach({ (peer) in
                if peer.displayName == userID {
                    peersArray.append(peer)
                }
            })
        let model = JsonMessage(eventType: "TextMessage", messageId: generateMessageId(), text: string)
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonModel = try encoder.encode(model)
            try sendSession.send(jsonModel, toPeers: peersArray, with: .reliable)
        } catch let error {
            sendError = error
        }
        succsess = sendError == nil ? true:false
        completionHandler?(succsess, sendError)
    }
    func generateMessageId() -> String {
        let random = arc4random_uniform(UINT32_MAX)
        let randomDate = Date.timeIntervalSinceReferenceDate
        let string = "\(random)+ \(randomDate) + \(random)".data(using: .utf8)?.base64EncodedString()
        return string!
    }
}
