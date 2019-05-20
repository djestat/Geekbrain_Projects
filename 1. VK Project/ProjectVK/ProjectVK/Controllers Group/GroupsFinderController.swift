//
//  GroupsFinderController.swift
//  ProjectVK
//
//  Created by Igor on 11/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

class GroupsFinderController: UITableViewController {
    
    var searchingText = "Something"
    let request = VKAPIRequests()
    
    public let groupList: [Group] = [
        Group(groupName: "Batman", groupImage: "batman"),
        Group(groupName: "Goose", groupImage: "goose"),
        Group(groupName: "Shazam", groupImage: "shazam"),
        Group(groupName: "Backy Barnes", groupImage: "backyb"),
        Group(groupName: "Hope Van Dine", groupImage: "hvd"),
        Group(groupName: "Loki", groupImage: "loki"),
        Group(groupName: "Stiven Strange", groupImage: "dss"),
        Group(groupName: "Nike Furi", groupImage: "nf"),
        Group(groupName: "Peter Quill", groupImage: "pq"),
        Group(groupName: "Sam Wilson", groupImage: "sw"),
        Group(groupName: "Wanda Maximoff", groupImage: "wm"),
        Group(groupName: "Drax", groupImage: "drax"),
        Group(groupName: "Gamora", groupImage: "gamora"),
        Group(groupName: "Groot", groupImage: "groot"),
        Group(groupName: "Mantis", groupImage: "mantis"),
        Group(groupName: "Peter Parker", groupImage: "pet"),
        Group(groupName: "Shuri", groupImage: "shuri"),
        Group(groupName: "T'challa", groupImage: "tchalla"),
        Group(groupName: "Vision", groupImage: "vision")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request.loadFindedGroups(searchingText)

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groupList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupsCell.reuseID, for: indexPath) as? GroupsCell else { fatalError() }

        cell.groupName.text = groupList[indexPath.row].groupName
        cell.groupPhoto.image = UIImage(named:groupList[indexPath.row].groupImage)

        return cell
    }
    

}
