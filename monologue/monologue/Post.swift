//
//  Post.swift
//  Familog
//
//  Created by Ziyuan on 18/09/19.
//


//In this file, we will create a class, each instance of which holds the data of a post we retrieve from the database.
import Foundation
class Post {
    var caption: String?
    var photoUrl: String?
    var videoUrl: String?
}




// Unlike using initializers, here we use different methods with distinctly meaningful name for
// creating corresponding post instances.


// If we want a video post instance, we can call a static method called transform-Post-Video()
extension Post {
    static func transformPostPhoto(dict: [String: Any]) -> Post {
        let post = Post()
        
        post.caption = dict["caption"] as? String
        post.photoUrl = dict["photoUrl"] as? String
        return post
    }
    
    static func transformPostVideo() {
        
    }
}
