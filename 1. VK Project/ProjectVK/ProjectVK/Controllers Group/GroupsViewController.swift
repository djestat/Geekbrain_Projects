//
//  GroupsViewController.swift
//  ProjectVK
//
//  Created by Igor on 06/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class GroupsViewController: UITableViewController {
    
    let request = VKAPIRequests()
//    var resultNotificationToken: NotificationToken?
    
    var groupsList: Results<REALMGroup> = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true)).objects(REALMGroup.self).filter("isMember == %i", 1)
    
    private let viewModelFactory = CellModelFactory()
    private var viewModels: [GroupCellModel] = []
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Gesture
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        view.addGestureRecognizer(tapGR)
        
        //Operations
        let fdo = FetchDataOperation()
        let pdo = ParseDataOperation()
        pdo.addDependency(fdo)
        let sdo = SaveToRealmOperation()
        sdo.addDependency(pdo)
        let ddo = DisplayDataOperation(controller: self)
        ddo.addDependency(sdo)
        OperationQueue.main.addOperations([fdo, pdo, sdo, ddo], waitUntilFinished: false)

        viewModelRelease()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        KingfisherManager.shared.cache.clearMemoryCache()
    }

    // MARK: - Helpers
    
    @objc func dissmissKeyboard() {
        view.endEditing(true)
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupsCell.reuseID, for: indexPath) as? GroupsCell else { fatalError("Cell cannot be dequeued") }
        
        //Factory
        cell.configure(with: viewModels[indexPath.row])
        
        return cell
    }
    
    //MARK: - editingStyle and editActions

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let groupId = viewModels[indexPath.row].id
            request.leaveGroup(groupId)
            RealmProvider.deletGroup(objectID: groupId)
            print("Leave Group with ID \(groupId).")
            
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Покинуть!") { (action, indexPath) in
            self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
            return
        }
        deleteButton.backgroundColor = .red
        return [deleteButton]
    }
    
    //MARK: - Factory Function
    
    func viewModelRelease() {
        viewModels = viewModelFactory.constructGroupViewModels(from: Array(groupsList))
        tableView.reloadData()
    }
}

extension GroupsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            groupsList = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true)).objects(REALMGroup.self).filter("isMember == %i", 1)
            view.endEditing(true)
            viewModelRelease()
            return
        }
        let searchingGroup = RealmProvider.searchInGroup(REALMGroup.self, searchText).filter("isMember == %i", 1)
        groupsList = searchingGroup
        viewModelRelease()
    }
    
}
