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
    let cps = CachePhotoService()
    
    var newsList = [NewsRealm]()
    var nextList = ""

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Operations
        let fndo = FetchNewsDataOperation()
        let pndo = ParseNewsDataOperation()
        pndo.addDependency(fndo)
        let sntrdo = SaveNewsToRealmOperation()
        sntrdo.addDependency(pndo)
        let dndo = DisplayNewsDataOperation(controller: self)
        dndo.addDependency(sntrdo)
        OperationQueue.main.addOperations([fndo, pndo, sntrdo, dndo], waitUntilFinished: false)
        
        
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
        cell.viewsCountsLabel.alpha = 1
        cell.viewsIcon.alpha = 1
        cell.newsTextLabel.backgroundColor = .clear
        
        // For GIF & Video Property
        cell.documentSubview.backgroundColor = .clear
        cell.documentLabel.textColor = .clear
        
        cell.groupNameLabel.text = String(newsList[indexPath.row].sourceName)
        cell.groupImageView.image = cps.getPhoto(with: newsList[indexPath.row].sourcePhoto)
//        cell.newsPhotosView.image = cps.getPhoto(with: "")

        switch newsList[indexPath.row].newsType {
        case "photo":
            print("photo")
            cell.viewsCountsLabel.alpha = 0
            cell.viewsIcon.alpha = 0
            cell.newsPhotosView.image = cps.getPhoto(with: newsList[indexPath.row].photo)
            cell.newsTextLabel.text = String(newsList[indexPath.row].postText)
            cell.likeCountsLabel.text = String(newsList[indexPath.row].likes)
            cell.commentsCountsLabel.text = String(newsList[indexPath.row].comments)
            
        case "post":
            print("post")
            cell.newsTextLabel.text = String(newsList[indexPath.row].postText)
            cell.newsPhotosView.image = cps.getPhoto(with: newsList[indexPath.row].photo)
            
            if newsList[indexPath.row].attachmentsType == "photo" {
            } else if newsList[indexPath.row].attachmentsType == "doc" {
                cell.newsTextLabel.text = String(newsList[indexPath.row].postText)
//                cell.newsTextLabel.backgroundColor = .cyan
                cell.documentSubview.backgroundColor = .lightGray
                cell.documentLabel.textColor = .red
//                cell.newsPhotosView.kf.setImage(with: URL(string: newsList[indexPath.row].attachmentsUrl))
            } else if newsList[indexPath.row].attachmentsType == "link" {
                cell.newsTextLabel.text = String(newsList[indexPath.row].postText)
//                cell.newsTextLabel.backgroundColor = .blue
                cell.newsPhotosView.image = UIImage(named: "noimage")

            } else if newsList[indexPath.row].attachmentsType == "video"{
                cell.newsTextLabel.text = String(newsList[indexPath.row].postText)
//                cell.newsTextLabel.backgroundColor = .red
                cell.documentSubview.backgroundColor = .lightGray
                cell.documentLabel.text = String("VIDEO")
                cell.documentLabel.textColor = .red
            } else {
                cell.newsTextLabel.text = String(newsList[indexPath.row].postText)
//                cell.newsTextLabel.backgroundColor = .purple
            }
            cell.likeCountsLabel.text = String(newsList[indexPath.row].likes)
            cell.commentsCountsLabel.text = String(newsList[indexPath.row].comments)
            cell.viewsCountsLabel.text = String(newsList[indexPath.row].views)
        case "wall_photo":
            print("wall_photo")
            cell.newsPhotosView.image = cps.getPhoto(with: newsList[indexPath.row].photo)
            cell.newsTextLabel.text = String(newsList[indexPath.row].postText)
            cell.likeCountsLabel.text = String(newsList[indexPath.row].likes)
            cell.commentsCountsLabel.text = String(newsList[indexPath.row].comments)
            cell.viewsCountsLabel.alpha = 0
            cell.viewsIcon.alpha = 0
            cell.newsTextLabel.backgroundColor = .orange
        default:
            print("ЧТО-ТО ЕЩЕ")
            cell.newsPhotosView.image = cps.getPhoto(with: newsList[indexPath.row].photo)
            cell.newsTextLabel.backgroundColor = .magenta
        }
        print(newsList[indexPath.row].postID)
        
        
        let width = tableView.frame.width
        let defaultScale = CGFloat(16 / 9)
        var scale = CGFloat(newsList[indexPath.row].photoAspectRatio)
        if scale.isNaN {
            scale = defaultScale
        }
        let height = width * scale
        cell.newsPhotosView.frame.size = CGSize(width: width, height: height)
        
        // Height Cell config
        let heightRowWithoutContent = CGFloat(121) //Рассчитал из сториборда 121 без картинки
        tableView.estimatedRowHeight = heightRowWithoutContent
        let heightText = cell.newsTextLabel.frame.height
        tableView.rowHeight = heightRowWithoutContent + height + heightText

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseID, for: indexPath) as? NewsCell else { fatalError() }
        
        if newsList[indexPath.row].attachmentsType == "doc" {
            cell.newsPhotosView.kf.setImage(with: URL(string: newsList[indexPath.row].attachmentsUrl))
        }
        
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
    //MARK: - Realm Notification
    
    func resultNotificationObjects() {
        let realm = try! Realm()
        let newsList = realm.objects(NewsRealm.self)
        resultNotificationToken = newsList.observe { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial(let collection):
                self.newsList = Array(collection)
                self.tableView.reloadData()
                print("INITIAAAAAAAALLLLLLLLLLLLL")
                print("\(collection.count)")
            case .update(let collection, deletions: let deletion, insertions: let insertions, modifications: let modification):
                self.newsList = Array(collection)
                self.tableView.reloadData()
                print("UPDAAAAAAAAATEEEEEE")
                print("\(collection.count) , \(deletion.count), \(insertions.count), \(modification.count)")
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
