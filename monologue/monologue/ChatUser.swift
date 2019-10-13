//
//  ChatUser.swift
//  Familog
//
//  Created by 刘仕晟 on 2019/10/12.
//

import Foundation

import MessageKit

struct ChatUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
