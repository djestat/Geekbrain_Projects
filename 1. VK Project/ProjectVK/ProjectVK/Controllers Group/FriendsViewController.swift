//
//  FriendsViewController.swift
//  ProjectVK
//
//  Created by Igor on 06/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

class FriendsViewController: UITableViewController {
    
    private var friendsList = [MyFriends(name: "Tony Stark", avatarImage: "ts"),
        MyFriends(name: "Stive Rogers", avatarImage: "sr"),
        MyFriends(name: "Natasha Romanoff", avatarImage: "nr"),
        MyFriends(name: "Bruce Benner", avatarImage: "bb"),
        MyFriends(name: "Happy Hogan", avatarImage: "hh"),
        MyFriends(name: "Pepper Pots", avatarImage: "pp"),
        MyFriends(name: "Okoye", avatarImage: "okoye"),
        MyFriends(name: "Thor", avatarImage: "thor"),
        MyFriends(name: "James Royde", avatarImage: "jr"),
        MyFriends(name: "Karol Danvers", avatarImage: "kd"),
        MyFriends(name: "Klint Barton", avatarImage: "kb"),
        MyFriends(name: "Nebula", avatarImage: "nebula"),
        MyFriends(name: "Rocket", avatarImage: "rocket"),
        MyFriends(name: "Skot Lang", avatarImage: "sl"),
        MyFriends(name: "Valkiria", avatarImage: "valkiria"),
        MyFriends(name: "Wade Wilson", avatarImage: "ww"),
        MyFriends(name: "Wong", avatarImage: "wong")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friendsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendsCell.reuseID, for: indexPath) as? FriendsCell else { fatalError("Cell cannot be dequeued") }
        
        cell.friendName.text = friendsList[indexPath.row].name
        cell.friendPhoto.image = UIImage(named: friendsList[indexPath.row].avatarImage)

        return cell
    }
    

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendsProfileController",
            let friendsProfileVC = segue.destination as? FriendsProfileController,
            let indexPath = tableView.indexPathForSelectedRow {
            let friendProfileName = friendsList[indexPath.row].name
            let friendProfilePhoto = friendsList[indexPath.row].avatarImage
            friendsProfileVC.friendProfileName = friendProfileName
            friendsProfileVC.friendProfilePhoto = friendProfilePhoto
        }
    }
 

}
