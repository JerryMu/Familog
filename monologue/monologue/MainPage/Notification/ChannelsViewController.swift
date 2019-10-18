//
//  NotificationViewController.swift
//  Familog
//
//  Created by shisheng liu on 2019/10/10.
//
//  The entire file is working for the notification page

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChannelsViewController: UITableViewController {
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
    setCustomebBackImage()
  }
  func fetchUser(){
        Api.User.observeCurrentUser(){
            user in
            self.currentUser = user
            self.clearsSelectionOnViewWillAppear = true
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.channelCellIdentifier)
            self.channelListener = self.channelReference.addSnapshotListener { querySnapshot, error in
              guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
              }
              snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
              }
            }
        }
    }
    
    
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.isToolbarHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.isToolbarHidden = true
  }
  
  // MARK: - Actions

  func setCustomebBackImage(){
      navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
  @objc private func textFieldDidChange(_ field: UITextField) {
    guard let ac = currentChannelAlertController else {
      return
    }
    
    ac.preferredAction?.isEnabled = field.hasText
  }
  
  // MARK: - Helpers
  
  
  private func addChannelToTable(_ channel: Channel) {
    guard !channels.contains(channel) else {
      return
    }
    guard let userFamilies = self.currentUser.families else {
        return
    }
   
    if(userFamilies.contains(channel.id!)){
        channels.append(channel)
        channels.sort()
    }
    
    guard let index = channels.firstIndex(of: channel) else {
      return
    }
    tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
  }
  
  private func updateChannelInTable(_ channel: Channel) {
    guard let index = channels.firstIndex(of: channel) else {
      return
    }
    
    channels[index] = channel
    tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
  }
  
  private func removeChannelFromTable(_ channel: Channel) {
    guard let index = channels.firstIndex(of: channel) else {
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


    let vc = ChatViewController(user: currentUser, channel: channel)
    navigationController?.pushViewController(vc, animated: true)
  }
}
