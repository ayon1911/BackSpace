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
    private var _image = UIImage()
    
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
        }
        uploadTask.observe(.progress) { (uploadSnapShot) in
            print(uploadSnapShot.progress ?? "No more progress")
        }
        uploadTask.resume()
        handler(true, nil)
    }
    
    func downloadTask(filename: String, handler: @escaping (_ image: UIImage) -> ()) {
        let downloadTaskRef = REF_PROFILEIMAGES.child("\(filename).jpg")
        let downloadTask = downloadTaskRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            
            if error == nil {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    guard let img = UIImage(data: data) else { return }
                    handler(img)
                }
            }
        }
        downloadTask.observe(.progress) { (snapShot) in
            print(snapShot.progress as Any)
        }
        downloadTask.resume()
    }
}

