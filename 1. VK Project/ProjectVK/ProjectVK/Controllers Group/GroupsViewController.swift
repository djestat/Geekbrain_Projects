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
    var resultNotificationToken: NotificationToken?
    
    private var groupsList: Results<Group> = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true)).objects(Group.self)
    private var filteredGroupList: Results<Group> = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true)).objects(Group.self)
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        request.userGroups { result in
            switch result {
            case .success(let groupList):
                RealmProvider.save(data: groupList)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultNotificationObjects()

        let tapGR = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        view.addGestureRecognizer(tapGR)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        resultNotificationToken?.invalidate()
    }

    // MARK: - Helpers
    
    @objc func dissmissKeyboard() {
        view.endEditing(true)
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredGroupList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupsCell.reuseID, for: indexPath) as? GroupsCell else { fatalError("Cell cannot be dequeued") }
        
        cell.groupName.text = filteredGroupList[indexPath.row].name
        cell.groupPhoto.kf.setImage(with: URL(string: filteredGroupList[indexPath.row].image))
        
        return cell
    }
    
    //MARK: - REALM Function
    
    func resultNotificationObjects() {
        let realmConfig = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm(configuration: realmConfig)
        let friendPhotos = realm.objects(Group.self)
        resultNotificationToken = friendPhotos.observe { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial(let collection):
                self.groupsList = collection
                self.filteredGroupList = self.groupsList
                self.tableView.reloadData()
                print("INITIAAAAAAAAALLLLLLLLLLLLLL")
            case .update(let collection, deletions: let deletion, insertions: let insertions, modifications: let modification):
                self.groupsList = collection
                self.filteredGroupList = self.groupsList
                self.tableView.reloadData()
                print("UPDAAAAAAAAAATEEEEEE")
                print("\(collection.count) , \(deletion.count), \(insertions.count), \(modification.count)")
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension GroupsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredGroupList = groupsList
            view.endEditing(true)
            tableView.reloadData()
            return
        }
        let searchingGroup = RealmProvider.searchInGroup(Group.self, searchText)
        filteredGroupList = searchingGroup
        tableView.reloadData()
    }
    
}
