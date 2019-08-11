//
//  Messages.swift
//  ProjectVK
//
//  Created by Igor on 07/08/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import Foundation
import SwiftyJSON

class Messages {
    let date: Int
    let fromID: Int
    let id: Int
    let out: Int
    let peerID: Int
    let text: String
    let conversationMessageID: Int
    let fwdMessages: [Chats]
    let ref: String
    let refSource: String
    let important: Bool
    let randomID: Int
    let attachments: [Attachment]
    let replyMessage: ReplyMessage
    
    init(date: Int, fromID: Int, id: Int, out: Int, peerID: Int, text: String, conversationMessageID: Int, fwdMessages: [Chats], ref: String, refSource: String, important: Bool, randomID: Int, attachments: [Attachment], replyMessage: ReplyMessage) {
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
        self.replyMessage = replyMessage
    }
}

class MessagesResponse {
    let count: Int
    let items: [MessageItems]
    let conversations: [Conversations]
    let profiles: [FriendProfile]
    let groups: [Group]
    
    init(_ json: JSON) {
        self.count = json["count"].intValue
        self.items = json["items"].arrayValue.map { MessageItems($0) }
        self.conversations = json["conversations"].arrayValue.map { Conversations($0) }
        self.profiles = json["profiles"].arrayValue.map { FriendProfile($0) }
        self.groups = json["groups"].arrayValue.map { Group($0) }
    }
}

class Conversations {
    let peer: Peer
    let inRead: Int
    let outRead: Int
    let lastMessageID: Int
    let canWrite: Bool
    
    init(_ json: JSON) {
        let peer = json["peer"].self
        self.peer = Peer(peer)
        self.inRead = json["in_read"].intValue
        self.outRead = json["out_read"].intValue
        self.lastMessageID = json["last_message_id"].intValue
        self.canWrite = json["can_write"]["allowed"].boolValue

    }
}

class MessageItems {
    let date: Int
    let fromID: Int
    let id: Int
    let out: Int
    let peerID: Int
    let text: String
    let conversationMessageID: Int
    let fwdMessages: [Chats]
    let ref, refSource: String
    let important: Bool
    let randomID: Int
    let attachments: [Attachment]
    let isHidden: Bool
    let replyMessage: ReplyMessage
    
    init(_ json: JSON) {
        self.date = json["date"].intValue
        self.fromID = json["from_id"].intValue
        self.id = json["id"].intValue
        self.out = json["out"].intValue
        self.peerID = json["peer_id"].intValue
        self.text = json["text"].stringValue
        self.conversationMessageID = json["conversation_message_id"].intValue
        self.fwdMessages = json["fwd_messages"].arrayValue.map { Chats($0) }
        self.ref = json["ref"].stringValue
        self.refSource = json["ref_source"].stringValue
        self.important = json["important"].boolValue
        self.randomID = json["random_id"].intValue
        self.attachments = json["attachments"].arrayValue.map { Attachment($0) }
        self.isHidden = json["is_hidden"].boolValue
        let replyMessage = json["reply_message"].self
        self.replyMessage = ReplyMessage(replyMessage)
    }
}

class ReplyMessage {
    let date: Int
    let fromID: Int
    let text: String
    let attachments: [Attachment]
    let conversationMessageID: Int
    let peerID: Int
    let id: Int
    
    init(_ json: JSON) {
        self.date = json["date"].intValue
        self.fromID = json["from_id"].intValue
        self.text = json["text"].stringValue
        self.attachments = json["attachments"].arrayValue.map { Attachment($0) }
        self.conversationMessageID = json["conversation_message_id"].intValue
        self.peerID = json["peer_id"].intValue
        self.id = json["id"].intValue
    }
}


//15 Access denied
//900 Нельзя отправлять сообщение пользователю из черного списка
//901 Пользователь запретил отправку сообщений от имени сообщества
//902 Нельзя отправлять сообщения этому пользователю в связи с настройками приватности
//911 Keyboard format is invalid
//912 This is a chat bot feature, change this status in settings
//913 Слишком много пересланных сообщений
//914 Сообщение слишком длинное
//917 You don't have access to this chat
//921 Невозможно переслать выбранные сообщения
//936 Contact not found
//940 Too many posts in messages
