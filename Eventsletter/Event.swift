//
//  Event.swift
//  Eventsletter
//
//  Created by Yi Li on 4/20/20.
//  Copyright © 2020 Yi Li. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

class Event {
    var name: String
    var address: String
    var addressName: String
    var coordinate: CLLocationCoordinate2D
    var date: String //Date
    var time: String
    var description: String
//    var reminderSet: Bool
    var numberOfLikes: Int
    var postingUserID: String
    var documentID: String
//    var eventType: String
    
    var longitude: CLLocationDegrees {
        return coordinate.longitude
    }
    
    var latitude: CLLocationDegrees {
        return coordinate.latitude
    }
    
    var dictionary: [String: Any] {
        return ["name": name, "addressName": addressName, "address": address, "longitude": longitude, "latitude": latitude, "date": date, "time": time, "description": description, "numberOfLikes": numberOfLikes, "postingUserID": postingUserID]
    }
    
    init(name: String, address: String, addressName: String, coordinate: CLLocationCoordinate2D, date: String, time: String, description: String, numberOfLikes: Int, postingUserID: String, documentID: String) {
        self.name = name
        self.address = address
        self.addressName = addressName
        self.coordinate = coordinate
        self.date = date
        self.time = time
        self.description = description
//        self.reminderSet = reminderSet
        self.numberOfLikes = numberOfLikes
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience init() {
        self.init(name: "", address: "", addressName: "", coordinate: CLLocationCoordinate2D(), date: "", time: "", description: "", numberOfLikes: 0, postingUserID: "", documentID: "")
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
            let ref = db.collection("events").document(self.documentID)
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
            ref = db.collection("events").addDocument(data: dataToSave) { error in
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
