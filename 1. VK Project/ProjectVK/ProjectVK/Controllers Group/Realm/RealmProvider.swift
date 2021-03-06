//
//  RealmProvider.swift
//  ProjectVK
//
//  Created by Igor on 08/06/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import Foundation
import RealmSwift

class RealmProvider {
    static let deletIfMigration = Realm.Configuration.init(deleteRealmIfMigrationNeeded: true)
    
    //MARL: - Realm Read
    static func read<T: Object>(_ result: T.Type) -> Results<T> {
        let realm = try! Realm(configuration: deletIfMigration)
        print(realm.configuration.fileURL!)
        print("READING REALM DATA NOW HERE!! TYPE------>\(T.self)<------")
        return realm.objects(result)
    }
    
    //MARL: - Realm Search in group
    static func searchInGroup<T: Object>(_ result: T.Type, _ searchingText: String) -> Results<T> {
        let realm = try! Realm(configuration: deletIfMigration)
        print(realm.configuration.fileURL!)
        print("SEARCHING IN REALM DATA NOW HERE!! TYPE------>\(T.self)<------")
        return realm.objects(result).filter("name CONTAINS[cd] '\(searchingText)'")
    }
    
    //MARL: - Realm Search in friend
    static func searchInFriend<T: Object>(_ result: T.Type, _ searchingText: String) -> Results<T> {
        let realm = try! Realm(configuration: deletIfMigration)
        print("SEARCHING IN REALM DATA NOW HERE!! TYPE------>\(T.self)<------")
        return realm.objects(result).filter("name CONTAINS[cd] '\(searchingText)' OR lastname CONTAINS[cd] '\(searchingText)'")
    }
    
    //MARL: - Realm save
    static func save<T: Object>(data: [T]) {
        let realm = try! Realm(configuration: deletIfMigration)
        try! realm.write {
            realm.add(data, update: .modified)
        }
        print(realm.configuration.fileURL!)
        print("WRITING DATA INTO REALM NOW HERE!! TYPE------>\(T.self)<------")
    }
    
    //MARL: - Realm delet
    static func delet<T: Object>(data: [T], objectID: Int) {
        let realm = try! Realm(configuration: deletIfMigration)
        try! realm.write {
            let deleteData = realm.objects(T.self).filter("id == %i", objectID).first
            realm.delete(deleteData!)
        }
        print(realm.configuration.fileURL!)
        print("DELETE DATA INTO REALM NOW HERE!! TYPE------>\(T.self)<------")
    }
    
    //MARL: - Realm delet group
    static func deletGroup(objectID: Int) {
        let realm = try! Realm(configuration: deletIfMigration)
        try! realm.write {
            let deleteData = realm.objects(Group.self).filter("id == %i", objectID).first
            realm.delete(deleteData!)
        }
        print(realm.configuration.fileURL!)
        print("DELETE DATA INTO REALM NOW HERE!! TYPE------>\(Group.self)<------")
    }
    
}
