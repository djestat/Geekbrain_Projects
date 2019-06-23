//
//  NewsViewController.swift
//  ProjectVK
//
//  Created by Igor on 20/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class NewsViewController: UITableViewController {
    let request = VKAPIRequests()
    var resultNotificationToken: NotificationToken?
    
    var newsList = [ResponseItem]()
    var friendList = [FriendProfile]()
    var groupList = [Group]()
    var nextList = ""

    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        request.loadNews(nextList) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let newsList2):
                self.newsList = newsList2.items
                self.friendList = newsList2.profiles
                self.groupList = newsList2.groups
                self.nextList = newsList2.nextFrom
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
        return newsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseID, for: indexPath) as? NewsCell else { fatalError() }
    
         // Configure the cell VERSION2 EXTENDED...
        cell.newsPhotosView.image = nil
        if newsList[indexPath.row].type == "photo" {
            let countPhotos = newsList[indexPath.row].photos.items[0].sizes.count
            cell.newsPhotosView.kf.setImage(with: URL(string: newsList[indexPath.row].photos.items[0].sizes[countPhotos - 1].url))
            cell.newsTextLabel.text = String(newsList[indexPath.row].text)
            cell.likeCountsLabel.text = String(newsList[indexPath.row].photos.items[0].likes.count)
            cell.commentsCountsLabel.text = String(newsList[indexPath.row].photos.items[0].comments.count)
            cell.viewsCountsLabel.alpha = 0
            cell.viewsIcon.alpha = 0
            cell.newsText.backgroundColor = .cyan
            let imageHeight = newsList[indexPath.row].photos.items[0].sizes[countPhotos - 1].height
            let imageWidth = newsList[indexPath.row].photos.items[0].sizes[countPhotos - 1].width
            let aspectRatio = CGFloat(imageHeight / imageWidth)
            let width = view.frame.width
            cell.newsPhotosView.frame.size = CGSize(width: width, height: width * aspectRatio)
            
        } else if newsList[indexPath.row].type == "post" {
            cell.newsTextLabel.text = String(newsList[indexPath.row].text)
            cell.groupNameLabel.text = String(newsList[indexPath.row].sourceID)
            if newsList[indexPath.row].attachments.count != 0 {
                cell.newsTextLabel.text = String(newsList[indexPath.row].text)
                if newsList[indexPath.row].attachments[0].type == "photo" {
                    let countPhotos = newsList[indexPath.row].attachments[0].photo.sizes.count
                    cell.newsPhotosView.kf.setImage(with: URL(string: newsList[indexPath.row].attachments[0].photo.sizes[countPhotos - 1].url))
                    let imageHeight: Float = Float(newsList[indexPath.row].attachments[0].photo.sizes[countPhotos - 1].height)
                    let imageWidth: Float = Float(newsList[indexPath.row].attachments[0].photo.sizes[countPhotos - 1].width)
                    let aspectRatio = CGFloat(imageHeight / imageWidth)
                    let width = self.view.frame.width
                    cell.newsPhotosView.frame.size = CGSize(width: width, height: width * aspectRatio)
                    print("\(aspectRatio) \(imageHeight) \(imageWidth) \(width)")
                } else if newsList[indexPath.row].attachments[0].type == "doc" {
                    cell.newsTextLabel.text = String(newsList[indexPath.row].text)
                    cell.newsPhotosView.kf.setImage(with: URL(string: newsList[indexPath.row].attachments[0].doc.url))
                } else if newsList[indexPath.row].attachments[0].type == "link" {
                    cell.newsTextLabel.text = String(newsList[indexPath.row].type + "\n" + newsList[indexPath.row].text + "\n" + "ЭТО LINK НАДО ОБРАБОТАТЬ" + "\n"  + newsList[indexPath.row].attachments[0].type)
                    cell.newsText.backgroundColor = .red
                } else {
                    cell.newsTextLabel.text = String(newsList[indexPath.row].type + "\n" + newsList[indexPath.row].text + "\n" + "ЭТО НАДО ОБРАБОТАТЬ" + "\n"  + newsList[indexPath.row].attachments[0].type)
                    cell.newsText.backgroundColor = .red
                }
            } else if newsList[indexPath.row].copyhistory.count != 0 {
                cell.newsTextLabel.text = String(newsList[indexPath.row].type + "\n" + "ЭТО РЕПОСТ НАДО ОБРАБОТАТЬ" + "\n" + newsList[indexPath.row].text)
                cell.newsText.backgroundColor = .red
            }
            
            cell.likeCountsLabel.text = String(newsList[indexPath.row].likes.count)
            cell.commentsCountsLabel.text = String(newsList[indexPath.row].comments.count)
            cell.viewsCountsLabel.text = String(newsList[indexPath.row].views.count)
           
        }  else if newsList[indexPath.row].type == "wall_photo" {
            
            cell.newsTextLabel.text = String(newsList[indexPath.row].type + "\n" + newsList[indexPath.row].photos.items[0].text)
            cell.newsText.backgroundColor = .magenta
            cell.groupNameLabel.text = String(newsList[indexPath.row].sourceID)
            var countPhotos = 0
            if newsList[indexPath.row].photos.items[0].sizes.count > 0 {
                countPhotos = newsList[indexPath.row].photos.items[0].sizes.count
                cell.newsPhotosView.kf.setImage(with: URL(string: newsList[indexPath.row].photos.items[0].sizes[countPhotos - 1].url))
            } else {
                cell.newsPhotosView.kf.setImage(with: URL(string: newsList[indexPath.row].photos.items[0].sizes[countPhotos].url))
            }
            cell.likeCountsLabel.text = String(newsList[indexPath.row].photos.items[0].likes.count)
            cell.commentsCountsLabel.text = String(newsList[indexPath.row].photos.items[0].comments.count)
            
            
        }
        
        let autorId = newsList[indexPath.row].sourceID
        var currentIndex = 0
        
        if autorId > 0 {
            for i in 0..<friendList.count {
                if autorId == friendList[i].id {
                break
                }
                currentIndex += 1
            }
            cell.groupNameLabel.text = String(friendList[currentIndex].name + " " + friendList[currentIndex].lastname)
            cell.groupImageView.kf.setImage(with: URL(string: friendList[currentIndex].avatarImage))
            
        } else if autorId < 0 {
            for i in 0..<groupList.count {
                if -autorId == groupList[i].id {
                break
                }
                currentIndex += 1
            
            }
            cell.groupNameLabel.text = String(groupList[currentIndex].name)
            cell.groupImageView.kf.setImage(with: URL(string: groupList[currentIndex].image))
            
        }
        
        
        return cell
    }
    
    // MARK: - Table view animation initialising
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.contentView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        let propertyAnimator = UIViewPropertyAnimator(duration: 0.6, curve: .easeOut) {
            cell.contentView.transform = .identity
        }
        
        propertyAnimator.startAnimation()
        
    }
    
    //MARK: - REALM Function
    
    func saveToRealm(_ data: [Group]) {
        let realmConfig = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm(configuration: realmConfig)
        try! realm.write {
            realm.add(data, update: .modified)
        }
        print(realm.configuration.fileURL!)
        print("WRITING GROUP TO REALM HERE RIGHT NOW!! WOWOWOW I'M HERE!!")
    }
    
/*    func resultNotificationObjects() {
        let realm = try! Realm()
        let newsList = realm.objects(Group.self)
        resultNotificationToken = newsList.observe { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial(let collection):
                self.newsList = Array(collection)
                self.tableView.reloadData()
                print("INITIAAAAAAAALLLLLLLLLLLLL")
            case .update(let collection, deletions: let deletion, insertions: let insertions, modifications: let modification):
                self.newsList = Array(collection)
                self.tableView.reloadData()
                print("UPDAAAAAAAAATEEEEEE")
                print("\(collection.count) , \(deletion.count), \(insertions.count), \(modification.count)")
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }*/
}
