//
//  FriendsBigPhotoCollectionViewController.swift
//  ProjectVK
//
//  Created by Igor on 10/05/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "Cell"

class FriendsBigPhotoCollectionViewController: UICollectionViewController {
    
    public var friendProfilePhoto: Results<FriendPhoto> = try! Realm().objects(FriendPhoto.self)
    public var indexPhoto = 0

    override func viewWillAppear(_ animated: Bool) {
        let indexPath = IndexPath(row: indexPhoto, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollViev()
        
        let swipeGR = UISwipeGestureRecognizer(target: self, action: #selector(swipePhoto))
        swipeGR.direction = [.left, .right]
        view.addGestureRecognizer(swipeGR)
        
    }
    
    @objc func swipePhoto(_ recognizer: UISwipeGestureRecognizer) {
        switch recognizer.state {
        case .began:
            print("begin")
        case .cancelled:
            print("cancel")
        case .changed:
            print("change")
        case .ended:
            print("ended")
        case .possible:
            print("possible")
        default:
            print("XZ")
        }
    }

    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friendProfilePhoto.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendsBigPhotoCell.reuseID, for: indexPath) as? FriendsBigPhotoCell else { fatalError() }
    
        // Configure the cell
//        cell.bigFriendPhoto.image = UIImage(named: bigPhotoName)
        cell.bigFriendPhoto.kf.setImage(with: URL(string: friendProfilePhoto[indexPath.row].photo))
        cell.bigFriendPhoto.isMultipleTouchEnabled = true
        
        return cell
    }
    
    func setupScrollViev() {
        
        // Do any additional setup after loading the view.
        let size = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: size.width, height: size.height)
        layout.sectionHeadersPinToVisibleBounds = true
//        layout.
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.backgroundColor = .black
        
        collectionView.isPagingEnabled = true
        
    }
    
    // MARK: - Animation

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        cell.contentView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        let propertyAnimator = UIViewPropertyAnimator(duration: 0.6, curve: .easeOut) {
            cell.contentView.transform = .identity
        }
        
        propertyAnimator.startAnimation()
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveLinear, .curveEaseOut], animations: {
            cell!.contentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: nil)

    }

    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath)

        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveLinear, .curveEaseIn], animations: {
            cell!.contentView.transform = .identity
        }, completion: nil)

    }
    
    /*
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath)
//        cell!.contentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        let recognaiser = UIPanGestureRecognizer(target: self, action: nil)

        if recognaiser.delaysTouchesBegan == true {
            cell!.contentView.transform = .identity
        }
        
        if recognaiser.delaysTouchesEnded == true {
            cell!.contentView.transform = .identity
        }
        
//        if recognaiser.state == .possible {
//            UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .beginFromCurrentState, animations: {
//                cell!.contentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//            }, completion: nil)
//            
//        }
        
//        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveLinear, .curveEaseOut], animations: {
//            cell!.contentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//        }, completion: nil)

    } */

}
