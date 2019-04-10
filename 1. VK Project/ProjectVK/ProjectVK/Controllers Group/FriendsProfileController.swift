//
//  FriendsProfileController.swift
//  ProjectVK
//
//  Created by Igor on 09/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

class FriendsProfileController: UICollectionViewController {

    public var friendProfileName = ""
    public var friendProfilePhoto = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = friendProfileName
    
    }

    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendsPhotoCell.reuseID, for: indexPath) as? FriendsPhotoCell else { fatalError() }
    
        // Configure the cell
        //ПО ЭТОЙ СТРОКЕ СПРАШИВАЛ КАК ИЗ КОНТРОЛЛЕРА FriendsViewController ПЕРЕДАТЬ В ЯЧЕЙКУ СЛЕДУЮЩЕГО КОНТРОЛЛЕРА (ЭТОГО) ДАННЫЕ ПО КАРТИНКЕ И ПРИМЕНИТЬ ЕГО К ЯЧЕЙКЕ
        cell.friendProfilePhoto.image = UIImage(named: friendProfilePhoto)
    
        return cell
    }

}
