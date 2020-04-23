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
import MapKit

class Event: NSObject, MKAnnotation {
    var name: String
    var address: String
    var addressName: String
    var coordinate: CLLocationCoordinate2D
    var date: String //Date
    var time: String
    var eventDescription: String
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
    
    var title: String? {
        return addressName
    }
    
    var subtitle: String? {
        return address
    }
    
    var dictionary: [String: Any] {
        return ["name": name, "addressName": addressName, "address": address, "longitude": longitude, "latitude": latitude, "date": date, "time": time, "eventDescription": eventDescription, "numberOfLikes": numberOfLikes, "postingUserID": postingUserID]
    }
    
    init(name: String, address: String, addressName: String, coordinate: CLLocationCoordinate2D, date: String, time: String, eventDescription: String, numberOfLikes: Int, postingUserID: String, documentID: String) {
        self.name = name
        self.address = address
        self.addressName = addressName
        self.coordinate = coordinate
        self.date = date
        self.time = time
        self.eventDescription = eventDescription
//        self.reminderSet = reminderSet
        self.numberOfLikes = numberOfLikes
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience override init() {
        self.init(name: "", address: "", addressName: "", coordinate: CLLocationCoordinate2D(), date: "", time: "", eventDescription: "", numberOfLikes: 0, postingUserID: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let addressName = dictionary["addressName"] as! String? ?? ""
        let address = dictionary["address"] as! String? ?? ""
        let longitude = dictionary["longitude"] as! CLLocationDegrees? ?? 0.0
        let latitude = dictionary["latitude"] as! CLLocationDegrees? ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let date = dictionary["date"] as! String? ?? ""
        let time = dictionary["time"] as! String? ?? ""
        let eventDescription = dictionary["eventDescription"] as! String? ?? ""
        let numberOfLikes = dictionary["numberOfLikes"] as! Int? ?? 0
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(name: name, address: address, addressName: addressName, coordinate: coordinate, date: date, time: time, eventDescription: eventDescription, numberOfLikes: numberOfLikes, postingUserID: postingUserID, documentID: "")
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
