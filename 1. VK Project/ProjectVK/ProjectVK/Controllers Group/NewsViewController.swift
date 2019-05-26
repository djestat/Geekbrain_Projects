//
//  NewsViewController.swift
//  ProjectVK
//
//  Created by Igor on 20/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController {
    let request = VKAPIRequests()
    
    var newsList = [News]()

    override func viewDidLoad() {
        super.viewDidLoad()
        request.loadNews() { result in
            switch result {
            case .success(let newsList):
                self.newsList = newsList
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseID, for: indexPath) as? NewsCell else { fatalError() }
        
        // Configure the cell...
//        cell.groupImageView.image
        cell.groupNameLabel.text = String(newsList[indexPath.row].groupName)
        cell.newsPhotosView.kf.setImage(with: URL(string: newsList[indexPath.row].newsPhotos))
        cell.newsTextLabel.text = String(newsList[indexPath.row].textNews)
        cell.likeCountsLabel.text = String(newsList[indexPath.row].likeCounts)
        cell.commentsCountsLabel.text = String(newsList[indexPath.row].commentsCount)
        cell.viewsCountsLabel.text = String(newsList[indexPath.row].viewsCounts)

        return cell
    }
    
}
