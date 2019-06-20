//
//  FriendsProfileController.swift
//  ProjectVK
//
//  Created by Igor on 09/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class FriendsProfileController: UICollectionViewController {
    
    let request = VKAPIRequests()
    var resultNotificationToken: NotificationToken?
    
    public var friendProfileUserId: Int = 1
    public var friendProfileName = ""
    public var friendProfileLastname = ""
    public var friendProfilePhoto: Results<FriendPhoto> = try! Realm().objects(FriendPhoto.self)
    
    // MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        request.loadPhotos(friendProfileUserId) { result in
            switch result {
            case .success(let photoList):
                RealmProvider.save(data: photoList)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        resultNotificationObjects()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = collectionView.bounds.width / 3.05
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width + 30)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2

        title = friendProfileName + " " + friendProfileLastname
    
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        resultNotificationToken?.invalidate()
        KingfisherManager.shared.cache.clearMemoryCache()
//        KingfisherManager.shared.cache.clearDiskCache()
    }

    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return friendProfilePhoto.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendsPhotoCell.reuseID, for: indexPath) as? FriendsPhotoCell else { fatalError() }
    
        // Configure the cell
        
        if friendProfilePhoto[indexPath.row].isLiked == 1 {
            cell.likeToggle = true
        } else {
            cell.likeToggle = false
        }

        cell.isLiked = friendProfilePhoto[indexPath.row].isLiked
        cell.likeCounts = friendProfilePhoto[indexPath.row].likes
        cell.friendProfilePhoto.kf.setImage(with: URL(string: friendProfilePhoto[indexPath.row].photo))
        cell.awakeFromNib()
    
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPhoto",
            let friendsBigPhotoVC = segue.destination as? FriendsBigPhotoCollectionViewController,
            // section - indexrow
            let index = collectionView.indexPathsForSelectedItems?.first?.item {
            
            let bigPhoto = friendProfilePhoto
            friendsBigPhotoVC.friendProfilePhoto = bigPhoto
            friendsBigPhotoVC.indexPhoto = index

        }
        
    }
    
    //MARK: - REALM Function
    
    func resultNotificationObjects() {
        let realmConfig = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm(configuration: realmConfig)
        let friendPhotos = realm.objects(FriendPhoto.self).filter("ownerid = \(friendProfileUserId)")
        resultNotificationToken = friendPhotos.observe { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial(let collection):
                self.friendProfilePhoto = collection.sorted(byKeyPath: "id", ascending: false)
                self.collectionView.reloadData()
                print("INITIAAAAAAAALLLLLLLLLLLLL")
            case .update(let collection, deletions: let deletion, insertions: let insertions, modifications: let modification):
                self.friendProfilePhoto = collection.sorted(byKeyPath: "id", ascending: false)
                self.collectionView.reloadData()
                print("UPDAAAAAAAAATEEEEEE")
                print("\(collection.count) , \(deletion.count), \(insertions.count), \(modification.count)")
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
}
