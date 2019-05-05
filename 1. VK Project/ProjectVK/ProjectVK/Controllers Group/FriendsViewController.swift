//
//  FriendsViewController.swift
//  ProjectVK
//
//  Created by Igor on 06/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

class FriendsViewController: UITableViewController {
    
    var sectionTitle = [String]()
    var sectionDictionary = [String: [MyFriends]]()
    var searchingDictionary = [String: [MyFriends]]()
    var searchingFriendList = [MyFriends]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var friendsList = [MyFriends(name: "Tony Stark", avatarImage: "ts"),
        MyFriends(name: "Stive Rogers", avatarImage: "sr"),
        MyFriends(name: "Natasha Romanoff", avatarImage: "nr"),
        MyFriends(name: "Bruce Benner", avatarImage: "bb"),
        MyFriends(name: "Happy Hogan", avatarImage: "hh"),
        MyFriends(name: "Pepper Pots", avatarImage: "pp"),
        MyFriends(name: "Okoye", avatarImage: "okoye"),
        MyFriends(name: "Thor", avatarImage: "thor"),
        MyFriends(name: "James Royde", avatarImage: "jr"),
        MyFriends(name: "Karol Danvers", avatarImage: "kd"),
        MyFriends(name: "Klint Barton", avatarImage: "kb"),
        MyFriends(name: "Nebula", avatarImage: "nebula"),
        MyFriends(name: "Rocket", avatarImage: "rocket"),
        MyFriends(name: "Skot Lang", avatarImage: "sl"),
        MyFriends(name: "Valkiria", avatarImage: "valkiria"),
        MyFriends(name: "Wade Wilson", avatarImage: "ww"),
        MyFriends(name: "Wong", avatarImage: "wong")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        sectionArrayPrepare()
        
        // Setup the SearchBar Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск друзей......"
        navigationItem.searchController = searchController
        definesPresentationContext = true
     
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
    
        return sectionTitle.count
    }
    
    /*
     override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
    }*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        var dictionary = sectionDictionary
        
        if isFiltering() {
            dictionary = searchingDictionary
        }
        
        let lastnameKey = sectionTitle[section]
        if let lastnameValues = dictionary[lastnameKey] {
            return lastnameValues.count
        }
        
        return 0
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendsCell.reuseID, for: indexPath) as? FriendsCell else { fatalError("Cell cannot be dequeued") }
        
        var dictionary = sectionDictionary
        
        if isFiltering() {
            dictionary = searchingDictionary
        }
        
        let lastnameKey = sectionTitle[indexPath.section]
        if let lastnameValues = dictionary[lastnameKey] {
            cell.friendName.text = lastnameValues[indexPath.row].name
            cell.friendPhoto.image = UIImage(named:(lastnameValues[indexPath.row]).avatarImage)
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitle
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendsProfileController",
            let friendsProfileVC = segue.destination as? FriendsProfileController,
            // section - indexrow
            let indexPath = tableView.indexPathForSelectedRow {
            let lastnameKey = sectionTitle[indexPath.section]
            
            var dictionary = sectionDictionary
            
            if isFiltering() {
                dictionary = searchingDictionary
            }
            
            if let lastnameValues = dictionary[lastnameKey] {
                let friendProfileName = lastnameValues[indexPath.row].name
                let friendProfilePhoto = lastnameValues[indexPath.row].avatarImage
                friendsProfileVC.friendProfileName = friendProfileName
                friendsProfileVC.friendProfilePhoto = friendProfilePhoto
            
            }
        }
        
    }
 
        // MARK: - Extantion function

    func sectionArrayPrepare() {
        
        for lastname in friendsList {
            let lastnameKey = String(lastname.name.prefix(1))
            if var lastnameValues = sectionDictionary[lastnameKey] {
                lastnameValues.append(MyFriends(name: lastname.name, avatarImage: lastname.avatarImage))
                sectionDictionary[lastnameKey] = lastnameValues
            } else {
                sectionDictionary[lastnameKey] = [MyFriends(name: lastname.name, avatarImage: lastname.avatarImage)]
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
        searchingFriendList = friendsList.filter({( name : MyFriends) -> Bool in
            return name.name.lowercased().contains(searchText.lowercased())
        })
        
        searchingDictionary.removeAll()

        for lastname in searchingFriendList {
            let lastnameKey = String(lastname.name.prefix(1))
            if var lastnameValues = searchingDictionary[lastnameKey] {
                lastnameValues.append(MyFriends(name: lastname.name, avatarImage: lastname.avatarImage))
                searchingDictionary[lastnameKey] = lastnameValues
            } else {
                searchingDictionary[lastnameKey] = [MyFriends(name: lastname.name, avatarImage: lastname.avatarImage)]
            }
        }
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
