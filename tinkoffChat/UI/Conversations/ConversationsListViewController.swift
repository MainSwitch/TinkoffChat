//
//  ViewController.swift
//  tinkoffChat
//
//  Created by Anton on 03/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController, ThemesViewControllerDelegate {
    
    func themesViewController(_ controller: ThemesViewController, didSelectTheme selectedTheme: UIColor) {
        logThemeChanging(selectedTheme: selectedTheme)
    }
    
    var delegate: ThemesViewControllerDelegate!
    var massageModel: [[MassageModel]]!
    var conversationsPresenter =  MassageManager.shared.conversationsPresenter

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    
    @IBAction func themesAction(_ sender: Any) {
        let storyboard = MassageManager.shared.themesStoryboard
        let vc = storyboard.instantiateViewController(withIdentifier: "ThemesNavigationVC") as UIViewController
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func profileAction(_ sender: Any) {
        let storyboard = MassageManager.shared.profileStoryboard
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as UIViewController
        self.present(vc, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.conversationsPresenter.conversationListView = self
        self.conversationsPresenter.updateConversationsList()
    }
}

extension ConversationsListViewController: ConversationsListView {
    func updateUI() {
        self.tableView.reloadData()
    }
    
    func updateData(model: [[MassageModel]]?) {
        if let modelArray = model {
            self.massageModel = modelArray
        }
    }
    func logThemeChanging(selectedTheme: UIColor) {
        if selectedTheme == UIColor.yellow {
            print("Yellow")
        } else if selectedTheme == UIColor.darkGray {
            print("DarkGray")
        }else if selectedTheme == UIColor.purple {
            print("Shampayne")
        }
    }
}

extension ConversationsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return massageModel[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassageCellView", for: indexPath) as? MassageCellView else {
            return tableView.dequeueReusableCell(withIdentifier: "MassageCellView", for: indexPath)
        }
        let sectionMassageModel = massageModel[indexPath.section][indexPath.row]
        
        cell.name = sectionMassageModel.name
        cell.online = sectionMassageModel.online
        cell.date = sectionMassageModel.date
        cell.hasUnreadMassages = sectionMassageModel.hasUnreadMassages
        cell.massage = sectionMassageModel.massage
        cell.setupUI()
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return massageModel.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Online"
        case 1:
            return "History"
        default:
            return "None"
        }
    }
}


extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = massageModel[indexPath.section][indexPath.row]
        self.conversationsPresenter.choseModel(model: model)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
