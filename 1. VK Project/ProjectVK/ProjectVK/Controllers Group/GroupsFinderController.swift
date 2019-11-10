//
//  GroupsFinderController.swift
//  ProjectVK
//
//  Created by Igor on 11/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit
import Kingfisher

class GroupsFinderController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    var searchingText = "Something"
    let request = VKAPIRequests()
    public var groupList = [REALMGroup]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        view.addGestureRecognizer(tapGR)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        KingfisherManager.shared.cache.clearMemoryCache()
//        KingfisherManager.shared.cache.clearDiskCache()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groupList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupsCell.reuseID, for: indexPath) as? GroupsCell else { fatalError() }

        cell.groupName.text = groupList[indexPath.row].name
        cell.groupPhoto.kf.setImage(with: URL(string: groupList[indexPath.row].image))

        return cell
    }
    
    // MARK: - Helpers
    @objc func dissmissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - editingStyle and editActions
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let groupId = groupList[indexPath.row].id
            request.joinGroup(groupId)
            self.navigationController?.popViewController(animated: true)
            print("Join in Group with ID \(groupId).")
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Вступить!") { (action, indexPath) in
            self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
            return
        }
        deleteButton.backgroundColor = .blue
        return [deleteButton]
    }

}

extension GroupsFinderController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            groupList.removeAll()
            view.endEditing(true)
            tableView.reloadData()
            return
        }
        request.findGroups(searchText) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let groupList):
                self.groupList.removeAll()
                self.groupList = groupList
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
