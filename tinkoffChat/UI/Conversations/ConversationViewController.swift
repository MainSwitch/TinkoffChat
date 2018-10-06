//
//  ConversationViewController.swift
//  tinkoffChat
//
//  Created by Anton on 05/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {

    var conversationsPresenter = MassageManager.shared.conversationsPresenter
    var tapMassageModel: MassageModel!
    
    var massageArray = ["hello", "how are you?", "I'm fine, what are you doing?", "Let's go to bowling?)))"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.conversationsPresenter.addView(view: self)
        self.tapMassageModel = self.conversationsPresenter.getChosenModel()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        self.title = tapMassageModel.name
        massageArray.append(tapMassageModel.massage ?? " ")
        if tapMassageModel.massage == nil {
            massageArray.removeAll()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ConversationViewController: ConversationsView {
    func updateUI() {
        self.tableView.reloadData()
    }
    
    func updateData(model: [[MassageModel]]?) {
        print("wasUpdate")
    }
}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            guard let myCell = tableView.dequeueReusableCell(withIdentifier: "MyMassage", for: indexPath) as? ChatMassageCellIView else {
                return tableView.dequeueReusableCell(withIdentifier: "MyMassage", for: indexPath)
            }
            myCell.myMassage.text = massageArray[indexPath.row]
            return myCell
        } else {
            guard let friendCell = tableView.dequeueReusableCell(withIdentifier: "FriendMassage", for: indexPath) as? ChatMassageCellIView else {
                return tableView.dequeueReusableCell(withIdentifier: "FriendMassage", for: indexPath)
            }
            friendCell.friendMassage.text = massageArray[indexPath.row]
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
