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
    
    let vkRequest = VKAPIRequests()
    private var friendsList = [FriendProfile]()
    
    var sectionTitle = [String]()
    var sectionDictionary = [String: [FriendProfile]]()
    var searchingSectionTitle = [String]()
    var searchingSectionDictionary = [String: [FriendProfile]]()
    var searchingFriendList = [FriendProfile]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vkRequest.loadFriends { result in
            switch result {
            case .success(let friendList):
                self.friendsList = friendList
                self.sectionArrayPrepare()
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        if !isFiltering() {
//            sectionArrayPrepare()
        }
        
        // Setup the SearchBar Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск друзей......"
        navigationItem.searchController = searchController
        definesPresentationContext = true
     
 
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
//            cell.friendPhoto.image = UIImage(named:(lastnameValues[indexPath.row]).avatarImage)
            cell.friendPhoto.kf.setImage(with: URL(string: lastnameValues[indexPath.row].avatarImage))
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
                let friendProfileUserId = lastnameValues[indexPath.row].userid
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
        
        for lastname in friendsList {
            let lastnameKey = String(lastname.lastname.prefix(1))
            if var lastnameValues = sectionDictionary[lastnameKey] {
                lastnameValues.append(FriendProfile(userid: lastname.userid, name: lastname.name, lastname: lastname.lastname, avatarImage: lastname.avatarImage))
                sectionDictionary[lastnameKey] = lastnameValues
            } else {
                sectionDictionary[lastnameKey] = [FriendProfile(userid: lastname.userid, name: lastname.name, lastname: lastname.lastname, avatarImage: lastname.avatarImage)]
            }
        }
        
        sectionTitle = [String](sectionDictionary.keys)
        sectionTitle = sectionTitle.sorted(by: { $0 < $1 })
 
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
                lastnameValues.append(FriendProfile(userid: lastname.userid, name: lastname.name, lastname: lastname.lastname, avatarImage: lastname.avatarImage))
                searchingSectionDictionary[lastnameKey] = lastnameValues
            } else {
                searchingSectionDictionary[lastnameKey] = [FriendProfile(userid: lastname.userid, name: lastname.name, lastname: lastname.lastname, avatarImage: lastname.avatarImage)]
            }
        }
        
        searchingSectionTitle = [String](searchingSectionDictionary.keys)
        searchingSectionTitle = searchingSectionTitle.sorted(by: { $0 < $1 })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

}

extension FriendsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // todo
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
