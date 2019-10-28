//
//  Post.swift
//  Familog
//
//  Created by Ziyuan on 18/09/19.
//
//In this file, we will create a class, each instance of which holds the data of a post we retrieve from the database.

import Foundation
class Post {
    // the discription of Post
    var discription: String?
    // The url of post image
    var url: String?
    //The unique id of post
    var uid: String?
    // the user's id of post owner
    var userId : String?
    // family id of this post
    var familyId : String?
    // the time information of this post
    var timestamp : Int?
    //all comment id of this post
    var commentsIDList : [String] = []
    //image recognition result
    var predictItem : String?
    //image recognition result
    var predictAcc : String?
}

// Unlike using initializers, here we use different methods with distinctly meaningful name for
// creating corresponding post instances.
extension Post {
    static func transformPostPhoto(dict: [String: Any]) -> Post {
        let post = Post()
        
        post.uid = dict["uid"] as? String
        post.discription = dict["description"] as? String
        post.url = dict["url"] as? String
        post.userId = dict["userId"] as? String
        post.timestamp = dict["timestamp"] as? Int
        post.predictItem = dict["predictType"] as? String
        post.predictAcc = dict["predictAcc"] as? String
        return post
    }
}
