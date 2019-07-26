//
//  Operation.swift
//  ProjectVK
//
//  Created by Igor on 14/07/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import Foundation
import SwiftyJSON

class FetchDataOperation: AsyncOperation {
    let vkRequest = VKAPIRequests()
    var data: Data?
    
    override func main() {
        vkRequest.loadGroupsData { (result) in
            let value = try? result.get()
            self.data = value
            print("🔥 OPERATIONS FDO \(String(describing: value))")
//            self.data = result.value
//            print("🔥 OPERATIONS FDO \(result.error?.localizedDescription) AND \(result.value)")
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
        self.state = .finished
    }
    
}

