//  Familog
//
//  Created by shisheng liu on 2019/10/6.
//


import Firebase
import MessageKit
import FirebaseFirestore

// use ImageMediaItem to initialise image item
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

// the struct of a message
struct Message: MessageType {
    var sender: SenderType
    var user: ChatUser
    var kind: MessageKind
    let id: String?
    let content: String
    let sentDate: Date
    // create an unique messageId to each message
    var messageId: String {
    return `id` ?? UUID().uuidString
    }
    var image: UIImage? = nil
    var downloadURL: URL? = nil
    // initialise it if it is an image
    init?(id: String, urlString: String,image: UIImage, senderID: String, sentDate: Date ,senderName : String) {
        let mediaItem = ImageMediaItem(image: image)
        sender = Sender(id: senderID, displayName: senderName)
        self.content = ""
        // get its url
        if let url = URL(string: urlString) {
            downloadURL = url
        }else {
            return nil
        }
        self.sentDate = sentDate
        self.id = id
        self.kind = .photo(mediaItem)
        self.user = ChatUser(senderId: senderID, displayName: senderName)
    }
    
    
    // initialise it if its type is text
    init(user: User, content: String) {
        sender = Sender(id: user.uid!, displayName: user.firstname!)
        self.content = content
        sentDate = Date()
        id = nil
        self.kind = .text(content)
        self.user = ChatUser(senderId: user.uid!, displayName: user.firstname!)
    }
  
    
   // initialise it if its type is text
    init?(id: String, content: String, senderID: String, sentDate: Date ,senderName : String) {
        sender = Sender(id: senderID, displayName: senderName)
        self.content = content
        downloadURL = nil
        self.sentDate = sentDate
        self.id = id
        self.kind = .text(content)
        self.user = ChatUser(senderId: senderID, displayName: senderName)
    }
    

   // initialise it if it is an image
    init(user: User, image: UIImage, id: String, sentDate: Date ) {
        let mediaItem = ImageMediaItem(image: image)
        sender = Sender(id: user.uid!, displayName: user.firstname!)
        self.image = image
        content = ""
        self.sentDate = sentDate
        self.id = id
        self.kind = .photo(mediaItem)
        self.user = ChatUser(senderId: user.uid!, displayName: user.firstname!)
    }
    
    
     // initialise it if it is an image
    init(user: User, image: UIImage) {
        let mediaItem = ImageMediaItem(image: image)
        sender = Sender(id: user.uid!, displayName: user.firstname!)
        self.image = image
        content = ""
        sentDate = Date()
        id = nil
        self.kind = .photo(mediaItem)
        self.user = ChatUser(senderId: user.uid!, displayName: user.firstname!)
        
    }
}

// MARK: - DatabaseRepresentation
// store message in the form of dictionary
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

// MARK: - Comparable
// compare messages based on their ids or sentDates
extension Message: Comparable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}

