//
//  GroupsFinderController.swift
//  ProjectVK
//
//  Created by Igor on 10/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

class d: UITableViewController {
    
    public let groupList: [Groups] = [
        Groups(groupName: "Tony Stark", imageGroup: "ts"),
        Groups(groupName: "Stive Rogers", imageGroup: "sr"),
        Groups(groupName: "Natasha Romanoff", imageGroup: "nr"),
        Groups(groupName: "Bruce Benner", imageGroup: "bb"),
        Groups(groupName: "Happy Hogan", imageGroup: "hh"),
        Groups(groupName: "Pepper Pots", imageGroup: "pp"),
        Groups(groupName: "Okoye", imageGroup: "okoye"),
        Groups(groupName: "Thor", imageGroup: "thor"),
        Groups(groupName: "James Royde", imageGroup: "jr"),
        Groups(groupName: "Karol Danvers", imageGroup: "kd"),
        Groups(groupName: "Klint Barton", imageGroup: "kb"),
        Groups(groupName: "Nebula", imageGroup: "nebula"),
        Groups(groupName: "Rocket", imageGroup: "rocket"),
        Groups(groupName: "Skot Lang", imageGroup: "sl"),
        Groups(groupName: "Valkiria", imageGroup: "valkiria"),
        Groups(groupName: "Wade Wilson", imageGroup: "ww"),
        Groups(groupName: "Wong", imageGroup: "wong")]
    
    @IBOutlet override var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()


    }
}

    // MARK: - Table view data source


    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupsCell.reuseID, for: indexPath) as? GroupsCell else { fatalError() }
        
        cell.groupName.text = groupList[indexPath.row].groupName
        cell.groupPhoto.image = UIImage(named:groupList[indexPath.row].imageGroup)
        
        return cell
    }
}

