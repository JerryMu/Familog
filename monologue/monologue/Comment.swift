//
//  Comment.swift
//  Familog
//
//  Created by 刘仕晟 on 2019/10/6.
//

import Foundation
class Comment {
    var commentText: String?
    var uid: String?
    
    init(commentText: String, uid: String){
        self.commentText = commentText
        self.uid = uid
    }
}

extension Comment {
    static func transformComment(dict: [String: Any]) -> Comment {
        let comment = Comment(commentText: "", uid: "")
        comment.commentText = dict["commentText"] as? String
        comment.uid = dict["uid"] as? String
        return comment
    }
}
