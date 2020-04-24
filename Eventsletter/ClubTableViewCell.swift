//
//  ClubTableViewCell.swift
//  Eventsletter
//
//  Created by Yi Li on 4/23/20.
//  Copyright © 2020 Yi Li. All rights reserved.
//

import UIKit

private let fullDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    return dateFormatter
}()

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .none
    return dateFormatter
}()

private let timeFormatter: DateFormatter = {
    let timeFormatter = DateFormatter()
    timeFormatter.dateStyle = .none
    timeFormatter.timeStyle = .short
    return timeFormatter
}()

class ClubTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var clubMeeting: ClubMeeting!
    
    func configureCell(clubMeeting: ClubMeeting!){
        let date = fullDateFormatter.string(from: clubMeeting.meetingDate)
        let startTime = timeFormatter.string(from: clubMeeting.meetingStartTime)
        if clubMeeting.clubName == "" {
            nameLabel.text = "Unknown Club Meeting"
        } else {
            nameLabel.text = clubMeeting.clubName
        }
        if clubMeeting.meetingAddress == "" {
            addressLabel.text = "TBD"
        } else {
            addressLabel.text = clubMeeting.meetingAddress
        }
        timeLabel.text = "\(date) - \(startTime)"
    }
    
}
