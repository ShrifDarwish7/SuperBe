//
//  ConversationResponse.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 05/08/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ConversationResponse: Codable {
    let status: Int
    let data: Conversation
    let message: String
}

// MARK: - DataClass
struct Conversation: Codable {
    let id, orderID: Int?
    let title, status: String?
    let isLocked, userOneID, userTwoID: Int?
    let deletedAt: String?
    let createdAt, updatedAt: String?
    let userOne, userTwo: User?
    let messages: [Message]?

    enum CodingKeys: String, CodingKey {
        case id, title, status
        case isLocked = "is_locked"
        case userOneID = "user_one_id"
        case userTwoID = "user_two_id"
        case orderID = "order_id"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userOne = "user_one"
        case userTwo = "user_two"
        case messages
    }
}

// MARK: - Message
struct Message: Codable {
    let id, isSeen, deletedFromSender, deletedFromReceiver: Int?
    let body: String?
    let senderID, conversationID: Int?
    let deletedAt: String?
    let createdAt, updatedAt: String?
    var delivered: Bool = true
    var incrementalId: Int = 0
    
    init(id: Int? = nil, isSeen: Int? = nil, deletedFromSender: Int? = nil, deletedFromReceiver: Int? = nil, body: String? = nil, senderID: Int? = nil, conversationID: Int? = nil, deletedAt: String? = nil, createdAt: String? = nil, updatedAt: String? = nil, delivered: Bool = true, incrementalId: Int = 0) {
        self.id = id
        self.isSeen = isSeen
        self.deletedFromSender = deletedFromSender
        self.deletedFromReceiver = deletedFromReceiver
        self.body = body
        self.senderID = senderID
        self.conversationID = conversationID
        self.deletedAt = deletedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.delivered = delivered
        self.incrementalId = incrementalId
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case isSeen = "is_seen"
        case deletedFromSender = "deleted_from_sender"
        case deletedFromReceiver = "deleted_from_receiver"
        case body
        case senderID = "sender_id"
        case conversationID = "conversation_id"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
