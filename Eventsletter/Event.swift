//
//  Event.swift
//  Eventsletter
//
//  Created by Yi Li on 4/20/20.
//  Copyright © 2020 Yi Li. All rights reserved.
//

import Foundation
import CoreLocation

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
}
