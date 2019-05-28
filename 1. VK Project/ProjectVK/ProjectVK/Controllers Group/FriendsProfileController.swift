//
//  FriendsProfileController.swift
//  ProjectVK
//
//  Created by Igor on 09/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit
import Kingfisher


class FriendsProfileController: UICollectionViewController {
    
    let request = VKAPIRequests()
    
    public var friendProfileUserId: Int = 1
    public var friendProfileName = ""
    public var friendProfileLastname = ""
    public var friendProfilePhoto = [FriendProfilePhoto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request.loadPhotos(friendProfileUserId) { result in
            switch result {
            case .success(let photoList):
                self.friendProfilePhoto = photoList
                self.collectionView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        let width = collectionView.bounds.width / 3.05
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width * 1.25)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        /*
        let size = CGSize(width: 166, height: 185)
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: size.width, height: size.height)
//        layout.sectionHeadersPinToVisibleBounds = true
        */
        title = friendProfileName + " " + friendProfileLastname
    
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return friendProfilePhoto.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendsPhotoCell.reuseID, for: indexPath) as? FriendsPhotoCell else { fatalError() }
    
        // Configure the cell
        cell.friendProfilePhoto.kf.setImage(with: URL(string: friendProfilePhoto[indexPath.row].photo))
    
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPhoto",
            let friendsBigPhotoVC = segue.destination as? FriendsBigPhotoCollectionViewController{
            // section - indexrow
//            let indexPath = collectionView.indexPathsForSelectedItems {
            
            let bigPhoto = friendProfilePhoto
            friendsBigPhotoVC.friendProfilePhoto = bigPhoto

        }
        
    }
    
}
