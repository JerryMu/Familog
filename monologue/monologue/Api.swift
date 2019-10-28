//
//  Api.swift
//  Familog
//
//  Created by Pengyu Mu on 19/9/19.
//
// get all other Apis form this class

import Foundation

import Foundation
struct Api {
    static var User = UserApi()
    static var Post = PostApi()
    static var Family = FamilyApi()
    static var Comment = CommentApi()
    static var Move = MoveApi()
    static var Post_Comment = Post_CommentApi()
    
}
