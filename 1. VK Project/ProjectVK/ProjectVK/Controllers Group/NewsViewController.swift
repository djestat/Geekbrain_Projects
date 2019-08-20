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
    private var cellHeight = [IndexPath: CGFloat]()
    
    var newsList = [NewsRealm]()
    var nextList = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Operations
        getNewsOperation()
        
        //Refresh Control
        refreshControler.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.addSubview(refreshControler)
        
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
    
    override func viewDidLayoutSubviews() {
        //высота ячейки здесь
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return newsList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //PRINT info about post and attachments
        print("📰 \(newsList[indexPath.section].newsType) - \(newsList[indexPath.section].postID) Attach: " + newsList[indexPath.section].attachmentsType)
        
        var cell: UITableViewCell!
        
        if indexPath.row == 0 {
            guard let cell0 = tableView.dequeueReusableCell(withIdentifier: GroupNewsCell.reuseID, for: indexPath) as? GroupNewsCell else { fatalError() }
            cell0.groupNameLabel.text = String(newsList[indexPath.section].sourceName)
            cell0.groupImageView.image = cachePhotoService.getPhoto(with: newsList[indexPath.section].sourcePhoto, for: indexPath)
            cell = cell0
        } else if indexPath.row == 1 {
            guard let cell1 = tableView.dequeueReusableCell(withIdentifier: TextNewsCell.reuseID, for: indexPath) as? TextNewsCell else { fatalError() }
            
            cell1.newsTextLabel.backgroundColor = .clear

            switch newsList[indexPath.section].newsType {
            case "photo":
                cell1.newsTextLabel.text = String(newsList[indexPath.section].postText)
            case "post":
                cell1.newsTextLabel.text = String(newsList[indexPath.section].postText)
                if newsList[indexPath.section].attachmentsType == "photo" {
                } else if newsList[indexPath.section].attachmentsType == "doc" {
                    cell1.newsTextLabel.text = String(newsList[indexPath.section].postText)
                } else if newsList[indexPath.section].attachmentsType == "link" {
                    cell1.newsTextLabel.text = String(newsList[indexPath.section].postText)
                } else if newsList[indexPath.section].attachmentsType == "video"{
                    cell1.newsTextLabel.text = String(newsList[indexPath.section].postText)
                } else if newsList[indexPath.section].attachmentsType == "No Attach"{
                    cell1.newsTextLabel.text = String(newsList[indexPath.section].postText)
                } else {
                    cell1.newsTextLabel.text = String(newsList[indexPath.section].postText)
                }
            case "wall_photo":
                cell1.newsTextLabel.text = String(newsList[indexPath.section].postText)
                cell1.newsTextLabel.backgroundColor = .orange
            default:
                print("ЧТО-ТО ЕЩЕ")
                cell1.newsTextLabel.backgroundColor = .magenta
            }
            cell = cell1
        } else if indexPath.row == 2 {
            guard let cell2 = tableView.dequeueReusableCell(withIdentifier: ContentNewsCell.reuseID, for: indexPath) as? ContentNewsCell else { fatalError() }
            // Height Cell config
            let photoWidth = tableView.frame.width
            let defaultScale = CGFloat(240 / 320)
            var scale = CGFloat(newsList[indexPath.section].photoAspectRatio)
            if scale.isNaN {
                scale = defaultScale
            }
            let heightNewsImage = photoWidth * scale
            self.cellHeight[indexPath] = heightNewsImage
            
            //Configure Content
            cell2.newsPhotosView.image = UIImage(named: "noimage")

            switch newsList[indexPath.section].newsType {
            case "photo":
                cell2.newsPhotosView.image = cachePhotoService.getPhoto(with: newsList[indexPath.section].photo, for: indexPath)
            case "post":
                cell2.newsPhotosView.image = cachePhotoService.getPhoto(with: newsList[indexPath.section].photo, for: indexPath)
                if newsList[indexPath.section].attachmentsType == "photo" {
                } else if newsList[indexPath.section].attachmentsType == "doc" {
//                    cell.documentSubview.backgroundColor = .lightGray
//                    cell.documentLabel.textColor = .red
                } else if newsList[indexPath.section].attachmentsType == "link" {
                } else if newsList[indexPath.section].attachmentsType == "video"{
//                    cell.documentSubview.backgroundColor = .lightGray
//                    cell.documentLabel.text = String("VIDEO")
//                    cell.documentLabel.textColor = .red
                } else if newsList[indexPath.section].attachmentsType == "No Attach"{
                } else {
                }
            case "wall_photo":
                cell2.newsPhotosView.image = cachePhotoService.getPhoto(with: newsList[indexPath.section].photo, for: indexPath)
            default:
                print("ЧТО-ТО ЕЩЕ")
                cell2.newsPhotosView.image = cachePhotoService.getPhoto(with: newsList[indexPath.section].photo, for: indexPath)
            }
            
            // For GIF & Video Property
//            cell.documentSubview.backgroundColor = .clear
//            cell.documentLabel.textColor = .clear
            cell = cell2
        } else if indexPath.row == 3 {
            guard let cell3 = tableView.dequeueReusableCell(withIdentifier: ActivitiesNewsCell.reuseID, for: indexPath) as? ActivitiesNewsCell else { fatalError() }
            cell3.viewsCountsLabel.alpha = 1
            cell3.viewsIcon.alpha = 1
            
            switch newsList[indexPath.section].newsType {
            case "photo":
                cell3.viewsCountsLabel.alpha = 0
                cell3.viewsIcon.alpha = 0
                cell3.likeCountsLabel.text = String(newsList[indexPath.section].likes)
                cell3.commentsCountsLabel.text = String(newsList[indexPath.section].comments)
            case "post":
                cell3.likeCountsLabel.text = String(newsList[indexPath.section].likes)
                cell3.commentsCountsLabel.text = String(newsList[indexPath.section].comments)
                cell3.viewsCountsLabel.text = String(newsList[indexPath.section].views)
            case "wall_photo":
                cell3.likeCountsLabel.text = String(newsList[indexPath.section].likes)
                cell3.commentsCountsLabel.text = String(newsList[indexPath.section].comments)
                cell3.viewsCountsLabel.alpha = 0
                cell3.viewsIcon.alpha = 0
            default:
                print("ЧТО-ТО ЕЩЕ")
            }
            cell = cell3
        }
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

    
    // MARK: - Table view animation initialising
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.contentView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        let propertyAnimator = UIViewPropertyAnimator(duration: 0.6, curve: .easeOut) {
            cell.contentView.transform = .identity
        }
        propertyAnimator.startAnimation()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Height Cell config
        if indexPath.row == 2 {
            var aspectRatio: CGFloat = 0
            if !newsList[indexPath.section].photoAspectRatio.isNaN {
                aspectRatio = CGFloat(newsList[indexPath.section].photoAspectRatio)
            } else {
                aspectRatio = 16 / 9
            }
            let heightRow = tableView.frame.width * aspectRatio
            return heightRow
        }
        
        // Use the default size for all other rows.
        return UITableView.automaticDimension
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
