//
//  GroupsFinderController.swift
//  ProjectVK
//
//  Created by Igor on 11/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseDatabase

class GroupsFinderController: UITableViewController {
    
    private let searchedGroupsRef = Database.database().reference(withPath: "search_groups")
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
//    var searchingText = "Something"
    let request = VKAPIRequests()
    public var groupList = [Group]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        view.addGestureRecognizer(tapGR)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groupList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupsCell.reuseID, for: indexPath) as? GroupsCell else { fatalError() }

        cell.groupName.text = groupList[indexPath.row].name
        cell.groupPhoto.kf.setImage(with: URL(string: groupList[indexPath.row].image))

        return cell
    }
    
    // MARK: - Helpers
    @objc func dissmissKeyboard() {
        view.endEditing(true)
    }

}

extension GroupsFinderController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            groupList.removeAll()
            view.endEditing(true)
            tableView.reloadData()
            return
        }
        
        if searchBar.isSearchResultsButtonSelected {
            request.findGroups(searchText) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let groupList):
                    self.groupList.removeAll()
                    self.groupList = groupList
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        if searchText.count > 4 {
            
            let userId = Session.authData.userid
            let authUser = FirebaseGroupsRequests(userId: userId, groupRequest: searchText)
            let searchedGroupsRef = self.searchedGroupsRef.child("\(userId)").child(searchText)
            searchedGroupsRef.setValue(authUser.toAnyObject())

        }
        
    }
}
