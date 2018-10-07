//
//  ConversationViewController.swift
//  tinkoffChat
//
//  Created by Anton on 05/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {

    private var conversationsPresenter = MassageManager.shared.conversationsPresenter
    var tapMassageModel: MassageModel!
    
    private var massageArray = [MassageTextModel]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.conversationsPresenter.conversationView = self
        self.tapMassageModel = self.conversationsPresenter.getChosenModel()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        self.title = tapMassageModel.name
        self.conversationsPresenter.loadMassage()
        massageArray.append(MassageTextModel(text: tapMassageModel.massage ?? " "))
        if tapMassageModel.massage == nil {
            massageArray.removeAll()
        }
    }

}

extension ConversationViewController: ConversationsView {
    func loadMassage(massageText: [MassageTextModel]) {
        self.massageArray = massageText
    }
    func updateUI() {
        self.tableView.reloadData()
    }
}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            guard let myCell = tableView.dequeueReusableCell(withIdentifier: "MyMassage", for: indexPath) as? ChatMassageCellIView else {
                return tableView.dequeueReusableCell(withIdentifier: "MyMassage", for: indexPath)
            }
            myCell.myMassage.text = massageArray[indexPath.row].text
            return myCell
        } else {
            guard let friendCell = tableView.dequeueReusableCell(withIdentifier: "FriendMassage", for: indexPath) as? ChatMassageCellIView else {
                return tableView.dequeueReusableCell(withIdentifier: "FriendMassage", for: indexPath)
            }
            friendCell.friendMassage.text = massageArray[indexPath.row].text
            return friendCell
        }
        
    }
        
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return massageArray.count
    }
}


extension ConversationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
