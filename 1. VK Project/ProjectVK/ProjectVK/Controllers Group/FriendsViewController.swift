//
//  FriendsViewController.swift
//  ProjectVK
//
//  Created by Igor on 06/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class FriendsViewController: UITableViewController {
    
//    let vkRequest = VKAPIRequests()
//    var resultNotificationToken: NotificationToken?
//    private var friendsList = [REALMFriendProfile]()
    let vkAdapter = VKAPIAdapter()
    private var friendsList = [FriendProfile]()

    
    var sectionTitle = [String]()
    var sectionDictionary = [String: [FriendProfile]]()
    var searchingSectionTitle = [String]()
    var searchingSectionDictionary = [String: [FriendProfile]]()
    var searchingFriendList = [FriendProfile]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
     // MARK: - View lifecycle
    override func viewWillAppear(_ animated: Bool) {
       /* vkRequest.loadFriends { result in
            switch result {
            case .success(let friendList):
                RealmProvider.save(data: friendList)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }*/
        vkAdapter.getFriends { [weak self] friends in
            self?.friendsList = friends
            self?.sectionArrayPrepare()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.resultNotificationObjects()

        // Setup the SearchBar Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск друзей......"
        navigationItem.searchController = searchController
        definesPresentationContext = true
     
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.resultNotificationToken?.invalidate()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        var sections = sectionTitle
        
        if isFiltering() {
            sections = searchingSectionTitle
        }
        
        return sections.count
    }
    
    /*
     override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
    }*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        var dictionary = sectionDictionary
        var sections = sectionTitle
        
        if isFiltering() {
            dictionary = searchingSectionDictionary
            sections = searchingSectionTitle
        }
        
        let lastnameKey = sections[section]
        if let lastnameValues = dictionary[lastnameKey] {
            return lastnameValues.count
        }
        
        return 0
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendsCell.reuseID, for: indexPath) as? FriendsCell else { fatalError("Cell cannot be dequeued") }
        
        var sections = sectionTitle
        var dictionary = sectionDictionary
        
        if isFiltering() {
            dictionary = searchingSectionDictionary
            sections = searchingSectionTitle
        }
        
        let lastnameKey = sections[indexPath.section]
        if let lastnameValues = dictionary[lastnameKey] {
            cell.friendName.text = lastnameValues[indexPath.row].name + " " + lastnameValues[indexPath.row].lastname
            cell.friendPhoto.kf.setImage(with: URL(string: lastnameValues[indexPath.row].avatarImage))
            if lastnameValues[indexPath.row].online == 1 {
                cell.shadowColor = .friendStatusOnline
            } else if lastnameValues[indexPath.row].online == 0 {
                cell.shadowColor = .friendStatusOffline
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sections = sectionTitle
        
        if isFiltering() {
            sections = searchingSectionTitle
        }
        
        return sections[section]
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var sections = sectionTitle
        
        if isFiltering() {
            sections = searchingSectionTitle
        }
        return sections
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendsProfileController",
            let friendsProfileVC = segue.destination as? FriendsProfileController,
            // section - indexrow
            let indexPath = tableView.indexPathForSelectedRow {
            
            var dictionary = sectionDictionary
            var sections = sectionTitle
            
            if isFiltering() {
                dictionary = searchingSectionDictionary
                sections = searchingSectionTitle
            }
            let lastnameKey = sections[indexPath.section]
            
            if let lastnameValues = dictionary[lastnameKey] {
                let friendProfileUserId = lastnameValues[indexPath.row].id
                let friendProfileName = lastnameValues[indexPath.row].name
                let friendProfileLastname = lastnameValues[indexPath.row].lastname
                friendsProfileVC.friendProfileUserId = friendProfileUserId
                friendsProfileVC.friendProfileName = friendProfileName
                friendsProfileVC.friendProfileLastname = friendProfileLastname
            
            }
        }
        
    }
 
        // MARK: - Extantion function

    func sectionArrayPrepare() {
        
        sectionTitle.removeAll()
        sectionDictionary.removeAll()
        
        for lastname in friendsList {
            let lastnameKey = String(lastname.lastname.prefix(1))
            if var lastnameValues = sectionDictionary[lastnameKey] {
                lastnameValues.append(FriendProfile(id: lastname.id, name: lastname.name, lastname: lastname.lastname, avatarGroupImage: lastname.avatarGroupImage, avatarImage: lastname.avatarImage, online: lastname.online))
                sectionDictionary[lastnameKey] = lastnameValues
            } else {
                sectionDictionary[lastnameKey] = [FriendProfile(id: lastname.id, name: lastname.name, lastname: lastname.lastname, avatarGroupImage: lastname.avatarGroupImage, avatarImage: lastname.avatarImage, online: lastname.online)]
            }
        }
        
        sectionTitle = [String](sectionDictionary.keys)
        sectionTitle = sectionTitle.sorted(by: { $0 < $1 })
        
        tableView.reloadData()
    }
    
    // MARK: SearcBar functions
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        searchingFriendList = friendsList.filter({( name : FriendProfile) -> Bool in
            return name.name.lowercased().contains(searchText.lowercased()) || name.lastname.lowercased().contains(searchText.lowercased())
        })
        
        searchingSectionDictionary.removeAll()
        searchingSectionTitle.removeAll()

        for lastname in searchingFriendList {
            let lastnameKey = String(lastname.lastname.prefix(1))
            if var lastnameValues = searchingSectionDictionary[lastnameKey] {
                lastnameValues.append(FriendProfile(id: lastname.id, name: lastname.name, lastname: lastname.lastname, avatarGroupImage: lastname.avatarGroupImage, avatarImage: lastname.avatarImage, online: lastname.online))
                searchingSectionDictionary[lastnameKey] = lastnameValues
            } else {
                searchingSectionDictionary[lastnameKey] = [FriendProfile(id: lastname.id, name: lastname.name, lastname: lastname.lastname, avatarGroupImage: lastname.avatarGroupImage, avatarImage: lastname.avatarImage, online: lastname.online)]
            }
        }
        
        searchingSectionTitle = [String](searchingSectionDictionary.keys)
        searchingSectionTitle = searchingSectionTitle.sorted(by: { $0 < $1 })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    //MARK: - REALM Function
    /*
    func resultNotificationObjects() {
        let realmConfig = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm(configuration: realmConfig)
        let friendList = realm.objects(REALMFriendProfile.self).filter("name != 'DELETED'")
        resultNotificationToken = friendList.observe { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial(let collection):
                self.friendsList = Array(collection)
                self.sectionArrayPrepare()
                print("INITIAAAAAAAALLLLLLLLLLLLL")
            case .update(let collection, deletions: let deletion, insertions: let insertions, modifications: let modification):
                self.friendsList = Array(collection)
                self.sectionArrayPrepare()
                print("UPDAAAAAAAAATEEEEEE")
                print("\(collection.count) , \(deletion.count), \(insertions.count), \(modification.count)")
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    } */
    

}

extension FriendsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // todo
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
