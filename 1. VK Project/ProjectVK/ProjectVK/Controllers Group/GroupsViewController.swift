//
//  GroupsViewController.swift
//  ProjectVK
//
//  Created by Igor on 06/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit
import Kingfisher

class GroupsViewController: UITableViewController {
    
    let request = VKAPIRequests()
    private var groupList = [Group]()
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    private var filteredGroupList = [Group]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        request.userGroups { result in
            switch result {
            case .success(let groupList):
                self.groupList = groupList
                self.filteredGroupList = self.groupList
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGR = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        view.addGestureRecognizer(tapGR)
    }
    
    // MARK: - Helpers

    private func filterGroups(with text: String) {
        filteredGroupList = groupList.filter { group in
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
//        cell.groupPhoto.image = UIImage(named: filteredGroupList[indexPath.row].groupImage)
        cell.groupPhoto.kf.setImage(with: URL(string: filteredGroupList[indexPath.row].groupImage))
        
        return cell
    }
    
    // MARK: - Navigation
    
}

extension GroupsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredGroupList = groupList
            view.endEditing(true)
            tableView.reloadData()
            return
        }
        filterGroups(with: searchText)
    }
}
