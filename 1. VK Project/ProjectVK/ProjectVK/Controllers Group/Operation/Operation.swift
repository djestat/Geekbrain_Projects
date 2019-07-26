//
//  Operation.swift
//  ProjectVK
//
//  Created by Igor on 14/07/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class FetchDataOperation: AsyncOperation {
    let vkRequest = VKAPIRequests()
    var data: Data?
    
    override func main() {
        vkRequest.loadGroupsData { (result) in
            let value = try? result.get()
            self.data = value
            print("🔥 OPERATIONS FDO \(String(describing: value))")
            self.state = .finished
        }
    }
}

class ParseDataOperation: AsyncOperation {
    var groupList = [Group]()
    
    override func main() {
        guard let fetchDataOps = dependencies.filter({ $0 is FetchDataOperation }).first as? FetchDataOperation else { return }
        
        
        let data = fetchDataOps.data as Any
        print("🔥 OPERATIONS PDO \(data)")
        let json = JSON(data)
        self.groupList = json["response"]["items"].arrayValue.map { Group($0) }
        print("🔥 OPERATIONS PDO \(groupList.count)")
        self.state = .finished
    }
    
 
}

class SaveToRealmOperation: AsyncOperation {

    override func main() {
        guard let parseDataOps = dependencies.filter({ $0 is ParseDataOperation }).first as? ParseDataOperation else { return }
        
        let groupList = parseDataOps.groupList
        RealmProvider.save(data: groupList)
        print("🔥 OPERATIONS STRO \(groupList.count)")
        self.state = .finished
    }
    
}

class DisplayDataOperation: AsyncOperation {
    let controller: GroupsViewController
    
    init(controller: GroupsViewController) {
        self.controller = controller
    }
    
    override func main() {
        guard (dependencies.first(where: { $0 is SaveToRealmOperation }) as? SaveToRealmOperation) != nil
            else { return }
        /*
        let realmConfig = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm(configuration: realmConfig)
        let groups = realm.objects(Group.self).filter("isMember == %i", 1)
        self.controller.resultNotificationToken = groups.observe { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial(let collection):
                self.controller.groupsList = collection
                self.controller.tableView.reloadData()
                print("INITIAAAAAAAAALLLLLLLLLLLLLL")
            case .update(let collection, deletions: let deletion, insertions: let insertions, modifications: let modification):
                self.controller.groupsList = collection
                self.controller.tableView.reloadData()
                print("UPDAAAAAAAAAATEEEEEE")
                print("\(collection.count) , \(deletion.count), \(insertions.count), \(modification.count)")
            case .error(let error):
                print(error.localizedDescription)
            }
        }*/
        

        
        let groups2 = RealmProvider.read(Group.self).filter("isMember == %i", 1)
        controller.groupsList = groups2
        controller.tableView.reloadData()
        
        
        print("🔥 OPERATIONS DDO \(controller.description) AND \(groups2.count) AND \(groups2.count)")
        self.state = .finished
    }
}

