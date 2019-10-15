//  Familog
//
//  Created by 刘仕晟 on 2019/10/6.
//

import UIKit
import Photos
import Firebase
import MessageKit
import FirebaseFirestore
import InputBarAccessoryView

final class ChatViewController: MessagesViewController {
   let initImage =  #imageLiteral(resourceName: "Head_Icon")
  private var isSendingPhoto = false /* {
   didSet {
      DispatchQueue.main.async {
       self.messageInputBar.leftStackViewItems.forEach { item in
        item. = !self.isSendingPhoto
        }
     
      }
    }
  }*/
  
  private let db = Firestore.firestore()
  private var reference: CollectionReference?
  private let storage = Storage.storage().reference()
    var imageView:UIImageView! = UIImageView()
  private var messages: [Message] = []
  private var messageListener: ListenerRegistration?
  
  private let user: User
  private let channel: Channel
  
  deinit {
    messageListener?.remove()
  }

  init(user: User, channel: Channel) {
    self.user = user
    self.channel = channel
    super.init(nibName: nil, bundle: nil)
    
    title = channel.name
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    func fetchUser(uid: String, completed:  @escaping () -> Void ) {
        
                Api.User.observeUser(withId: uid, completion: {
                  user in
                  if user.profileImageUrl == "" {
                   print( "1233211232341234124  \(self.imageView.image)")
                       print("rexxxxachchhchdaifcojweoa")
                       self.imageView.image = self.initImage
                   
                  } else{
                   let photoUrlString = user.profileImageUrl
                   self.imageView.sd_setImage(with: URL(string: photoUrlString! ))}
                  completed()
              })

    }


  
  override func viewDidLoad() {
    super.viewDidLoad()
        
       
        
    guard let id = channel.id else {
      navigationController?.popViewController(animated: true)
      return
    }

    reference = db.collection(["channels", id, "thread"].joined(separator: "/"))
    
    messageListener = reference?.addSnapshotListener { querySnapshot, error in
      guard let snapshot = querySnapshot else {
        print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
        return
      }
      
      snapshot.documentChanges.forEach { change in
        self.handleDocumentChange(change)
      }
    }
    configureMessageInputBar()
    navigationItem.largeTitleDisplayMode = .never
    
    maintainPositionOnKeyboardFrameChanged = true
    messageInputBar.inputTextView.tintColor = .primary
    messageInputBar.sendButton.setTitleColor(.primary, for: .normal)
    
    messageInputBar.delegate = self
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self
    
    let cameraItem = makeButton(named: "ic_hashtag") // 1
 //   cameraItem.tintColor = .primary
//    cameraItem.image = #imageLiteral(resourceName: "addNew")
    cameraItem.addTarget(
      self,
      action: #selector(cameraButtonPressed), // 2
      for: .primaryActionTriggered
    )
    cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
    
    messageInputBar.leftStackView.alignment = .center
    messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
    messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false) // 3
    
  // self.messagesCollectionView.scrollToBottom()
  }
     func configureMessageInputBar() {
       messageInputBar.delegate = self
          messageInputBar.inputTextView.tintColor = .primaryColor
          messageInputBar.sendButton.setTitleColor(.primaryColor, for: .normal)
          messageInputBar.sendButton.setTitleColor(
              UIColor.primaryColor.withAlphaComponent(0.3),
              for: .highlighted
          )
        messageInputBar.layer.shadowColor = UIColor.black.cgColor
        messageInputBar.layer.shadowRadius = 4
        messageInputBar.layer.shadowOpacity = 0.3
        messageInputBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.setRightStackViewWidthConstant(to: 0, animated: false)
        configureMessageInputBarForChat()
    }
    private func configureMessageInputBarForChat() {
        messageInputBar.setMiddleContentView(messageInputBar.inputTextView, animated: false)
        messageInputBar.setRightStackViewWidthConstant(to: 52, animated: false)
  
//change on send button
        messageInputBar.sendButton.activityViewColor = .white
        messageInputBar.sendButton.backgroundColor = .primaryColor
        messageInputBar.sendButton.layer.cornerRadius = 10
        messageInputBar.sendButton.setTitleColor(.white, for: .normal)
        messageInputBar.sendButton.setTitleColor(UIColor(white: 1, alpha: 0.3), for: .highlighted)
        messageInputBar.sendButton.setTitleColor(UIColor(white: 1, alpha: 0.3), for: .disabled)
        messageInputBar.sendButton
            .onSelected { item in
                item.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }.onDeselected { item in
                item.transform = .identity
        }
    }
    private func makeButton(named: String) -> InputBarButtonItem {
          return InputBarButtonItem()
              .configure {
                  $0.spacing = .fixed(10)
                  $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
                  $0.setSize(CGSize(width: 25, height: 25), animated: false)
                  $0.tintColor = UIColor(white: 0.8, alpha: 1)
              }.onSelected {
                  $0.tintColor = .primaryColor
              }.onDeselected {
                  $0.tintColor = UIColor(white: 0.8, alpha: 1)
              }.onTouchUpInside { _ in
                  print("Item Tapped")
          }
      }
  
  // MARK: - Actions
  func downloadImage(from url: URL) {
      print("Download Started")
      getData(from: url) { data, response, error in
          guard let data = data, error == nil else { return }
          print(response?.suggestedFilename ?? url.lastPathComponent)
          print("Download Finished")
          DispatchQueue.main.async() {
            self.imageView.image = UIImage(data: data)!
          }
      }
  }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
  @objc private func cameraButtonPressed() {
    let picker = UIImagePickerController()
    picker.delegate = self
    
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      picker.sourceType = .camera
    } else {
      picker.sourceType = .photoLibrary
    }
    
    present(picker, animated: true, completion: nil)
  }
  
  // MARK: - Helpers
  
  private func save(_ message: Message) {
       
    reference?.addDocument(data: message.representation) { error in
      if let e = error {
        print("Error sending message: \(e.localizedDescription)")
        return
      }
      
      self.messagesCollectionView.scrollToBottom()
    }
  }
  
  private func insertNewMessage(_ message: Message) {
    guard !messages.contains(message) else {
      return
    }
    
    messages.append(message)
    messages.sort()
    
    let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
    let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
    
    messagesCollectionView.reloadData()
    
   if shouldScrollToBottom {
      DispatchQueue.main.async {
        self.messagesCollectionView.scrollToBottom(animated: true)
      }
    }
    
  }
  
  private func handleDocumentChange(_ change: DocumentChange) {
    
   let index = change.document.data()
    let FIRdate = index["created"] as! Timestamp
 
    
    if index["url"] != nil {
    
        switch change.type {
        case .added:
           let url = index["url"] as! String
           let trueurl = URL.init(string: url)
            downloadImage(at: trueurl!) { [weak self] image in
              guard let `self` = self else {
                return
              }
              guard let image = image else {
                return
              }
                guard var message = Message(id: change.document.documentID, urlString: index["url"] as! String,image:image, senderID: index["senderID"] as! String, sentDate: FIRdate.dateValue() , senderName: index["senderName"] as! String)
                         
                         else {
                         return
                       }
              
              message.image = image
                print(message)
              self.insertNewMessage(message)
            }
          
          
        default:
          break
        }
    }else{
    
        guard var message = Message(id: change.document.documentID, content: index["content"] as! String, senderID: index["senderID"] as! String, sentDate: FIRdate.dateValue() , senderName: index["senderName"] as! String)
      
      else {
      return
    }
        switch change.type {
        case .added:
          if let url = message.downloadURL {
            downloadImage(at: url) { [weak self] image in
              guard let `self` = self else {
                return
              }
              guard let image = image else {
                return
              }
              
              message.image = image
              self.insertNewMessage(message)
            }
          } else {
            insertNewMessage(message)
          }
          
        default:
          break
        }
    }
 
  }
  
  private func uploadImage(_ image: UIImage, to channel: Channel, completion: @escaping (URL?) -> Void) {
    guard let channelID = channel.id else {
      completion(nil)
      return
    }
    
    guard let scaledImage = image.scaledToSafeUploadSize, let data = scaledImage.jpegData(compressionQuality: 0.4) else {
      completion(nil)
      return
    }
    
    let metaData = StorageMetadata()
    metaData.contentType = "image/jpeg"
    
    let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
     let storageRef = storage.child(channelID).child(imageName)
    
    storageRef.putData(data, metadata: metaData) { metaData, error in
           if error == nil, metaData != nil {

               storageRef.downloadURL { url, error in
                   completion(url)
                   // success!
               }
               } else {
                   // failed
                   completion(nil)
               }
           }
    
  
    }
  

  private func sendPhoto(_ image: UIImage) {
    isSendingPhoto = true
    
    uploadImage(image, to: channel) { [weak self] url in
      guard let `self` = self else {
        return
      }
      self.isSendingPhoto = false
      
      guard let url = url else {
        return
      }
      
      var message = Message(user: self.user, image: image)
      message.downloadURL = url
      
      self.save(message)
      self.messagesCollectionView.scrollToBottom()
    }
  }
  
  private func downloadImage(at url: URL, completion: @escaping (UIImage?) -> Void) {
    let ref = Storage.storage().reference(forURL: url.absoluteString)
    
    
    let megaByte = Int64(1 * 1024 * 1024)
    
    ref.getData(maxSize: megaByte) { data, error in
      guard let imageData = data else {
        completion(nil)
        return
      }
      
      completion(UIImage(data: imageData))
    }
  }
  
}

// MARK: - MessagesDisplayDelegate

extension ChatViewController: MessagesDisplayDelegate {
  
  func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
    return isFromCurrentSender(message: message) ? .primary : .incomingMessage
  }
  
  func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
    return false
  }
  
  func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
    let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
    return .bubbleTail(corner, .curved)
  }
   func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
   print("1")
        let name = message.sender.displayName.components(separatedBy: " ").first
          //
          //     print(user.uid)
        let initials = "\(name)"
        self.fetchUser(uid: message.sender.senderId, completed: {
            let avatar = Avatar(image: self.imageView.image, initials: initials)
            avatarView.set(avatar: avatar)
            })
        
      
             
        self.messagesCollectionView.scrollToBottom()
           
       }
       
    

}

// MARK: - MessagesLayoutDelegate

extension ChatViewController: MessagesLayoutDelegate {
  
  func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
    return .zero
  }
  
  func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
    return CGSize(width: 0, height: 8)
  }
  
  func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    
    return 0
  }
  
}

// MARK: - MessagesDataSource

extension ChatViewController: MessagesDataSource {
  func currentSender() -> SenderType {
    return Sender(id: user.uid!, displayName: "jim")
  }
  
  func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
   return  messages.count
  }
  
  
 
  

  
  func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
    return messages[indexPath.section]
  }
  
  func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
    let name = message.sender.displayName
    return NSAttributedString(
      string: name,
      attributes: [
        .font: UIFont.preferredFont(forTextStyle: .caption1),
        .foregroundColor: UIColor(white: 0.3, alpha: 1)
      ]
    )
  }
  
}

// MARK: - MessageInputBarDelegate

extension ChatViewController: MessageInputBarDelegate {
  
  func inputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
  
    let message = Message(user: user, content: text)

    save(message)
    inputBar.inputTextView.text = ""
  }
  
}

// MARK: - UIImagePickerControllerDelegate

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    picker.dismiss(animated: true, completion: nil)
    
    if let asset = info[.phAsset] as? PHAsset { // 1
      let size = CGSize(width: 500, height: 500)
      PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: nil) { result, info in
        guard let image = result else {
          return
        }
        
        self.sendPhoto(image)
      }
    } else if let image = info[.originalImage] as? UIImage { // 2
      sendPhoto(image)
    }
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
}
