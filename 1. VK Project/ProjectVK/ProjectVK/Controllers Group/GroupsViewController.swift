//
//  GroupsViewController.swift
//  ProjectVK
//
//  Created by Igor on 06/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

class GroupsViewController: UITableViewController {
    
    private var groupList = [
        Groups(groupName: "Drax - Group", imageGroup: "drax"),
        Groups(groupName: "Gamora - Group", imageGroup: "gamora"),
        Groups(groupName: "Groot - Group", imageGroup: "groot"),
        Groups(groupName: "Mantis - Group", imageGroup: "mantis"),
        Groups(groupName: "Peter Parker - Group", imageGroup: "pet"),
        Groups(groupName: "Shuri - Group", imageGroup: "shuri"),
        Groups(groupName: "T'challa - Group", imageGroup: "tchalla"),
        Groups(groupName: "Vision - Group", imageGroup: "vision")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groupList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupsCell.reuseID, for: indexPath) as? GroupsCell else { fatalError("Cell cannot be dequeued") }
        
        cell.groupName.text = groupList[indexPath.row].groupName
        cell.groupPhoto.image = UIImage(named: groupList[indexPath.row].imageGroup)
        
        return cell
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            groupList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    
    // MARK: - Navigation
  
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if let groupFinderController = segue.source as? GroupsFinderController,
            let indexPath = groupFinderController.tableView.indexPathForSelectedRow {
            let newGroup = groupFinderController.groupList[indexPath.row]
            
            guard !groupList.contains(where: { group -> Bool in
                return group.groupName == newGroup.groupName
            }) else { return }
            
            groupList.append(newGroup)
            let newIndexPath = IndexPath(item: groupList.count-1, section: 0)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    
}
