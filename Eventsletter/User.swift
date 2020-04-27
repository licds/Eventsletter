//
//  User.swift
//  Eventsletter
//
//  Created by Yi Li on 4/26/20.
//  Copyright © 2020 Yi Li. All rights reserved.
//

import Foundation
import Firebase

class User {
    var userName: String
    var postingUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["userName": userName, "postingUserID": postingUserID]
    }
    
    init(userName: String, postingUserID: String, documentID: String) {
        self.userName = userName
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience init() {
        self.init(userName: "", postingUserID: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let userName = dictionary["userName"] as! String? ?? ""
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(userName: userName, postingUserID: postingUserID, documentID: "")
    }
    
    func saveData(completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        //Grab postingUserID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            print("*** ERROR: Could not save data because we don't have a valid postingUserID")
            return completed(false)
        }
        self.postingUserID = postingUserID
        //Create dictionary, representing the data we want to save
        let dataToSave = self.dictionary
        //If we have save a record, we will have a documentID
        if self.documentID != "" {
            let ref = db.collection("users").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error{
                    print("*** ERROR: updating document \(self.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ Document updated with ref ID \(ref.documentID)")
                    completed(true)
                }
            }
        } else {
            var ref: DocumentReference? = nil //Let Firebase create the documentID
            ref = db.collection("users").addDocument(data: dataToSave) { error in
                if let error = error{
                    print("*** ERROR: creating new document \(self.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ New document created with ref ID \(ref?.documentID ?? "unknown")")
                    completed(true)
                }
            }
        }
    }
}
