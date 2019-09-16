//
//  Artifacts.swift
//  Familog
//
//  Created by Pengyu Mu on 12/9/19.
//

import Foundation
import FirebaseAuth
class Artifacts {
    var caption: String?
    var photoUrl: String?
    var uid: String?
    var id: String?
    var likeCount: Int?
    var likes: Dictionary<String, Any>?
    var isLiked: Bool?
    var ratio: CGFloat?
    var videoUrl: String?
}

extension Artifacts {
    static func transformPostPhoto(dict: [String: Any], key: String) -> Artifacts {
        let post = Artifacts()
        post.id = key
        post.caption = dict["caption"] as? String
        post.photoUrl = dict["photoUrl"] as? String
        post.videoUrl = dict["videoUrl"] as? String
        post.uid = dict["uid"] as? String
        post.likeCount = dict["likeCount"] as? Int
        post.likes = dict["likes"] as? Dictionary<String, Any>
        post.ratio = dict["ratio"] as? CGFloat
        if let currentUserId = Auth.auth().currentUser?.uid {
            if post.likes != nil {
                post.isLiked = post.likes![currentUserId] != nil
            }
        }
        
        return post
    }
    
    static func transformPostVideo() {
        
    }
}
