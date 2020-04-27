import Foundation
import Firebase

class EventsletterUser {
    var email: String
    var displayName: String
    var photoURL: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["email": email, "displayName": displayName, "photoURL": photoURL, "documentID": documentID ]
    }
    
    init(email: String, displayName: String, photoURL: String, documentID: String) {
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
        self.documentID = documentID
    }
    
    convenience init(user: User) {
        self.init(email: user.email ?? "", displayName: user.displayName ?? "", photoURL: (user.photoURL != nil ? "\(user.photoURL!)" : ""), documentID: user.uid)
    }
    
    convenience init(dictionary: [String: Any]) {
        let email = dictionary["email"] as! String? ?? ""
        let displayName = dictionary["displayName"] as! String? ?? ""
        let photoURL = dictionary["photoURL"] as! String? ?? ""
        self.init(email: email, displayName: displayName, photoURL: photoURL, documentID: "")
    }
    
    func saveIfNewUser() {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(documentID)
        userRef.getDocument { (document, error) in
            guard error == nil else {
                print("😡 ERROR: could not access document for user \(userRef.documentID)")
                return
            }
            guard document?.exists == false else {
                print("^^^ The document for user \(self.documentID) already exists. No reason to create it")
                return
            }
            self.saveData()
        }
    }
    
    func loadData(completed: @escaping () -> ()) {
        var db = Firestore.firestore()
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            // there are querySnapShot.documents.count documents in the events snapshot
            for document in querySnapshot!.documents {
                let eventsletterUser = EventsletterUser(dictionary: document.data())
                eventsletterUser.documentID = document.documentID
            }
            completed()
        }
    }
    
    func saveData() {
        let db = Firestore.firestore()
        let dataToSave: [String: Any] = self.dictionary
        db.collection("users").document(documentID).setData(dataToSave) { error in
            if let error = error {
                print("😡 ERROR: \(error.localizedDescription), could not save data for \(self.documentID)")
            }
        }
    }
}
