//
//  GroupsViewController.swift
//  ProjectVK
//
//  Created by Igor on 06/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

class GroupsViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    private var groupList = [
        Group(groupName: "Drax", groupImage: "drax"),
        Group(groupName: "Gamora", groupImage: "gamora"),
        Group(groupName: "Groot", groupImage: "groot"),
        Group(groupName: "Mantis", groupImage: "mantis"),
        Group(groupName: "Peter Parker", groupImage: "pet"),
        Group(groupName: "Shuri", groupImage: "shuri"),
        Group(groupName: "T'challa", groupImage: "tchalla"),
        Group(groupName: "Vision", groupImage: "vision")]
    
    private var filteredGroupList = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredGroupList = groupList

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
        cell.groupPhoto.image = UIImage(named: filteredGroupList[indexPath.row].groupImage)
        
        return cell
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let group = filteredGroupList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if let index = groupList.firstIndex(where: { $0.groupName == group.groupName }) {
                groupList.remove(at: index)
            }
        }
    }

    
    // MARK: - Navigation
  
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if let groupFinderController = segue.source as? GroupsFinderController,
            let indexPath = groupFinderController.tableView.indexPathForSelectedRow {
            let newGroup = groupFinderController.groupList[indexPath.row]
            
            guard !filteredGroupList.contains(where: { group -> Bool in
                return group.groupName == newGroup.groupName
            }) else { return }
            
            groupList.append(newGroup)
            filteredGroupList.append(newGroup)
            let newIndexPath = IndexPath(item: filteredGroupList.count-1, section: 0)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
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
