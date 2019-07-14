//
//  Operation.swift
//  ProjectVK
//
//  Created by Igor on 14/07/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

//Реализовать один из workflow приложения при помощи нескольких связанных Operation. Структура операций может выглядеть, например, FetchDataOperation -> ParseDataOperation -> SaveToRealmOperation -> DisplayDataOperation.

import Foundation
import SwiftyJSON

class FetchDataOperation: Operation {
    let vkRequest = VKAPIRequests()
    var data: Data? = nil
    
    override func main() {
        getData()
    }
    
    func getData() {
        vkRequest.loadFriendsData { [weak self] data in
            guard let self = self else { return }
            self.data = data
        }
    }
    
    
}

class ParseDataOperation: Operation {
    var friendList = [FriendProfile]()
    
    override func main() {
        guard let fetchDataOps = dependencies.filter({ $0 is FetchDataOperation }).first as? FetchDataOperation else { return }
        
        
        let data = fetchDataOps.data
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        
        friendList = json["response"]["items"].arrayValue.map { FriendProfile($0) }
        
    }
    
 
}

class SaveToRealmOperation: Operation {
    
    override func main() {
        
    }
    
}

class DisplayDataOperation: Operation {
    
    override func main() {
        
    }
    
}

