//
//  Operation.swift
//  ProjectVK
//
//  Created by Igor on 14/07/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import Foundation
import SwiftyJSON

class FetchDataOperation: Operation {
    let vkRequest = VKAPIRequests()
    var data: Data?
    
    override func main() {
        vkRequest.loadGroupsData { (result) in
            self.data = result.value
            print("🔥 OPERATIONS FDO \(result.error?.localizedDescription) AND \(result.value)")
        }
    }
}

class ParseDataOperation: Operation {
    var groupList = [Group]()
    
    override func main() {
        guard let fetchDataOps = dependencies.filter({ $0 is FetchDataOperation }).first as? FetchDataOperation else { return }
        
        
        let data = fetchDataOps.data as Any
        print("🔥 OPERATIONS PDO \(data)")
        let json = JSON(data)
        self.groupList = json["response"]["items"].arrayValue.map { Group($0) }
        print("🔥 OPERATIONS PDO \(groupList.count)")
    }
    
 
}

class SaveToRealmOperation: Operation {

    override func main() {
        guard let parseDataOps = dependencies.filter({ $0 is ParseDataOperation }).first as? ParseDataOperation else { return }
        
        let groupList = parseDataOps.groupList
        RealmProvider.save(data: groupList)
        print("🔥 OPERATIONS STRO \(groupList.count)")
    }
    
}

class DisplayDataOperation: Operation {
    let controller: GroupsViewController
    
    init(controller: GroupsViewController) {
        self.controller = controller
    }
    
    override func main() {
        
    }
    
}

