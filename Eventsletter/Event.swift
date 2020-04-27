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
    var eventAddress: String
    var address: String
    var addressName: String
    var coordinate: CLLocationCoordinate2D
    var date: Date
    var startTime: Date
    var eventDescription: String
    var eventType: String
//    var reminderSet: Bool
    var numberOfLikes: Int
    var postingUserID: String
    var documentID: String
    var map: Bool
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
        return eventAddress
    }
    
    var dictionary: [String: Any] {
        let dateIntervalDate = date.timeIntervalSince1970
        let startTimeIntervalDate = startTime.timeIntervalSince1970
        return ["name": name, "addressName": addressName, "address": address, "eventAddress": eventAddress, "longitude": longitude, "latitude": latitude, "date": dateIntervalDate, "startTime": startTimeIntervalDate, "eventDescription": eventDescription, "eventType": eventType, "numberOfLikes": numberOfLikes, "postingUserID": postingUserID, "map": map]
    }
    
    init(name: String, eventAddress: String, address: String, addressName: String, coordinate: CLLocationCoordinate2D, date: Date, startTime: Date, eventDescription: String, eventType: String, numberOfLikes: Int, postingUserID: String, documentID: String, map: Bool) {
        self.name = name
        self.eventAddress = eventAddress
        self.address = address
        self.addressName = addressName
        self.coordinate = coordinate
        self.date = date
        self.startTime = startTime
        self.eventDescription = eventDescription
        self.eventType = eventType
//        self.reminderSet = reminderSet
        self.numberOfLikes = numberOfLikes
        self.postingUserID = postingUserID
        self.documentID = documentID
        self.map = map
    }
    
    convenience override init() {
        self.init(name: "", eventAddress: "", address: "", addressName: "", coordinate: CLLocationCoordinate2D(), date: Date(), startTime: Date(), eventDescription: "", eventType: "", numberOfLikes: 0, postingUserID: "", documentID: "", map: false)
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let addressName = dictionary["addressName"] as! String? ?? ""
        let address = dictionary["address"] as! String? ?? ""
        let eventAddress = dictionary["eventAddress"] as! String? ?? ""
        let longitude = dictionary["longitude"] as! CLLocationDegrees? ?? 0.0
        let latitude = dictionary["latitude"] as! CLLocationDegrees? ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let dateIntervalDate = dictionary["date"] as! TimeInterval? ?? TimeInterval()
        let date = Date(timeIntervalSince1970: dateIntervalDate)
        let startTimeIntervalDate = dictionary["startTime"] as! TimeInterval? ?? TimeInterval()
        let startTime = Date(timeIntervalSince1970: startTimeIntervalDate)
        let eventDescription = dictionary["eventDescription"] as! String? ?? ""
        let eventType = dictionary["eventType"] as! String? ?? ""
        let numberOfLikes = dictionary["numberOfLikes"] as! Int? ?? 0
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        let map = dictionary["map"] as! Bool? ?? false
        self.init(name: name, eventAddress: eventAddress, address: address, addressName: addressName, coordinate: coordinate, date: date, startTime: startTime, eventDescription: eventDescription, eventType: eventType, numberOfLikes: numberOfLikes, postingUserID: postingUserID, documentID: "", map: map)
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
    
    func deleteData(event: Event, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("events").document(event.documentID).delete() { error in
            if let error = error {
                print("😡 ERROR: deleting event documentID \(self.documentID) \(error.localizedDescription)")
                completed(false)
            }
        }
    }
}
