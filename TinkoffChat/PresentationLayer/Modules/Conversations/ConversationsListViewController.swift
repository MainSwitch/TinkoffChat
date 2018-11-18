//
//  ConversationsListViewController.swift
//  tinkoffChat
//
//  Created by Anton on 16/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit
import CoreData

class ConversationsListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var fetchedResultsController: NSFetchedResultsController<Conversation>?
    var conversationsProvider: ConversationsDataProvider?
    private var themeFacade: IThemeFacade = AppDelegate.rootAssembly.presentationAssembly.themeFacade
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 60
        self.tableView.tableFooterView = UIView()
        self.conversationsProvider = ConversationsDataProvider(tableView: self.tableView)
        self.fetchedResultsController = self.conversationsProvider?.fetchedResultsController
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            try self.fetchedResultsController?.performFetch()
        } catch {
            //
        }
    }
    @IBAction func showProfileScreen() {
        let profileViewController =  AppDelegate.rootAssembly.presentationAssembly.profileViewController()
        let navigationProfileViewController = UINavigationController(rootViewController: profileViewController)
        self.present(navigationProfileViewController, animated: true, completion: nil)
    }
    @IBAction func showThemesViewController() {
        let themesViewController = ThemeVC.init(nibName: "Themes", bundle: nil)
        themesViewController.delegate = self
        themesViewController.model = Themes()
        let navigationThemesViewController = UINavigationController(rootViewController: themesViewController)
        self.present(navigationThemesViewController, animated: true, completion: nil)
    }
    @objc func cancelBarButtonItemTapped(sender: UIBarButtonItem!) {
        self.dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedCell = sender as? ConversationsTableViewCell {
            if let selectedIndexPath = self.tableView.indexPath(for: selectedCell) {
                self.tableView.deselectRow(at: selectedIndexPath, animated: true)
                let conversationViewController = segue.destination as? ConversationViewController
                conversationViewController?.userName = selectedCell.name
                conversationViewController?.online = selectedCell.online
                conversationViewController?.communicator =
                    AppDelegate.rootAssembly.presentationAssembly.communicationFacade
                conversationViewController?.conversationId = selectedCell.conversationId
                conversationViewController?.userId = selectedCell.userId
            }
        }
    }
}

// MARK: - Data Source
extension ConversationsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sectionsCount = self.fetchedResultsController?.sections?.count {
            return sectionsCount
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rowsCount = self.fetchedResultsController?.sections?[section].numberOfObjects {
            return rowsCount
        }
        return 0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Online"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier:
            ConversationsTableViewCell.idenfitifier, for: indexPath) as? ConversationsTableViewCell
        if let conversationConfiguration = self.fetchedResultsController?.object(at: indexPath) {
            dequeuedCell?.setConfiguration(configuration: conversationConfiguration)
        }
        guard let existCell = dequeuedCell else { return UITableViewCell(frame: .zero) }
        return existCell
    }
}

// MARK: - ThemesViewControllerDelegate
extension ConversationsListViewController: ThemesViewControllerDelegate {
    func themesViewController(controller: ThemeVC, selectedTheme: UIColor) {
        self.saveAndApplySelectedColor(selectedColor: selectedTheme)
    }
    func saveAndApplySelectedColor(selectedColor: UIColor) {
        self.view.backgroundColor = selectedColor
        self.themeFacade.saveAndApplyTheme(color: selectedColor)
    }
}
