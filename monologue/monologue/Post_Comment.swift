//
//  Post_Comment.swift
//  Familog
//
//  Created by 刘仕晟 on 2019/10/8.
//

import Foundation
class Post_Comment{
  
   var commentsID :[String] = []
  
}

// Unlike using initializers, here we use different methods with distinctly meaningful name for
// creating corresponding post instances.


// If we want a video post instance, we can call a static method called transform-Post-Video()
extension Post_Comment {
    static func transformPost_Comment(dict: [String: Any]) -> Post_Comment {
        let post_comment = Post_Comment()
        
     //   post_comment.postid = dict["uid"] as? String
      
        post_comment.commentsID = dict["commentsID"] as! [String]
         
        return  post_comment
    }
   
}
