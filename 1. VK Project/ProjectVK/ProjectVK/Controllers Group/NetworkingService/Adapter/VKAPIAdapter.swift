//
//  VKAPIAdapter.swift
//  ProjectVK
//
//  Created by Igor on 10.11.2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import Foundation
import RealmSwift

final class VKAPIAdapter {
        
    private let vkapiService = VKAPIRequests()

    private var realmNotificationTokens: NotificationToken?
    
    // MARK: - Load Friends
    
    func getFriends(completion: @escaping ([FriendProfile]) -> Void) {
        
        let realmConfig = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm(configuration: realmConfig)
        let friendList = realm.objects(REALMFriendProfile.self).filter("name != 'DELETED'")
        realmNotificationTokens = friendList.observe { [weak self] change in
            guard let self = self else { return }
            switch change {
            /*case .initial(let realmFriends):
                var friends: [FriendProfile] = []
                for friend in realmFriends {
                    friends.append(self.friends(from: friend))
                }
                self.realmNotificationTokens?.invalidate()
                completion(friends)*/
            case .update(let realmFriends, _, _, _):
                var friends: [FriendProfile] = []
                for friend in realmFriends {
                    friends.append(self.friends(from: friend))
                }
                self.realmNotificationTokens?.invalidate()
                completion(friends)
            case .error(let error):
                print(error.localizedDescription)
            case .initial(_):
                break
            }
        }
        
        vkapiService.loadFriends { result in
            switch result {
            case .success(let friendList):
                RealmProvider.save(data: friendList)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func friends(from realmFriendProfile: REALMFriendProfile) -> FriendProfile {
        return FriendProfile(id: realmFriendProfile.id, name: realmFriendProfile.name, lastname: realmFriendProfile.lastname, avatarGroupImage: realmFriendProfile.avatarGroupImage, avatarImage: realmFriendProfile.avatarImage, online: realmFriendProfile.online)
    }
}
