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
    
    var groupsList: Results<Group> = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true)).objects(Group.self).filter("isMember == %i", 1)
    
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

    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        resultNotificationToken?.invalidate()
        KingfisherManager.shared.cache.clearMemoryCache()
    }

    // MARK: - Helpers
    
    @objc func dissmissKeyboard() {
        view.endEditing(true)
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groupsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupsCell.reuseID, for: indexPath) as? GroupsCell else { fatalError("Cell cannot be dequeued") }
        
        cell.groupName.text = groupsList[indexPath.row].name
        cell.groupPhoto.kf.setImage(with: URL(string: groupsList[indexPath.row].image))
        
        return cell
    }
    
    //MARK: - editingStyle and editActions

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let groupId = groupsList[indexPath.row].id
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
    
    //MARK: - REALM Function
    /*
    func resultNotificationObjects() {
        let realmConfig = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm(configuration: realmConfig)
        let groups = realm.objects(Group.self).filter("isMember == %i", 1)
        resultNotificationToken = groups.observe { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial(let collection):
                self.groupsList = collection
                self.tableView.reloadData()
                print("INITIAAAAAAAAALLLLLLLLLLLLLL")
            case .update(let collection, deletions: let deletion, insertions: let insertions, modifications: let modification):
                self.groupsList = collection
                self.tableView.reloadData()
                print("UPDAAAAAAAAAATEEEEEE")
                print("\(collection.count) , \(deletion.count), \(insertions.count), \(modification.count)")
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    */
}

extension GroupsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            groupsList = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true)).objects(Group.self).filter("isMember == %i", 1)
            view.endEditing(true)
            tableView.reloadData()
            return
        }
        let searchingGroup = RealmProvider.searchInGroup(Group.self, searchText).filter("isMember == %i", 1)
        groupsList = searchingGroup
        tableView.reloadData()
    }
    
}
