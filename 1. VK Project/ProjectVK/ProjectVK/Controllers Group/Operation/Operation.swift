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

//MARK: - Operations for Groups

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
        
        let groups2 = RealmProvider.read(Group.self).filter("isMember == %i", 1)
        controller.groupsList = groups2
        controller.tableView.reloadData()
        
        
        print("🔥 OPERATIONS DDO \(controller.description) AND \(groups2.count) AND \(groups2.count)")
        self.state = .finished
    }
}


//MARK: - Operations for News

class FetchNewsDataOperation: AsyncOperation {
    let vkRequest = VKAPIRequests()
    var items = [ResponseItem]()
    var friendList = [FriendProfile]()
    var groupList = [Group]()
    var nextList = ""
    
    override func main() {
        vkRequest.loadNews(nextList) { result in
            switch result {
            case .success(let value):
                self.items = value.items
                self.friendList = value.profiles
                self.groupList = value.groups
                self.nextList = value.nextFrom
                print("🔥 OPERATIONS FNDO \(value.self)")
                self.state = .finished
            case .failure(let error):
                print("🔥 OPERATIONS FNDO \(error.localizedDescription)")
            }
            
        }
    }
}
    
    class ParseNewsDataOperation: AsyncOperation {
        var news = [NewsRealm]()
        
        override func main() {
            guard let fetchDataOps = dependencies.filter({ $0 is FetchNewsDataOperation }).first as? FetchNewsDataOperation else { return }
            
            let items = fetchDataOps.items
            let friendList = fetchDataOps.friendList
            let groupList = fetchDataOps.groupList
            let nextList = fetchDataOps.nextList
            
            for i in 0..<items.count {
                let news: NewsRealm = NewsRealm()
                
                news.postID = items[i].postID
                news.date = items[i].date
                news.newsType = items[i].type
                news.nextList = nextList
                
                let autorId = items[i].sourceID
                var currentIndex = 0
                
                if autorId > 0 {
                    for i in 0..<friendList.count {
                        if autorId == friendList[i].id {
                            break
                        }
                        currentIndex += 1
                    }
                    news.sourceID = items[i].sourceID
                    news.sourceName = String(friendList[currentIndex].name + " " + friendList[currentIndex].lastname)
                    news.sourcePhoto = friendList[currentIndex].avatarGroupImage
                    
                } else if autorId < 0 {
                    for i in 0..<groupList.count {
                        if -autorId == groupList[i].id {
                            break
                        }
                        currentIndex += 1
                    }
                    news.sourceID = -items[i].sourceID
                    news.sourceName = String(groupList[currentIndex].name)
                    news.sourcePhoto = groupList[currentIndex].image
                    
                }
                
                switch items[i].type {
                case "photo":
                    let countPhotos = items[i].photos.items[0].sizes.count
                    news.photo = items[i].photos.items[0].sizes[countPhotos - 1].url
                    news.postText = items[i].text
                    news.likes = items[i].photos.items[0].likes.count
                    news.comments = items[i].photos.items[0].comments.count
                    
                    let imageHeight = items[i].photos.items[0].sizes[countPhotos - 1].height
                    let imageWidth = items[i].photos.items[0].sizes[countPhotos - 1].width
                    let aspectRatio = Double(imageHeight) / Double(imageWidth)
                    news.photoAspectRatio = aspectRatio
                    
                case "post":
                    news.postText = String(items[i].text)
                    if items[i].attachments.count != 0 {
                        news.postText = String(items[i].text)
                        if items[i].attachments[0].type == "photo" {
                            let countPhotos = items[i].attachments[0].photo.sizes.count
                            news.photo = items[i].attachments[0].photo.sizes[countPhotos - 1].url
                            
                            let imageHeight = items[i].attachments[0].photo.sizes[countPhotos - 1].height
                            let imageWidth = items[i].attachments[0].photo.sizes[countPhotos - 1].width
                            let aspectRatio = Double(imageHeight) / Double(imageWidth)
                            news.photoAspectRatio = aspectRatio
                            
                        } else if items[i].attachments[0].type == "doc" {
                            news.postText = String(items[i].text)
                            let indexSizes = items[i].attachments[0].doc.preview.photo.sizes.count
                            news.photo = items[i].attachments[0].doc.preview.photo.sizes[indexSizes - 1].src
                            let imageHeight = items[i].attachments[0].doc.preview.photo.sizes[indexSizes - 1].height
                            let imageWidth = items[i].attachments[0].doc.preview.photo.sizes[indexSizes - 1].width
                            let aspectRatio = Double(imageHeight) / Double(imageWidth)
                            news.photoAspectRatio = aspectRatio
                            
                            news.attachmentsType = items[i].attachments[0].type
                            news.attachmentsUrl = items[i].attachments[0].doc.url
                        } else if items[i].attachments[0].type == "link" {
                            news.postText = String(items[i].type + "\n" + "ЭТО LINK НАДО ОБРАБОТАТЬ" + "\n" + items[i].text + "\n"  + items[i].attachments[0].link.caption + "\n" + items[i].attachments[0].link.description)
                            let indexSizes = items[i].attachments[0].link.photo.sizes.count
                            news.photo = items[i].attachments[0].link.photo.sizes[indexSizes - 1].url
                            let imageHeight = items[i].attachments[0].link.photo.sizes[indexSizes - 1].height
                            let imageWidth = items[i].attachments[0].link.photo.sizes[indexSizes - 1].width
                            let aspectRatio = Double(imageHeight) / Double(imageWidth)
                            news.photoAspectRatio = aspectRatio
                        } else if items[i].attachments[0].type == "video"{
                            news.postText = String(items[i].type + "\n" + "ЭТО VIDEO НАДО ОБРАБОТАТЬ" + "\n" + items[i].text + "\n"  + items[i].attachments[0].type)
                            news.photo =  items[i].attachments[0].video.photo320
                            news.attachmentsType = items[i].attachments[0].type
                            let imageHeight = items[i].attachments[0].video.height
                            let imageWidth = items[i].attachments[0].video.width
                            let aspectRatio = Double(imageHeight) / Double(imageWidth)
                            news.photoAspectRatio = aspectRatio
                        } else {
                            news.postText = String(items[i].type + "\n" + "ЭТО НАДО ОБРАБОТАТЬ" + "\n" + items[i].text + "\n"  + items[i].attachments[0].type)
                        }
                    } else if items[i].copyhistory.count != 0 {
                        news.postText = String(items[i].type + "\n" + "ЭТО РЕПОСТ НАДО ОБРАБОТАТЬ" + "\n" + items[i].text)
                    } else if items[i].attachments.count == 0 {
                        news.postText = String(items[i].text)
                    } else {
                        news.postText = String(items[i].type + "\n" + "ЭТО ЕЩЕ ЧТО-ТО И НАДО ОБРАБОТАТЬ")
                    }
                    
                    news.likes = items[i].likes.count
                    news.comments = items[i].comments.count
                    news.views = items[i].views.count
                case "wall_photo":
                    news.postText = String(items[i].photos.items[0].text)
                    var countPhotos = 0
                    if items[i].photos.items[0].sizes.count > 0 {
                        countPhotos = items[i].photos.items[0].sizes.count
                        news.photo = items[i].photos.items[0].sizes[countPhotos - 1].url
                        let imageHeight = items[i].photos.items[0].sizes[countPhotos - 1].height
                        let imageWidth = items[i].photos.items[0].sizes[countPhotos - 1].width
                        let aspectRatio = Double(imageHeight) / Double(imageWidth)
                        news.photoAspectRatio = aspectRatio
                    } else {
                        news.photo = items[i].photos.items[0].sizes[countPhotos].url
                        let imageHeight = items[i].photos.items[0].sizes[countPhotos].height
                        let imageWidth = items[i].photos.items[0].sizes[countPhotos].width
                        let aspectRatio = Double(imageHeight) / Double(imageWidth)
                        news.photoAspectRatio = aspectRatio
                    }
                    news.likes = items[i].photos.items[0].likes.count
                    news.comments = items[i].photos.items[0].comments.count
                default:
                    break
                    //code here
                }
                self.news.append(news)
            }
            print("🔥 OPERATIONS PNDO \(news.count)")
            self.state = .finished
        }
        
        
    }
    
    class SaveNewsToRealmOperation: AsyncOperation {
        
        override func main() {
            guard let parseDataOps = dependencies.filter({ $0 is ParseNewsDataOperation }).first as? ParseNewsDataOperation else { return }
            
            let news = parseDataOps.news
            RealmProvider.save(data: news)
            print("🔥 OPERATIONS SNTRO \(news.count)")
            self.state = .finished
        }
        
    }
    
    class DisplayNewsDataOperation: AsyncOperation {
        let controller: NewsViewController
        
        init(controller: NewsViewController) {
            self.controller = controller
        }
        
        override func main() {
            guard (dependencies.first(where: { $0 is SaveNewsToRealmOperation }) as? SaveNewsToRealmOperation) != nil
                else { return }
            
            let news = RealmProvider.read(NewsRealm.self).sorted(byKeyPath: "date", ascending: false)
            controller.newsList = Array(news)
            controller.nextList = news[0].nextList
            controller.tableView.reloadData()
            
            print("🔥 OPERATIONS DNDO \(controller.description) AND \(news.count)")
            self.state = .finished
        }
}

