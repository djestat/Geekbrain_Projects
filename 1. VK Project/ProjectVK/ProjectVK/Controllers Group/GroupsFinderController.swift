//
//  GroupsFinderController.swift
//  ProjectVK
//
//  Created by Igor on 11/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit
import Kingfisher


class GroupsFinderController: UITableViewController {
    
    var searchingText = "Something"
    let request = VKAPIRequests()
    public var groupList = [Group]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request.findGroups(searchingText)
        request.findGroups(searchingText) { result in
            switch result {
            case .success(let groupList):
                self.groupList = groupList
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }


    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groupList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupsCell.reuseID, for: indexPath) as? GroupsCell else { fatalError() }

        cell.groupName.text = groupList[indexPath.row].groupName
//        cell.groupPhoto.image = UIImage(named:groupList[indexPath.row].groupImage)
        cell.groupPhoto.kf.setImage(with: URL(string: groupList[indexPath.row].groupImage))

        return cell
    }
    

}
