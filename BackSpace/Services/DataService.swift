//
//  DataService.swift
//  BackSpace
//
//  Created by Khaled Rahman Ayon on 07/02/2018.
//  Copyright © 2018 Khaled Rahman Ayon. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let shared = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USER = DB_BASE.child("user")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    var REF_USER: DatabaseReference {
        return _REF_USER
    }
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
    
    //create db user
    func createDbUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USER.child(uid).updateChildValues(userData)
    }
    
    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, handler: @escaping handler) {
        if groupKey != nil {
            REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(["content": message, "senderId": uid])
            handler(true, nil)
        } else {
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
            handler(true, nil)
        }
    }
    
    func getAllFeedMsg(handler: @escaping (_ message: [Message]) -> ()) {
        var messageArray = [Message]()
        REF_FEED.observeSingleEvent(of: .value) { (feedMsgSnapShot) in
            guard let feedMsgSnapShot = feedMsgSnapShot.children.allObjects as? [DataSnapshot] else { return }
            
            for message in feedMsgSnapShot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let message = Message(content: content, sender: senderId)
                messageArray.append(message)
            }
            
            handler(messageArray)
        }
    }
    
    func getAllMsg(forGroup group: Group, handler: @escaping (_ messageArray: [Message]) -> ()) {
        var groupMsgArray = [Message]()
        REF_GROUPS.child(group.key).child("messages").observeSingleEvent(of: .value) { (groupMsgSnapShot) in
            guard let groupMsgSnapShot = groupMsgSnapShot.children.allObjects as? [DataSnapshot] else { return }
            for groupMessage in groupMsgSnapShot {
                let content = groupMessage.childSnapshot(forPath: "content").value as! String
                let senderId = groupMessage.childSnapshot(forPath: "senderId").value as! String
                let groupMessage = Message(content: content, sender: senderId)
                groupMsgArray.append(groupMessage)
            }
            handler(groupMsgArray)
        }
    }
    
    func getUserName(forUid uid: String, handler: @escaping (_ userName: String) -> ()) {
        REF_USER.observeSingleEvent(of: .value) { (userSnapShot) in
            guard let userSnapshot = userSnapShot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
    
    func getEmail(withSearchQuery query: String, handler: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        REF_USER.observe(.value) { (userSnapShot) in
            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapShot {
                let email = user.childSnapshot(forPath: "email").value as! String
                if email.contains(query) == true && email != Auth.auth().currentUser?.email {
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    func getIds(forUserName username: [String], handler: @escaping (_ uidArray: [String]) -> ()) {
        REF_USER.observeSingleEvent(of: .value) { (usersSpanShot) in
            var idArray = [String]()
            guard let usersSpanShot = usersSpanShot.children.allObjects as? [DataSnapshot] else { return }
            for user in usersSpanShot {
                let email = user.childSnapshot(forPath: "email").value as! String
                if username.contains(email) {
                    idArray.append(user.key)
                }
            }
            handler(idArray)
        }
    }
    
    func getEmails(forGroup group: Group, handler: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        REF_USER.observeSingleEvent(of: .value) { (emailUserSnapShot) in
            guard let emailUserSnapShot = emailUserSnapShot.children.allObjects as? [DataSnapshot] else { return }
            for user in emailUserSnapShot {
                if group.members.contains(user.key) {
                    let email = user.childSnapshot(forPath: "email").value as! String
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    func createGroup(withTitle title: String, withDescription description: String, forUserIds ids: [String], handler:@escaping handler) {
        REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "members": ids])
        handler(true, nil)
    }
    
    func getAllGroup(handler: @escaping (_ groupsArray: [Group]) -> ()) {
        var groupsArray = [Group]()
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapShot) in
            guard let groupSnapShot = groupSnapShot.children.allObjects as? [DataSnapshot] else { return }
            for group in groupSnapShot {
                let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                if memberArray.contains((Auth.auth().currentUser?.uid)!) {
                    let title = group.childSnapshot(forPath: "title").value as! String
                    let desc = group.childSnapshot(forPath: "description").value as! String
                    
                    let group = Group(title: title, desc: desc, key: group.key, memberCount: memberArray.count, members: memberArray)
                    groupsArray.append(group)
                }
            }
            handler(groupsArray)
        }
    }
}
