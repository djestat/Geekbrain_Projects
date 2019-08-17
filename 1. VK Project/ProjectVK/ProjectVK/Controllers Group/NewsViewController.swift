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
    
    let refreshControler = UIRefreshControl()
    let request = VKAPIRequests()
    var resultNotificationToken: NotificationToken?
    lazy var cachePhotoService = CachePhotoService(tableView: self.tableView)
    
    var newsList = [NewsRealm]()
    var nextList = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Operations
        getNewsOperation()
        
        //Refresh Control
        refreshControler.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.addSubview(refreshControler)
        
        
//        self.tableView.estimatedRowHeight = CGFloat(115)
//        self.tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    @objc func didPullToRefresh() {
        getNewsOperation()
        // For End refrshing
        refreshControler.endRefreshing()
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
       
        
        // Height Cell config
        print("🔳 SIZE NOW show : \(tableView.rowHeight)")

        cell.photoWidth = tableView.frame.width
        let defaultScale = CGFloat(240 / 320)
        var scale = CGFloat(newsList[indexPath.row].photoAspectRatio)
        if scale.isNaN {
            scale = defaultScale
        }
        cell.aspectRatio = scale
 
        let offset = CGFloat(10)
        let elementsOnView = CGFloat(5)
        let avatarHeight = cell.groupImageView.frame.height
        let textHeight = cell.newsTextLabel.frame.height
        let likeHeight = cell.likeImageView.frame.height
        let heightNewsImage = cell.newsPhotosView.frame.height
        let rowHeight = (offset * elementsOnView) + avatarHeight + textHeight + likeHeight + heightNewsImage
        
//        cell.contentView.frame.size = CGSize(width: tableView.frame.width, height: cellHeight)
        self.tableView.rowHeight = rowHeight
        self.tableView.cellForRow(at: indexPath)?.frame.size = CGSize(width: tableView.frame.width, height: rowHeight)
        
        print("🔳 SIZE IMAGE: \(tableView.frame.width) * \(scale) = \(tableView.frame.width * scale)")
        print("🔳 SIZE Cell NOW after set: \(tableView.rowHeight)")
        print("🔳 SIZE MUST BE: \(rowHeight)\n\n")
        
         // Configure the cell VERSION2 EXTENDED...
        cell.newsPhotosView.image = UIImage(named: "noimage")
        cell.viewsCountsLabel.alpha = 1
        cell.viewsIcon.alpha = 1
        cell.newsTextLabel.backgroundColor = .clear
        
        // For GIF & Video Property
        cell.documentSubview.backgroundColor = .clear
        cell.documentLabel.textColor = .clear
        
        cell.groupNameLabel.text = String(newsList[indexPath.row].sourceName)
        cell.groupImageView.image = cachePhotoService.getPhoto(with: newsList[indexPath.row].sourcePhoto, for: indexPath)

        switch newsList[indexPath.row].newsType {
        case "photo":
            cell.viewsCountsLabel.alpha = 0
            cell.viewsIcon.alpha = 0
            cell.newsPhotosView.image = cachePhotoService.getPhoto(with: newsList[indexPath.row].photo, for: indexPath)
            cell.newsTextLabel.text = String(newsList[indexPath.row].postText)
            cell.likeCountsLabel.text = String(newsList[indexPath.row].likes)
            cell.commentsCountsLabel.text = String(newsList[indexPath.row].comments)
        case "post":
            cell.newsTextLabel.text = String(newsList[indexPath.row].postText)
            cell.newsPhotosView.image = cachePhotoService.getPhoto(with: newsList[indexPath.row].photo, for: indexPath)
            if newsList[indexPath.row].attachmentsType == "photo" {
            } else if newsList[indexPath.row].attachmentsType == "doc" {
                cell.newsTextLabel.text = String(newsList[indexPath.row].postText)
                cell.documentSubview.backgroundColor = .lightGray
                cell.documentLabel.textColor = .red
//                cell.newsPhotosView.kf.setImage(with: URL(string: newsList[indexPath.row].attachmentsUrl))
            } else if newsList[indexPath.row].attachmentsType == "link" {
                cell.newsTextLabel.text = String(newsList[indexPath.row].postText)
//                cell.newsPhotosView.image = UIImage(named: "noimage")
            } else if newsList[indexPath.row].attachmentsType == "video"{
                cell.newsTextLabel.text = String(newsList[indexPath.row].postText)
                cell.documentSubview.backgroundColor = .lightGray
                cell.documentLabel.text = String("VIDEO")
                cell.documentLabel.textColor = .red
                print(newsList[indexPath.row].photoAspectRatio)
            } else if newsList[indexPath.row].attachmentsType == "No Attach"{
                cell.newsTextLabel.text = String(newsList[indexPath.row].postText)
//                cell.newsPhotosView.frame.size = .zero
//                tableView.rowHeight = (offset * elementsOnView) + avatarHeight + textHeight + likeHeight
            } else {
                cell.newsTextLabel.text = String(newsList[indexPath.row].postText)
                //cell.newsTextLabel.backgroundColor = .purple
            }
            cell.likeCountsLabel.text = String(newsList[indexPath.row].likes)
            cell.commentsCountsLabel.text = String(newsList[indexPath.row].comments)
            cell.viewsCountsLabel.text = String(newsList[indexPath.row].views)
        case "wall_photo":
            cell.newsPhotosView.image = cachePhotoService.getPhoto(with: newsList[indexPath.row].photo, for: indexPath)
            cell.newsTextLabel.text = String(newsList[indexPath.row].postText)
            cell.likeCountsLabel.text = String(newsList[indexPath.row].likes)
            cell.commentsCountsLabel.text = String(newsList[indexPath.row].comments)
            cell.viewsCountsLabel.alpha = 0
            cell.viewsIcon.alpha = 0
            cell.newsTextLabel.backgroundColor = .orange
        default:
            print("ЧТО-ТО ЕЩЕ")
            cell.newsPhotosView.image = cachePhotoService.getPhoto(with: newsList[indexPath.row].photo, for: indexPath)
            cell.newsTextLabel.backgroundColor = .magenta
        }
        
        //PRINT info about post and attachments
        print("📰 \(newsList[indexPath.row].newsType) - \(newsList[indexPath.row].postID) Attach: " + newsList[indexPath.row].attachmentsType)

        return cell
    }
    /*
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseID, for: indexPath) as? NewsCell else { fatalError() }
        
        if cell.isHighlighted {
            if newsList[indexPath.row].attachmentsType == "doc" {
                cell.newsPhotosView.kf.setImage(with: URL(string: newsList[indexPath.row].attachmentsUrl))
            }
        }
        
    }*/
/*
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        // Height Cell config
        let width = tableView.frame.width
        //        let width = cell.newsPhotosView.frame.width
        let defaultScale = CGFloat(240 / 320)
        var scale = CGFloat(newsList[indexPath.row].photoAspectRatio)
        if scale.isNaN {
            scale = defaultScale
        }
        let heightNewsImage = width * scale
        
        let offset = CGFloat(10)
        let elementsOnView = CGFloat(5)
        let avatarHeight = cell.groupImageView.frame.height
        let textHeight = cell.newsTextLabel.frame.height
        let likeHeight = cell.likeImageView.frame.height
        
        let heightRowWithoutContent = (offset * elementsOnView) + avatarHeight + likeHeight
        let rowHeight = (offset * elementsOnView) + avatarHeight + likeHeight + heightNewsImage
        
        
        return 115 + 375
    }*/
    
    // MARK: - Table view animation initialising
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.contentView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        let propertyAnimator = UIViewPropertyAnimator(duration: 0.6, curve: .easeOut) {
            cell.contentView.transform = .identity
        }
        propertyAnimator.startAnimation()
        
        
        /*
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseID, for: indexPath) as? NewsCell else { fatalError() }
      
        // Height Cell config
        let width = tableView.frame.width
        let defaultScale = CGFloat(240 / 320)
        var scale = CGFloat(newsList[indexPath.row].photoAspectRatio)
        if scale.isNaN {
            scale = defaultScale
        }
        let heightNewsImage = width * scale
        cell.newsPhotosView.frame.size = CGSize(width: width, height: heightNewsImage)
        
        let offset = CGFloat(10)
        let elementsOnView = CGFloat(5)
        let avatarHeight = cell.groupImageView.frame.height
        let textHeight = cell.newsTextLabel.frame.height
        let likeHeight = cell.likeImageView.frame.height
        
        let heightRowWithoutContent = (offset * elementsOnView) + avatarHeight + likeHeight
        
        let rowHeight = (offset * elementsOnView) + avatarHeight + likeHeight + heightNewsImage
        tableView.rowHeight = rowHeight
        
        
        if newsList[indexPath.row].attachmentsType == "No Attach"{
            cell.newsTextLabel.text = String(newsList[indexPath.row].postText)
            cell.newsPhotosView.frame.size = .zero
            tableView.rowHeight = (offset * elementsOnView) + avatarHeight + textHeight + likeHeight
        }
        */
    }
    
    
    
    //MARK: - Operation
    //MARK: - Get News Operation
    
    func getNewsOperation() {
        
        let fndo = FetchNewsDataOperation()
        let pndo = ParseNewsDataOperation()
        pndo.addDependency(fndo)
        let sntrdo = SaveNewsToRealmOperation()
        sntrdo.addDependency(pndo)
        let dndo = DisplayNewsDataOperation(controller: self)
        dndo.addDependency(sntrdo)
        OperationQueue.main.addOperations([fndo, pndo, sntrdo, dndo], waitUntilFinished: false)
        
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

extension NewsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
    
}
