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
    
    var messages = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        request.getMessages() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let messages):
                self.messages = messages.items
                print(messages.items.count)
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessagesCell.reuseID, for: indexPath) as? MessagesCell else { fatalError("Cell cannot be dequeued") }
        // Configure the cell...
        
//        cell.chatOwnerImageView
        
        switch messages[indexPath.row].conversation.peer.type {
        case "user":
            cell.chatOwnerNameLabel.text = String(messages[indexPath.row].conversation.peer.id)
        case "chat":
            cell.chatOwnerNameLabel.text = String(messages[indexPath.row].conversation.peer.id)
        default:
            print("Not User and Chat")
        }
        
        if messages[indexPath.row].lastMessage.text.isEmpty  {            cell.chatLastMessageLabel.text = "Документ."
        } else {
            cell.chatLastMessageLabel.text = messages[indexPath.row].lastMessage.text
        }

        return cell
    }
 
    // MARK: - Navigation

}
