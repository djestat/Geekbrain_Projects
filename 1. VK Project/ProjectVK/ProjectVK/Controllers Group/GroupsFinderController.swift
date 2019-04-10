//
//  GroupsFinderController.swift
//  ProjectVK
//
//  Created by Igor on 11/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

class GroupsFinderController: UITableViewController {
    
    public let groupList: [Groups] = [
        Groups(groupName: "Batman - Group", imageGroup: "batman"),
        Groups(groupName: "Goose - Group", imageGroup: "goose"),
        Groups(groupName: "Shazam - Group", imageGroup: "shazam"),
        Groups(groupName: "Backy Barnes - Group", imageGroup: "backyb"),
        Groups(groupName: "Hope Van Dine - Group", imageGroup: "hvd"),
        Groups(groupName: "Loki - Group", imageGroup: "loki"),
        Groups(groupName: "Stiven Strange - Group", imageGroup: "dss"),
        Groups(groupName: "Nike Furi - Group", imageGroup: "nf"),
        Groups(groupName: "Peter Quill - Group", imageGroup: "pq"),
        Groups(groupName: "Sam Wilson - Group", imageGroup: "sw"),
        Groups(groupName: "Wanda Maximoff - Group", imageGroup: "wm")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groupList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupsCell.reuseID, for: indexPath) as? GroupsCell else { fatalError() }

        cell.groupName.text = groupList[indexPath.row].groupName
        cell.groupPhoto.image = UIImage(named:groupList[indexPath.row].imageGroup)

        return cell
    }
    

}
