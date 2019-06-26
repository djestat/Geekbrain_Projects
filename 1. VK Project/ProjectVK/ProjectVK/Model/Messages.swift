//
//  Messages.swift
//  ProjectVK
//
//  Created by Igor on 23/06/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import Foundation
import SwiftyJSON

// MARK: - Response
class Messages {
    let count: Int
    let items: [Item]
    let profiles: [FriendProfile]
    let groups: [Group]
    
//    init(count: Int, items: [Item]) {
//        self.count = count
//        self.items = items
//    }
    
    init(_ json: JSON) {
        self.count = json["count"].intValue
        self.items = json["items"].arrayValue.map { Item($0) }
        self.profiles = json["profiles"].arrayValue.map { FriendProfile($0) }
        self.groups = json["groups"].arrayValue.map { Group($0) }
    }
}

// MARK: - Item
class Item {
    let conversation: Conversation
    let lastMessage: LastMessage
    
    init(conversation: Conversation, lastMessage: LastMessage) {
        self.conversation = conversation
        self.lastMessage = lastMessage
    }
    
    init(_ json: JSON) {
        let conversation = json["conversation"].self
        self.conversation = Conversation(conversation)
        let lastMessage = json["last_message"].self
        self.lastMessage = LastMessage(lastMessage)
    }
}

// MARK: - Conversation
class Conversation {
    let peer: Peer
    let inRead, outRead, lastMessageID: Int
    
    init(peer: Peer, inRead: Int, outRead: Int, lastMessageID: Int) {
        self.peer = peer
        self.inRead = inRead
        self.outRead = outRead
        self.lastMessageID = lastMessageID
    }
    
    init(_ json: JSON) {
        let peer = json["peer"].self
        self.peer = Peer(peer)
        self.inRead = json["in_read"].intValue
        self.outRead = json["out_read"].intValue
        self.lastMessageID = json["last_message_id"].intValue
    }
}

// MARK: - Peer
class Peer {
    let id: Int
    let type: String
    let localID: Int
    
    init(id: Int, type: String, localID: Int) {
        self.id = id
        self.type = type
        self.localID = localID
    }
    
    init(_ json: JSON) {
        self.id = json["id"].intValue
        self.type = json["type"].stringValue
        self.localID = json["local_id"].intValue
    }
}

// MARK: - LastMessage
class LastMessage {
    let date, fromID, id, out: Int
    let peerID: Int
    let text: String
    let conversationMessageID: Int
    let fwdMessages: [Messages]
    let ref, refSource: String
    let important: Bool
    let randomID: Int
    let attachments: [Attachment]
    let isHidden: Bool
    
    init(date: Int, fromID: Int, id: Int, out: Int, peerID: Int, text: String, conversationMessageID: Int, fwdMessages: [Messages], ref: String, refSource: String, important: Bool, randomID: Int, attachments: [Attachment], isHidden: Bool) {
        self.date = date
        self.fromID = fromID
        self.id = id
        self.out = out
        self.peerID = peerID
        self.text = text
        self.conversationMessageID = conversationMessageID
        self.fwdMessages = fwdMessages
        self.ref = ref
        self.refSource = refSource
        self.important = important
        self.randomID = randomID
        self.attachments = attachments
        self.isHidden = isHidden
    }
    
    init(_ json: JSON) {
        self.date = json["date"].intValue
        self.fromID = json["from_id"].intValue
        self.id = json["id"].intValue
        self.out = json["out"].intValue
        self.peerID = json["peer_id"].intValue
        self.text = json["text"].stringValue
        self.conversationMessageID = json["conversation_message_id"].intValue
        self.fwdMessages = json["fwd_messages"].arrayValue.map { Messages($0) }
        self.ref = json["ref"].stringValue
        self.refSource = json["ref_source"].stringValue
        self.important = json["important"].boolValue
        self.randomID = json["random_id"].intValue
        self.attachments = json["attachments"].arrayValue.map { Attachment($0) }
        self.isHidden = json["is_hidden"].boolValue
    }
}

// MARK: - Attachment
class Attachment {
    let type: String
    let link: Link?
    let doc: Doc?
    
    init(type: String, link: Link?, doc: Doc?) {
        self.type = type
        self.link = link
        self.doc = doc
    }
    
    init(_ json: JSON) {
        self.type = json[""].stringValue
        let link = json["link"].self
        self.link = Link(link)
        let doc = json["doc"].self
        self.doc = Doc(doc)
    }
}

// MARK: - Doc
class Doc {
    let id, ownerID: Int
    let title: String
    let size: Int
    let ext: String
    let url: String
    let date, type: Int
    let preview: Preview
    let accessKey: String
    
    init(id: Int, ownerID: Int, title: String, size: Int, ext: String, url: String, date: Int, type: Int, preview: Preview, accessKey: String) {
        self.id = id
        self.ownerID = ownerID
        self.title = title
        self.size = size
        self.ext = ext
        self.url = url
        self.date = date
        self.type = type
        self.preview = preview
        self.accessKey = accessKey
    }
    
    init(_ json: JSON) {
        self.id = json["id"].intValue
        self.ownerID = json["owner_id"].intValue
        self.title = json["title"].stringValue
        self.size = json["size"].intValue
        self.ext = json["ext"].stringValue
        self.url = json["url"].stringValue
        self.date = json["date"].intValue
        self.type = json["type"].intValue
        let preview = json["preview"].self
        self.preview = Preview(preview)
        self.accessKey = json["access_key"].stringValue
    }
}

// MARK: - Preview
class Preview {
    let photo: PreviewPhoto
    let video: Video
    
    init(photo: PreviewPhoto, video: Video) {
        self.photo = photo
        self.video = video
    }
    
    init(_ json: JSON) {
        let photo = json["photo"].self
        self.photo = PreviewPhoto(photo)
        let video = json["video"].self
        self.video = Video(video)
    }
    
}

// MARK: - PreviewPhoto
class PreviewPhoto {
    let sizes: [Video]
    
    init(sizes: [Video]) {
        self.sizes = sizes
    }
    
    init(_ json: JSON) {
        self.sizes = json["sizes"].arrayValue.map { Video($0) }
    }
}

// MARK: - Video
class Video {
    let src: String?
    let width, height: Int
    let type: String?
    let fileSize: Int?
    let url: String?
    
    init(src: String?, width: Int, height: Int, type: String?, fileSize: Int?, url: String?) {
        self.src = src
        self.width = width
        self.height = height
        self.type = type
        self.fileSize = fileSize
        self.url = url
    }
    
    init(_ json: JSON) {
        self.src = json["src"].stringValue
        self.width = json["width"].intValue
        self.height = json["height"].intValue
        self.type = json["type"].stringValue
        self.fileSize = json["file_size"].intValue
        self.url = json["url"].stringValue
    }
}

// MARK: - Link
class Link {
    let url: String
    let title, caption, linkDescription: String
    let photo: LinkPhoto
    let button: Button
    
    init(url: String, title: String, caption: String, linkDescription: String, photo: LinkPhoto, button: Button) {
        self.url = url
        self.title = title
        self.caption = caption
        self.linkDescription = linkDescription
        self.photo = photo
        self.button = button
    }
    
    init(_ json: JSON) {
        self.url = json["url"].stringValue
        self.title = json["title"].stringValue
        self.caption = json["caption"].stringValue
        self.linkDescription = json["link_description"].stringValue
        let photo = json["photo"].self
        self.photo = LinkPhoto(photo)
        let button = json["button"].self
        self.button = Button(button)
    }
}

// MARK: - Button
class Button {
    let title: String
    let action: Action
    
    init(title: String, action: Action) {
        self.title = title
        self.action = action
    }
    
    init(_ json: JSON) {
        self.title = json["title"].stringValue
        let action = json["action"].self
        self.action = Action(action)
    }
}

// MARK: - Action
class Action {
    let type: String
    let url: String
    
    init(type: String, url: String) {
        self.type = type
        self.url = url
    }
    
    init(_ json: JSON) {
        self.type = json["type"].stringValue
        self.url = json["url"].stringValue
    }
    
}

// MARK: - LinkPhoto
class LinkPhoto {
    let id, albumID, ownerID, userID: Int
    let sizes: [Video]
    let text: String
    let date: Int
    
    init(id: Int, albumID: Int, ownerID: Int, userID: Int, sizes: [Video], text: String, date: Int) {
        self.id = id
        self.albumID = albumID
        self.ownerID = ownerID
        self.userID = userID
        self.sizes = sizes
        self.text = text
        self.date = date
    }
    
    init(_ json: JSON) {
        self.id = json["id"].intValue
        self.albumID = json["album_id"].intValue
        self.ownerID = json["owner_id"].intValue
        self.userID = json["user_id"].intValue
        self.sizes = json["sizes"].arrayValue.map { Video($0) }
        self.text =  json["text"].stringValue
        self.date = json["date"].intValue
    }
}


/*
// MARK: - Response
class Messages {
    let count: Int
    let items: [Item]
    
    init(count: Int, items: [Item]) {
        self.count = count
        self.items = items
    }
}

// MARK: - Item
class Item: Codable {
    let conversation: Conversation
    let lastMessage: LastMessage
    
    enum CodingKeys: String, CodingKey {
        case conversation
        case lastMessage
    }
    
    init(conversation: Conversation, lastMessage: LastMessage) {
        self.conversation = conversation
        self.lastMessage = lastMessage
    }
}

// MARK: - Conversation
class Conversation: Codable {
    let peer: Peer
    let inRead, outRead, lastMessageID: Int
    let canWrite: CanWrite
    let chatSettings: ChatSettings?
    let pushSettings: PushSettings?
    
    enum CodingKeys: String, CodingKey {
        case peer
        case inRead
        case outRead
        case lastMessageID
        case canWrite
        case chatSettings
        case pushSettings
    }
    
    init(peer: Peer, inRead: Int, outRead: Int, lastMessageID: Int, canWrite: CanWrite, chatSettings: ChatSettings?, pushSettings: PushSettings?) {
        self.peer = peer
        self.inRead = inRead
        self.outRead = outRead
        self.lastMessageID = lastMessageID
        self.canWrite = canWrite
        self.chatSettings = chatSettings
        self.pushSettings = pushSettings
    }
}

// MARK: - CanWrite
class CanWrite: Codable {
    let allowed: Bool
    
    init(allowed: Bool) {
        self.allowed = allowed
    }
}

// MARK: - ChatSettings
class ChatSettings: Codable {
    let acl: ACL
    let ownerID: Int
    let state, title: String
    let activeIDS: [Int]
    let membersCount: Int
    
    enum CodingKeys: String, CodingKey {
        case acl
        case ownerID
        case state, title
        case activeIDS
        case membersCount
    }
    
    init(acl: ACL, ownerID: Int, state: String, title: String, activeIDS: [Int], membersCount: Int) {
        self.acl = acl
        self.ownerID = ownerID
        self.state = state
        self.title = title
        self.activeIDS = activeIDS
        self.membersCount = membersCount
    }
}

// MARK: - ACL
class ACL: Codable {
    let canChangeInfo, canChangeInviteLink, canChangePin, canInvite: Bool
    let canPromoteUsers, canSeeInviteLink, canModerate: Bool
    
    enum CodingKeys: String, CodingKey {
        case canChangeInfo
        case canChangeInviteLink
        case canChangePin
        case canInvite
        case canPromoteUsers
        case canSeeInviteLink
        case canModerate
    }
    
    init(canChangeInfo: Bool, canChangeInviteLink: Bool, canChangePin: Bool, canInvite: Bool, canPromoteUsers: Bool, canSeeInviteLink: Bool, canModerate: Bool) {
        self.canChangeInfo = canChangeInfo
        self.canChangeInviteLink = canChangeInviteLink
        self.canChangePin = canChangePin
        self.canInvite = canInvite
        self.canPromoteUsers = canPromoteUsers
        self.canSeeInviteLink = canSeeInviteLink
        self.canModerate = canModerate
    }
}

// MARK: - Peer
class Peer: Codable {
    let id: Int
    let type: String
    let localID: Int
    
    enum CodingKeys: String, CodingKey {
        case id, type
        case localID
    }
    
    init(id: Int, type: String, localID: Int) {
        self.id = id
        self.type = type
        self.localID = localID
    }
}

// MARK: - PushSettings
class PushSettings: Codable {
    let noSound: Bool
    let disabledUntil: Int
    let disabledForever: Bool
    
    enum CodingKeys: String, CodingKey {
        case noSound
        case disabledUntil
        case disabledForever
    }
    
    init(noSound: Bool, disabledUntil: Int, disabledForever: Bool) {
        self.noSound = noSound
        self.disabledUntil = disabledUntil
        self.disabledForever = disabledForever
    }
}

// MARK: - LastMessage
class LastMessage: Codable {
    let date, fromID, id, out: Int
    let peerID: Int
    let text: String
    let conversationMessageID: Int
    let fwdMessages: [Messages]
    let ref, refSource: String
    let important: Bool
    let randomID: Int
    let attachments: [Attachment]
    let isHidden: Bool
    
    enum CodingKeys: String, CodingKey {
        case date
        case fromID
        case id, out
        case peerID
        case text
        case conversationMessageID
        case fwdMessages
        case ref
        case refSource
        case important
        case randomID
        case attachments
        case isHidden
    }
    
    init(date: Int, fromID: Int, id: Int, out: Int, peerID: Int, text: String, conversationMessageID: Int, fwdMessages: [Messages], ref: String, refSource: String, important: Bool, randomID: Int, attachments: [Attachment], isHidden: Bool) {
        self.date = date
        self.fromID = fromID
        self.id = id
        self.out = out
        self.peerID = peerID
        self.text = text
        self.conversationMessageID = conversationMessageID
        self.fwdMessages = fwdMessages
        self.ref = ref
        self.refSource = refSource
        self.important = important
        self.randomID = randomID
        self.attachments = attachments
        self.isHidden = isHidden
    }
}

// MARK: - Attachment
class Attachment: Codable {
    let type: String
    let link: Link?
    let doc: Doc?
    
    init(type: String, link: Link?, doc: Doc?) {
        self.type = type
        self.link = link
        self.doc = doc
    }
}

// MARK: - Doc
class Doc: Codable {
    let id, ownerID: Int
    let title: String
    let size: Int
    let ext: String
    let url: String
    let date, type: Int
    let preview: Preview
    let accessKey: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerID
        case title, size, ext, url, date, type, preview
        case accessKey
    }
    
    init(id: Int, ownerID: Int, title: String, size: Int, ext: String, url: String, date: Int, type: Int, preview: Preview, accessKey: String) {
        self.id = id
        self.ownerID = ownerID
        self.title = title
        self.size = size
        self.ext = ext
        self.url = url
        self.date = date
        self.type = type
        self.preview = preview
        self.accessKey = accessKey
    }
}

// MARK: - Preview
class Preview: Codable {
    let photo: PreviewPhoto
    let video: Video
    
    init(photo: PreviewPhoto, video: Video) {
        self.photo = photo
        self.video = video
    }
}

// MARK: - PreviewPhoto
class PreviewPhoto: Codable {
    let sizes: [Video]
    
    init(sizes: [Video]) {
        self.sizes = sizes
    }
}

// MARK: - Video
class Video: Codable {
    let src: String?
    let width, height: Int
    let type: String?
    let fileSize: Int?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case src, width, height, type
        case fileSize
        case url
    }
    
    init(src: String?, width: Int, height: Int, type: String?, fileSize: Int?, url: String?) {
        self.src = src
        self.width = width
        self.height = height
        self.type = type
        self.fileSize = fileSize
        self.url = url
    }
}

// MARK: - Link
class Link: Codable {
    let url: String
    let title, caption, linkDescription: String
    let photo: LinkPhoto
    let button: Button
    
    enum CodingKeys: String, CodingKey {
        case url, title, caption
        case linkDescription
        case photo, button
    }
    
    init(url: String, title: String, caption: String, linkDescription: String, photo: LinkPhoto, button: Button) {
        self.url = url
        self.title = title
        self.caption = caption
        self.linkDescription = linkDescription
        self.photo = photo
        self.button = button
    }
}

// MARK: - Button
class Button: Codable {
    let title: String
    let action: Action
    
    init(title: String, action: Action) {
        self.title = title
        self.action = action
    }
}

// MARK: - Action
class Action: Codable {
    let type: String
    let url: String
    
    init(type: String, url: String) {
        self.type = type
        self.url = url
    }
}

// MARK: - LinkPhoto
class LinkPhoto: Codable {
    let id, albumID, ownerID, userID: Int
    let sizes: [Video]
    let text: String
    let date: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case albumID
        case ownerID
        case userID
        case sizes, text, date
    }
    
    init(id: Int, albumID: Int, ownerID: Int, userID: Int, sizes: [Video], text: String, date: Int) {
        self.id = id
        self.albumID = albumID
        self.ownerID = ownerID
        self.userID = userID
        self.sizes = sizes
        self.text = text
        self.date = date
    }
}
*/
