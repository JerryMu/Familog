//  Familog
//
//  Created by shisheng liu on 2019/10/6.
//

import UIKit
import Photos
import Firebase
import MessageKit
import FirebaseFirestore
import InputBarAccessoryView
import YPImagePicker
import ProgressHUD
import Lightbox


final class ChatViewController: MessagesViewController {
    let initImage =  #imageLiteral(resourceName: "Head_Icon")
    private var isSendingPhoto = false
    var selectImage : UIImage?
    private let db = Firestore.firestore()
    private var reference: CollectionReference?  
    private let storage = Storage.storage().reference()
    var imageView : UIImageView! = UIImageView()
    var avatarView : UIImageView! = UIImageView()
    private var messages: [Message] = []
    private var messageListener: ListenerRegistration?
    private let user: User
    private let channel: Channel
    private var massageNumber = 15
    var refreshControl = UIRefreshControl()
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
    // fetch the information of the user and set avatar
    func fetchUser(uid: String, completed:  @escaping () -> Void ) {
        Api.User.observeUser(withId: uid, completion: {
            user in
            if user.profileImageUrl == "" {
                self.avatarView.image = self.initImage
                } else{
                let photoUrlString = user.profileImageUrl
                    self.avatarView.sd_setImage(with: URL(string: photoUrlString! ))}
            completed()
              })
    }
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchmessages()
        configureMessageInputBar()
        initialize()
    }

    func initialize(){
    //initialize the information of the chat interface
        navigationItem.largeTitleDisplayMode = .never
        scrollsToBottomOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = .primary
        messageInputBar.sendButton.setTitleColor(.primary, for: .normal)
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
     //initialize camera item
        let cameraItem = makeButton(named: "addPic")
        cameraItem.addTarget(
            self,
            action: #selector(cameraButtonPressed),
            for: .primaryActionTriggered
        )
        cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        messagesCollectionView.addSubview(refreshControl)
    }
    
    
    
    // refresh the page
    @objc func refresh() {
        self.massageNumber += 15
        fetchmessages()
        refreshControl.endRefreshing()
    }
    
    // fetch all the messages
    func fetchmessages(){
        guard let id = channel.id else {
            navigationController?.popViewController(animated: true)
            return
        }
        self.reference = db.collection("channels").document(id).collection("thread")
        let reference = db.collection("channels").document(id).collection("thread").order(by: "created", descending: true).limit(to: massageNumber)
        messageListener = reference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
                self.messagesCollectionView.reloadDataAndKeepOffset()
            }
        }
    }
    
 //configure Message InputBar
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
    
// configure Message InputBar ForChat
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
    
    // configure send button
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
// download image from url
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
        guard let data = data, error == nil else { return }
        DispatchQueue.main.async() {
            self.imageView.image = UIImage(data: data)!
        }
      }
  }
    
    // get data baswd on url
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // if camera button is pressed
   @objc private func cameraButtonPressed() {
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.selectImage = photo.image
                self.sendPhoto(self.selectImage!)
            }
        picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
  
  // MARK: - Helpers
  // if send button is tapped ,save the mesage and scroll To Bottom
    private func save(_ message: Message) {
        reference?.addDocument(data: message.representation) { error in
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
                return
            }
            self.messagesCollectionView.scrollToBottom(animated: false)
        }
    }
  
  // insert new message
    private func insertNewMessage(_ message: Message) {
        guard !messages.contains(message) else {
            return
        }
        messages.append(message)
        messages.sort()
        messagesCollectionView.reloadData()
    }
 
    // if the data of messages in the database has changed,insert new message
    private func handleDocumentChange(_ change: DocumentChange) {
        let index = change.document.data()
        let FIRdate = index["created"] as! Timestamp
        if index["url"] != nil {
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
                self.insertNewMessage(message)
                }
        }else{
            guard var message = Message(id: change.document.documentID, content: index["content"] as! String, senderID: index["senderID"] as! String, sentDate: FIRdate.dateValue() , senderName: index["senderName"] as! String)
                else {
                    return
                }
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
        }
    }
  
    // upload the image
    private func uploadImage(_ image: UIImage, to channel: Channel, completion: @escaping (URL?) -> Void) {
        guard let channelID = channel.id else {
            completion(nil)
            return
        }
        guard let scaledImage = image.scaledToSafeUploadSize, let data = scaledImage.jpegData(compressionQuality: 0.1) else {
            completion(nil)
            return
        }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let storageRef = storage.child(channelID).child(imageName)
        storageRef.putData(data, metadata: metaData) { metaData, error in
            // success!
            if error == nil, metaData != nil {
                storageRef.downloadURL { url, error in
                    completion(url)
                }
              // failed
            } else {
                completion(nil)
            }
        }
}
  
    // show photo on the screen
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
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }
  
    // download the image at url
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
    
    
    // return if timelabel is visible
    func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
        return indexPath.section % 3 == 0 && !isPreviousMessageSameSender(at: indexPath)
        }
    
    // return if it is Previous Message Same Sender
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return messages[indexPath.section].user == messages[indexPath.section - 1].user
        }
    
}

// MARK: - MessagesDisplayDelegate

extension ChatViewController: MessagesDisplayDelegate {
  
    // set the backgroudcolor
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .primary : .incomingMessage
    }
  
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
        return false
    }
  // configure message Style
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
    // configure Avatar View
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let initials = "User"
        self.fetchUser(uid: message.sender.senderId, completed: {
            let avatar = Avatar(image: self.avatarView.image, initials: initials)
            avatarView.set(avatar: avatar)
        })
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
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isTimeLabelVisible(at: indexPath) {
            return 18
        }
        return 0
    }
  
}

// MARK: - MessagesDataSource

extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(id: user.uid!, displayName: user.firstname!)
    }
  
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return  messages.count
    }
  
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
  
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isTimeLabelVisible(at: indexPath) {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
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
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

