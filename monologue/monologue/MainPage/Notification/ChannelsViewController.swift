//
//  NotificationViewController.swift
//  Familog
//
//  Created by 刘仕晟 on 2019/10/10.
//
//  The entire file is working for the notification page

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChannelsViewController: UITableViewController {
    
  private let toolbarLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 15)
    return label
  }()
    
    
   
  var currentUser: User!
  private let channelCellIdentifier = "channelCell"
  private var currentChannelAlertController: UIAlertController?
   let uid =  Auth.auth().currentUser!.uid
  private let db = Firestore.firestore()
  
  private var channelReference: CollectionReference {
    return db.collection("channels")
  }
  
  private var channels = [Channel]()
  private var channelListener: ListenerRegistration?
  
 
  
  deinit {
    channelListener?.remove()
  }
  

  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchUser()
    clearsSelectionOnViewWillAppear = true
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: channelCellIdentifier)
    
    toolbarItems = [
     
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      UIBarButtonItem(customView: toolbarLabel),
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed)),
    ]
    toolbarLabel.text = "jim"
    
    channelListener = channelReference.addSnapshotListener { querySnapshot, error in
      guard let snapshot = querySnapshot else {
        print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
        return
      }
      
      snapshot.documentChanges.forEach { change in
        self.handleDocumentChange(change)
      }
    }
  }
    
    func fetchUser(){
        Api.User.observeCurrentUser(){
            user in
            self.currentUser = user
        }
    }
    
    
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.isToolbarHidden = false
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.isToolbarHidden = true
  }
  
  // MARK: - Actions
  
  
  
  @objc private func addButtonPressed() {
    let ac = UIAlertController(title: "Create a new Channel", message: nil, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    ac.addTextField { field in
      field.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
      field.enablesReturnKeyAutomatically = true
      field.autocapitalizationType = .words
      field.clearButtonMode = .whileEditing
      field.placeholder = "Channel name"
      field.returnKeyType = .done
      field.tintColor = .primary
    }
    
    let createAction = UIAlertAction(title: "Create", style: .default, handler: { _ in
      self.createChannel()
    })
    createAction.isEnabled = false
    ac.addAction(createAction)
    ac.preferredAction = createAction
    
    present(ac, animated: true) {
      ac.textFields?.first?.becomeFirstResponder()
    }
    currentChannelAlertController = ac
  }
  
  @objc private func textFieldDidChange(_ field: UITextField) {
    guard let ac = currentChannelAlertController else {
      return
    }
    
    ac.preferredAction?.isEnabled = field.hasText
  }
  
  // MARK: - Helpers
  
  private func createChannel() {
    guard let ac = currentChannelAlertController else {
      return
    }
    
    guard let channelName = ac.textFields?.first?.text else {
      return
    }
    
    let channel = Channel(name: channelName)
    channelReference.addDocument(data: channel.representation) { error in
      if let e = error {
        print("Error saving channel: \(e.localizedDescription)")
      }
    }
  }
  
  private func addChannelToTable(_ channel: Channel) {
    guard !channels.contains(channel) else {
      return
    }
    
    channels.append(channel)
    channels.sort()
    
    guard let index = channels.index(of: channel) else {
      return
    }
    tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
  }
  
  private func updateChannelInTable(_ channel: Channel) {
    guard let index = channels.index(of: channel) else {
      return
    }
    
    channels[index] = channel
    tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
  }
  
  private func removeChannelFromTable(_ channel: Channel) {
    guard let index = channels.index(of: channel) else {
      return
    }
    
    channels.remove(at: index)
    tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
  }
  
  private func handleDocumentChange(_ change: DocumentChange) {
    guard let channel = Channel(document: change.document) else {
      return
    }
    
    switch change.type {
    case .added:
      addChannelToTable(channel)
      
    case .modified:
      updateChannelInTable(channel)
      
    case .removed:
      removeChannelFromTable(channel)
    }
  }
  
}

// MARK: - TableViewDelegate

extension ChannelsViewController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return channels.count
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 55
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: channelCellIdentifier, for: indexPath)
    
    cell.accessoryType = .disclosureIndicator
    cell.textLabel?.text = channels[indexPath.row].name
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let channel = channels[indexPath.row]
    print("currentUser")

    let vc = ChatViewController(user: currentUser, channel: channel)
    navigationController?.pushViewController(vc, animated: true)
  }
}
