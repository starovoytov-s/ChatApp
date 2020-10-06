//
//  ConversationModels.swift
//  ChatApp
//
//  Created by Stanislav Starovoytov on 06.10.2020.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}
