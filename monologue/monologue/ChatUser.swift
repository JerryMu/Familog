//
//  ChatUser.swift
//  Familog
//
//  Created by shisheng liu on 2019/10/12.
//


import Foundation
import MessageKit
//created for user in chatting
struct ChatUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
