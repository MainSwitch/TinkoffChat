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
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.conversationsPresenter.addView(view: self)
        self.tapMassageModel = self.conversationsPresenter.getChosenModel()
        self.title = tapMassageModel.name
        // Do any additional setup after loading the view.
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
