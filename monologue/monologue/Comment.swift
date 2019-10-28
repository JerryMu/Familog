//
//  Comment.swift
//  Familog
//
//  Created by shisheng liu on 2019/10/6.
//
// The comment class

import Foundation
class Comment {
    //comment text
    var commentText: String?
    //comment id
    var uid: String?
    //comment time stamp
    var timestamp : Int?
    init(commentText: String, uid: String){
        self.commentText = commentText
        self.uid = uid
    }
}

extension Comment {
    // get the information  a comment needed from dictionary
    static func transformComment(dict: [String: Any]) -> Comment {
        let comment = Comment(commentText: "", uid: "")
        comment.commentText = dict["commentText"] as? String
        comment.uid = dict["uid"] as? String
        comment.timestamp = dict["timestamp"] as? Int
        return comment
    }
}
