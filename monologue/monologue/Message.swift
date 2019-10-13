//  Familog
//
//  Created by 刘仕晟 on 2019/10/6.
//

import Firebase
import MessageKit
import FirebaseFirestore

private struct ImageMediaItem: MediaItem {

    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
  
    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }

}
struct Message: MessageType {
  var sender: SenderType
  
    var kind: MessageKind
  let id: String?
  let content: String
  let sentDate: Date

  

  
  var messageId: String {
    return `id` ?? UUID().uuidString
  }
  
  var image: UIImage? = nil
  var downloadURL: URL? = nil
  /* init?(document: QueryDocumentSnapshot) {
     let data = document.data()
     
     guard let sentDate = data["created"] as? Date else {
       return nil
     }
     guard let senderID = data["senderID"] as? String else {
       return nil
     }
     guard let senderName = data["senderName"] as? String else {
       return nil
     }
     
     id = document.documentID
     
     self.sentDate = sentDate
     sender = Sender(id: senderID, displayName: senderName)
     
     if let content = data["content"] as? String {
       self.content = content
       downloadURL = nil
     } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
       downloadURL = url
       content = ""
     } else {
       return nil
     }
   }*/
  init(user: User, content: String) {
    sender = Sender(id: user.uid!, displayName: "jim")
    self.content = content
    sentDate = Date()
     id = nil
    self.kind = .text(content)
  }
  
  
  init?(id: String, content: String, senderID: String, sentDate: Date ,senderName : String) {
    sender = Sender(id: senderID, displayName: senderName)
    self.content = content
    downloadURL = nil

     self.sentDate = sentDate
     self.id = id
    self.kind = .text(content)
  }
  
  init(user: User, image: UIImage, id: String, sentDate: Date ) {
    let mediaItem = ImageMediaItem(image: image)
    sender = Sender(id: user.uid!, displayName: "jim")
    self.image = image
    content = ""
    self.sentDate = sentDate
    self.id = id
    self.kind = .photo(mediaItem)
  }
  init(user: User, image: UIImage) {
    let mediaItem = ImageMediaItem(image: image)
    sender = Sender(id: user.uid!, displayName: "jim")
    self.image = image
    content = ""
      sentDate = Date()
       id = nil
    self.kind = .photo(mediaItem)
  }


  
}

extension Message: DatabaseRepresentation {
  
  var representation: [String : Any] {
    var rep: [String : Any] = [
      "created": sentDate,
      "senderID": sender.senderId,
      "senderName": sender.displayName
    ]
    
    if let url = downloadURL {
      rep["url"] = url.absoluteString
    } else {
      rep["content"] = content
    }
    
    return rep
  }
  
}

extension Message: Comparable {
  
  static func == (lhs: Message, rhs: Message) -> Bool {
    return lhs.id == rhs.id
  }
  
  static func < (lhs: Message, rhs: Message) -> Bool {
    return lhs.sentDate < rhs.sentDate
  }
  
}

