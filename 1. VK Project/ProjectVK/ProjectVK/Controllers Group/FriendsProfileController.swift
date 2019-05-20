//
//  FriendsProfileController.swift
//  ProjectVK
//
//  Created by Igor on 09/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

class FriendsProfileController: UICollectionViewController {
    
    let request = VKAPIRequests()
    public let userID = Session.authData.userid

    public var friendProfileName = ""
    public var friendProfilePhoto = ""
    public var friendsPhotoCounts = 14
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request.loadPhotos(userID)
        
        let size = CGSize(width: 166, height: 185)
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: size.width, height: size.height)
//        layout.sectionHeadersPinToVisibleBounds = true
        
        title = friendProfileName
    
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return friendsPhotoCounts
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendsPhotoCell.reuseID, for: indexPath) as? FriendsPhotoCell else { fatalError() }
    
        // Configure the cell
        cell.friendProfilePhoto.image = UIImage(named: friendProfilePhoto)
    
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPhoto",
            let friendsBigPhotoVC = segue.destination as? FriendsBigPhotoCollectionViewController{
            // section - indexrow
//            let indexPath = collectionView.indexPathsForSelectedItems {
            
            let bigPhoto = friendProfilePhoto
            friendsBigPhotoVC.bigPhotoName = bigPhoto
            friendsBigPhotoVC.photoCounts = friendsPhotoCounts

        }
        
    }
    
}
