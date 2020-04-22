//
//  Events.swift
//  Eventsletter
//
//  Created by Yi Li on 4/20/20.
//  Copyright © 2020 Yi Li. All rights reserved.
//

import Foundation
import Firebase

class Events {
    var eventsArray = [Event]()
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("events").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.eventsArray = []
            // there are querySnapShot.documents.count documents in the events snapshot
            for document in querySnapshot!.documents {
                let event = Event(dictionary: document.data())
                event.documentID = document.documentID
                self.eventsArray.append(event)
            }
            completed()
        }
    }
}
