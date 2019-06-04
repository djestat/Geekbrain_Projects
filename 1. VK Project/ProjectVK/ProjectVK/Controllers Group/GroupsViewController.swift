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
    private var groupsList = [Group]()
    private var filteredGroupList = [Group]()
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        request.userGroups { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let groupList):
                self.saveToRealm(groupList)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        readFromRealm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        let tapGR = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        view.addGestureRecognizer(tapGR)
    }
    
    // MARK: - Helpers

    private func filterGroups(with text: String) {
        filteredGroupList = groupsList.filter { group in
            return group.groupName.lowercased().contains(text.lowercased())
        }
        tableView.reloadData()
    }
    
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
        
        cell.groupName.text = filteredGroupList[indexPath.row].groupName
        cell.groupPhoto.kf.setImage(with: URL(string: filteredGroupList[indexPath.row].groupImage))
        
        return cell
    }
    
    //MARK: - REALM Function
    
    func saveToRealm(_ data: [Group]) {
        let realmConfig = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm(configuration: realmConfig)
        try! realm.write {
            realm.add(data, update: .modified)
        }
        print(realm.configuration.fileURL!)
        print("WRITING GROUP TO REALM HERE RIGHT NOW!! WOWOWOW I'M HERE!!")
    }
    
    func readFromRealm() {
        let realm = try! Realm()
        let groupList = Array(realm.objects(Group.self))
        groupsList = groupList
        filteredGroupList = groupsList
        tableView.reloadData()
        print("WAS HERE NOW!! READING GROUP DATA NOW HERE!!")
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
        filterGroups(with: searchText)
    }
}
