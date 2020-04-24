//
//  EventTableViewCell.swift
//  Eventsletter
//
//  Created by Yi Li on 4/20/20.
//  Copyright © 2020 Yi Li. All rights reserved.
//

import UIKit
import CoreLocation

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

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var event: Event!
    
    func configureCell(event: Event!){
        let date = fullDateFormatter.string(from: event.date)
        let startDate = dateFormatter.string(from: event.date)
        let endDate = dateFormatter.string(from: event.startTime)
        let startTime = timeFormatter.string(from: event.startTime)
        let startTimeWithDate = fullDateFormatter.string(from: event.startTime)
        if event.name == "" {
            nameLabel.text = "Unknown Event"
        } else {
            nameLabel.text = event.name
        }
        if event.eventAddress == "" {
            addressLabel.text = "TBD"
        } else {
            addressLabel.text = event.eventAddress
        }
        if startDate == endDate {
            timeLabel.text = "\(date) - \(startTime)"
        } else {
            timeLabel.text = "\(date) - \(startTimeWithDate)"
        }
    }
    
}
