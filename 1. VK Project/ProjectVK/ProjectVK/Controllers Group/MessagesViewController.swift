//
//  MessagesViewController.swift
//  ProjectVK
//
//  Created by Igor on 23/06/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit
import Kingfisher

class MessagesViewController: UITableViewController {
    
    let request = VKAPIRequests()
    
//    var friendsList = RealmProvider.read(FriendProfile.self)
    var friendsList = [FriendProfile]()
    var groupsList = [Group]()
    var messages = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        request.getMessages() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let messages):
                self.messages = messages.items
                self.friendsList = messages.profiles
                self.groupsList = messages.groups
                print(messages.items.count)
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        KingfisherManager.shared.cache.clearMemoryCache()
        //        KingfisherManager.shared.cache.clearDiskCache()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessagesCell.reuseID, for: indexPath) as? MessagesCell else { fatalError("Cell cannot be dequeued") }
        // Configure the cell...
        
        //Configure avatars
        
        // Configure messages
        switch messages[indexPath.row].conversation.peer.type {
        case "user":
            let autorId = messages[indexPath.row].conversation.peer.id
            var currentIndex = 0
            for i in 0..<friendsList.count {
                if autorId == Session.authData.userid {
                    cell.chatOwnerImageView.image = UIImage(named: "avatar")
                    break
                } else if autorId == friendsList[i].id {
                    break
                } else if currentIndex == friendsList.count {
                    cell.chatOwnerImageView.image = UIImage(named: "avatar")
                    break
                }
                currentIndex += 1
            }
            
            cell.chatOwnerNameLabel.text = String(friendsList[currentIndex].name + " " + friendsList[currentIndex].lastname)
            cell.chatOwnerImageView.kf.setImage(with: URL(string: friendsList[currentIndex].avatarGroupImage ))
        case "chat":
            cell.chatOwnerNameLabel.text = String(messages[indexPath.row].conversation.peer.id)
            cell.chatOwnerImageView.image = UIImage(named: "Groups")
        default:
            print("Not User or Chat")
        }
        
        if messages[indexPath.row].lastMessage.text.isEmpty  {            cell.chatLastMessageLabel.text = "Документ 📦"
        } else {
            cell.chatLastMessageLabel.text = messages[indexPath.row].lastMessage.text
        }

        return cell
    }
 
    // MARK: - Realm
    
    

}
