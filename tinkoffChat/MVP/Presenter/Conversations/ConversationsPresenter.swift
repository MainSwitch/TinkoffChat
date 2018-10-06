//
//  ConversationsPresenter.swift
//  tinkoffChat
//
//  Created by Anton on 04/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

class ConversationsPresenter {
    
    var massageModelArray: [MassageModel] = [MassageModel]()

    var chosenModel: MassageModel!
    var massage: [MassageModel]!
    
    class WeakRefView {
        private(set) weak var view: ConversationsView?
        
        init(_ view: ConversationsView?) {
            self.view = view
        }
    }
    
    private var views = [WeakRefView]()
    
    func addView(view: ConversationsView) {
        views.append(WeakRefView(view))
        views = views.filter { $0.view != nil } // remove old views
    }
    
    func loadDialog() {
        massageModelArray.append(MassageModel(name: "Anton", massage: "Hello!", date: Date(), online: false, hasUnreadMassages: false))
        massageModelArray.append(MassageModel(name: "Misha", massage: "Yes, alright", date: Date(timeIntervalSinceReferenceDate: -100), online: true, hasUnreadMassages: true))
        massageModelArray.append(MassageModel(name: "Edgar", massage: "How are you?", date: Date(timeIntervalSinceNow: -1231556), online: true, hasUnreadMassages: false))
        massageModelArray.append(MassageModel(name: "Vitya", massage: "What are you doing in Tinkoff?", date: Date(timeIntervalSinceNow: -1234), online: false, hasUnreadMassages: true))
        massageModelArray.append(MassageModel(name: "Davit", massage: "Soon", date: Date(timeIntervalSinceNow: -1000), online: false, hasUnreadMassages: true))
        massageModelArray.append(MassageModel(name: "SomeGuy", massage: "Hello)))))))", date: Date(timeIntervalSinceNow: -1231251125), online: false, hasUnreadMassages: false))
        massageModelArray.append(MassageModel(name: "Mom", massage: "Where are you ??????????", date: Date(), online: true, hasUnreadMassages: true))
        massageModelArray.append(MassageModel(name: "Dady", massage: "You're in deep trouble!!!!!", date: Date(), online: true, hasUnreadMassages: false))
        massageModelArray.append(MassageModel(name: "Donald Duck", massage: "QUACK", date: Date(timeIntervalSinceNow: -234), online: true, hasUnreadMassages: false))
        massageModelArray.append(MassageModel(name: "DONALD TRUMP", massage: "WE MAKE THE WALL", date: Date(timeIntervalSinceNow: -1345), online: true, hasUnreadMassages: false))
        massageModelArray.append(MassageModel(name: "Steve Jobs", massage: "...", date: nil, online: true, hasUnreadMassages: false))
        massageModelArray.append(MassageModel(name: "BATMAN", massage: "where the detonator?????", date: Date(timeIntervalSinceNow: -71), online: true, hasUnreadMassages: true))
        massageModelArray.append(MassageModel(name: "Flash", massage: "I'm soo fast bro", date: Date(), online: true, hasUnreadMassages: false))
        massageModelArray.append(MassageModel(name: "Brother", massage: "ok, let's go..", date: Date(timeIntervalSinceNow: -179), online: true, hasUnreadMassages: true))
        massageModelArray.append(MassageModel(name: nil, massage: "You kown?", date: Date(timeIntervalSinceNow: -320), online: false, hasUnreadMassages: false))
        massageModelArray.append(MassageModel(name: "Tinkoff", massage: "You'r cool!", date: Date(timeIntervalSinceNow: -720), online: false, hasUnreadMassages: false))
        massageModelArray.append(MassageModel(name: "Mask", massage: "this rocket is really fast", date: Date(timeIntervalSinceNow: -13215), online: false, hasUnreadMassages: false))
        massageModelArray.append(MassageModel(name: "Tony Stark", massage: "hi mechanic!!", date: Date(timeIntervalSinceNow: -5235), online: false, hasUnreadMassages: false))
        massageModelArray.append(MassageModel(name: "Thor", massage: "will you come?", date: Date(timeIntervalSinceNow: -1421355), online: false, hasUnreadMassages: false))
        massageModelArray.append(MassageModel(name: "Bro", massage: nil, date: Date(timeIntervalSinceNow: -1421355), online: false, hasUnreadMassages: false))
    }
    
    func loadMassage(dialogName: String) {
        
    }
    
    func choseModel(model: MassageModel?){
        if let existModel = model {
            self.chosenModel = existModel
        }
    }
    
    func getChosenModel() -> MassageModel {
        if let existModel = self.chosenModel {
            return existModel
        } else {
            return MassageModel(name: nil, massage: nil, date: nil, online: false, hasUnreadMassages: false)
        }
    }
    
    func updateConversationsList() {
        loadDialog()
        var sortMassageModel = [[MassageModel]]()
        sortMassageModel.append(massageModelArray.filter { $0.online }.sorted(by: { (first, second) -> Bool in
            if let firstDate = first.date {
                if let secondDate = second.date {
                    return firstDate > secondDate
                }
            }
            return false
        }))
        
        sortMassageModel.append(massageModelArray.filter { $0.online == false}.sorted(by: { (first, second) -> Bool in
            if let firstDate = first.date {
                if let secondDate = second.date {
                    return firstDate > secondDate
                }
            }
            return false
        }))
        
        self.views.forEach({ $0.view?.updateData(model: sortMassageModel)})
    }
    
    
}
