//
//  UploadService.swift
//  BackSpace
//
//  Created by Khaled Rahman Ayon on 20.02.18.
//  Copyright © 2018 Khaled Rahman Ayon. All rights reserved.
//

import Foundation
import Firebase

class StorageService {
    static let shared = StorageService()
    
    private var _REF_BASE = STORAGE
    private var _REF_PROFILEIMAGES = STORAGE.child("Images")
    private var _PROFILE_IMAGE_URL: String?
    
    var REF_BASE: StorageReference {
        return _REF_BASE
    }
    var REF_PROFILEIMAGES: StorageReference {
        return _REF_PROFILEIMAGES
    }
    
    func uploadTask(forImage image: UIImage, andFileName filename: String, handler: @escaping handler) {
        guard let data = UIImageJPEGRepresentation(image, 0.5) else { return }
        let uplodaRef = REF_PROFILEIMAGES.child("\(filename).jpg")
        
        let uploadTask = uplodaRef.putData(data, metadata: nil) { (metadata, error) in
            print("Upload task finished")
            print(metadata ?? "No metadata found")
            print(error ?? "No errors")
            if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                print("The url is \(profileImageUrl)")
                AuthService.shared.addProfileImage(withUrl: profileImageUrl, handler: { (success, error) in
                    if error == nil {
                        print("success haha")
                    }
                })
            }
        }
        uploadTask.observe(.progress) { (uploadSnapShot) in
            print(uploadSnapShot.progress ?? "No more progress")
        }
        uploadTask.resume()
        handler(true, nil)
    }
    
    func downloadTask(forCurrentUserId uid: String, handler: @escaping (_ image: UIImage) -> ()) {
        let imageCache = NSCache<NSString, UIImage>()
        DataService.shared.REF_USER.observeSingleEvent(of: .value, with: { (userSnapShot) in
            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapShot {
                if user.key == uid && user.hasChild("profileUrl"){
                    let imageurl = user.childSnapshot(forPath: "profileUrl").value as! String
                    guard let url = URL(string: imageurl) else { return }
                    
                    if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                        handler(cachedImage)
                        return
                    } else {
                        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                            if error == nil {
                                DispatchQueue.main.async {
                                    if let data = data {
                                        let profileImage = UIImage(data: data)
                                        imageCache.setObject(profileImage!, forKey: url.absoluteString as NSString)
                                        handler(profileImage!)
                                    }
                                }
                            }
                        }).resume()
                    }
                }
            }
        })
    }
}






