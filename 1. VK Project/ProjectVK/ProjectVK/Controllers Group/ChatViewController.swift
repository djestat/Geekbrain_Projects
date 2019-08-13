//
//  ChatViewController.swift
//  ProjectVK
//
//  Created by Igor on 23/06/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class ChatViewController: UITableViewController {
    
    let refreshControler = UIRefreshControl()
    let request = VKAPIRequests()
    var resultNotificationToken: NotificationToken?
    var chats: Results<ChatsRealm> = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true)).objects(ChatsRealm.self).sorted(byKeyPath: "date", ascending: false)

    // MARK: - VC Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem

        //Realm Notification
        resultNotificationObjects()
        
        //VK Request get chats
        getChats()

        //Refresh Control
        refreshControler.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.addSubview(refreshControler)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        resultNotificationToken?.invalidate()
        KingfisherManager.shared.cache.clearMemoryCache()
        //        KingfisherManager.shared.cache.clearDiskCache()
    }
    
    // MARK: - Helpers
    
    @objc func didPullToRefresh() {
        getChats()
        // For End refrshing
        refreshControler.endRefreshing()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chats.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.reuseID, for: indexPath) as? ChatCell else { fatalError("Cell cannot be dequeued") }
        // Configure the cell...
        
        //Configure chats
        switch chats[indexPath.row].peerType {
        case "user":
            cell.chatOwnerNameLabel.text = chats[indexPath.row].userName
            cell.chatOwnerImageView.kf.setImage(with: URL(string: chats[indexPath.row].userAvatar))
        case "chat":
            cell.chatOwnerNameLabel.text = chats[indexPath.row].userName
            cell.chatOwnerImageView.image = UIImage(named: "Groups")
        case "group":
            cell.chatOwnerNameLabel.text = chats[indexPath.row].userName
            cell.chatOwnerImageView.kf.setImage(with: URL(string: chats[indexPath.row].userAvatar))
        default:
            print("Not User or Chat")
        }
        
        cell.chatLastMessageLabel.text = chats[indexPath.row].userLastMessage

        /*
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
            cell.chatOwnerImageView.kf.setImage(with: URL(string: friendsList[currentIndex].avatarGroupImage))
        case "chat":
            cell.chatOwnerNameLabel.text = String(messages[indexPath.row].conversation.chatSettings.title)            
            cell.chatOwnerImageView.image = UIImage(named: "Groups")
        case "group":
            let autorId = -messages[indexPath.row].conversation.peer.id
            var currentIndex = 0
            for i in 0..<groupsList.count {
                if autorId == Session.authData.userid {
                    cell.chatOwnerImageView.image = UIImage(named: "avatar")
                    break
                } else if autorId == groupsList[i].id {
                    break
                } else if currentIndex == groupsList.count {
                    cell.chatOwnerImageView.image = UIImage(named: "avatar")
                    break
                }
                currentIndex += 1
            }
            cell.chatOwnerNameLabel.text = String(groupsList[currentIndex].name)
            cell.chatOwnerImageView.kf.setImage(with: URL(string: groupsList[currentIndex].image))
        default:
            print("Not User or Chat")
        }
        
        if messages[indexPath.row].lastMessage.text.isEmpty  {            cell.chatLastMessageLabel.text = "Документ 📎"
        } else {
            cell.chatLastMessageLabel.text = messages[indexPath.row].lastMessage.text
        }*/

        return cell
    }
 
    //MARK: - VKRequest get chats
    func getChats() {
        request.getChats() { result in
            switch result {
            case .success(let chats):
                RealmProvider.save(data: chats)
                print("📥 Chats count \(chats.count)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - REALM Function
    func resultNotificationObjects() {
        let realmConfig = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm(configuration: realmConfig)
        let groups = realm.objects(ChatsRealm.self).sorted(byKeyPath: "date", ascending: false)
        resultNotificationToken = groups.observe { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial(let collection):
                self.chats = collection
                self.tableView.reloadData()
                print("INITIAAAAAAAAALLLLLLLLLLLLLL")
            case .update(let collection, deletions: let deletion, insertions: let insertions, modifications: let modification):
                self.chats = collection
                self.tableView.reloadData()
                print("UPDAAAAAAAAAATEEEEEE")
                print("\(collection.count) , \(deletion.count), \(insertions.count), \(modification.count)")
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenMessage" {
            let controller  = segue.destination as! MessageViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let senderID = chats[indexPath.row].userID
            let senderType = chats[indexPath.row].peerType
            let senderName = chats[indexPath.row].userName

            
            controller.senderID = senderID
            controller.senderType = senderType
            controller.senderName = senderName
        }
    }
    
}
