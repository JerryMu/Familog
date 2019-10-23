//
//  Post_Comment.swift
//  Familog
//
//  Created by shisheng liu on 2019/10/8.
//
import Foundation


class Post_Comment{
    var commentsID :[String] = []
 }


extension Post_Comment {
    // get the information  a Post_Comment needed from dictionary
    static func transformPost_Comment(dict: [String: Any]) -> Post_Comment {
        let post_comment = Post_Comment()
        post_comment.commentsID = dict["commentsID"] as! [String]
        return  post_comment
    }
}
