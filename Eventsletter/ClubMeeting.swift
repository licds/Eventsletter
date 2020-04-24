//
//  ClubMeeting.swift
//  Eventsletter
//
//  Created by Yi Li on 4/23/20.
//  Copyright © 2020 Yi Li. All rights reserved.
//

import Foundation
import Firebase

class ClubMeeting {
    var clubName: String
    var meetingAddress: String
    var meetingDate: Date
    var meetingStartTime: Date
    var numberOfLikes: Int
    var postingUserID: String
    var documentID: String
    var dictionary: [String: Any] {
        let meetingDateIntervalDate = meetingDate.timeIntervalSince1970
        let meetingStartTimeIntervalDate = meetingStartTime.timeIntervalSince1970
        return ["clubName": clubName, "meetingAddress": meetingAddress, "meetingDate": meetingDateIntervalDate, "meetingStartTime": meetingStartTimeIntervalDate, "numberOfLikes": numberOfLikes, "postingUserID": postingUserID]
    }
    
    init(clubName: String, meetingAddress: String, meetingDate: Date, meetingStartTime: Date, numberOfLikes: Int, postingUserID: String, documentID: String) {
        self.clubName = clubName
        self.meetingAddress = meetingAddress
        self.meetingDate = meetingDate
        self.meetingStartTime = meetingStartTime
        self.numberOfLikes = numberOfLikes
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience init() {
        self.init(clubName: "", meetingAddress: "", meetingDate: Date(), meetingStartTime: Date(), numberOfLikes: 0, postingUserID: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let clubName = dictionary["clubName"] as! String? ?? ""
        let meetingAddress = dictionary["meetingAddress"] as! String? ?? ""
        let dateIntervalDate = dictionary["meetingDate"] as! TimeInterval? ?? TimeInterval()
        let meetingDate = Date(timeIntervalSince1970: dateIntervalDate)
        let startTimeIntervalDate = dictionary["meetingStartTime"] as! TimeInterval? ?? TimeInterval()
        let meetingStartTime = Date(timeIntervalSince1970: startTimeIntervalDate)
        let numberOfLikes = dictionary["numberOfLikes"] as! Int? ?? 0
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(clubName: clubName, meetingAddress: meetingAddress, meetingDate: meetingDate, meetingStartTime: meetingStartTime, numberOfLikes: numberOfLikes, postingUserID: postingUserID, documentID: "")
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
            let ref = db.collection("clubMeetings").document(self.documentID)
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
            ref = db.collection("clubMeetings").addDocument(data: dataToSave) { error in
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
