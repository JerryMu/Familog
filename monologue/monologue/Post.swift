//
//  Post.swift
//  Familog
//
//  Created by Ziyuan on 18/09/19.
//
//In this file, we will create a class, each instance of which holds the data of a post we retrieve from the database.

import Foundation
class Post {
    var discription: String?
    var URL: String?
    var uid: String?
    var username: String?
    var userId : String?
    var familyId : String?
}

// Unlike using initializers, here we use different methods with distinctly meaningful name for
// creating corresponding post instances.


// If we want a video post instance, we can call a static method called transform-Post-Video()
extension Post {
    static func transformPostPhoto(dict: [String: Any]) -> Post {
        let post = Post()
        post.discription = dict["discription"] as? String
        post.URL = dict["URL"] as? String
        post.username = dict["username"] as? String
        return post
    }
    
    static func transformPostVideo() {
        
    }
}
