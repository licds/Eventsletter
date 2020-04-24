//
//  ClubMeetings.swift
//  Eventsletter
//
//  Created by Yi Li on 4/23/20.
//  Copyright © 2020 Yi Li. All rights reserved.
//

import Foundation
import Firebase

class ClubMeetings {
    var clubMeetingsArray = [ClubMeeting]()
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("clubMeetings").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.clubMeetingsArray = []
            // there are querySnapShot.documents.count documents in the clubMeetingss snapshot
            for document in querySnapshot!.documents {
                let clubMeeting = ClubMeeting(dictionary: document.data())
                clubMeeting.documentID = document.documentID
                self.clubMeetingsArray.append(clubMeeting)
            }
            completed()
        }
    }
}
