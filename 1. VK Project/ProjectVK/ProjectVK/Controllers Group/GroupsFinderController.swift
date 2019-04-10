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
        Groups(groupName: "Batman", imageGroup: "batman"),
        Groups(groupName: "Goose", imageGroup: "goose"),
        Groups(groupName: "Shazam", imageGroup: "shazam"),
        Groups(groupName: "Backy Barnes", imageGroup: "backyb"),
        Groups(groupName: "Hope Van Dine", imageGroup: "hvd"),
        Groups(groupName: "Loki", imageGroup: "loki"),
        Groups(groupName: "Stiven Strange", imageGroup: "dss"),
        Groups(groupName: "Nike Furi", imageGroup: "nf"),
        Groups(groupName: "Peter Quill", imageGroup: "pq"),
        Groups(groupName: "Sam Wilson", imageGroup: "sw"),
        Groups(groupName: "Wanda Maximoff", imageGroup: "wm")]
    
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
