//
//  EventTableViewCell.swift
//  Eventsletter
//
//  Created by Yi Li on 4/20/20.
//  Copyright © 2020 Yi Li. All rights reserved.
//

import UIKit
import CoreLocation
class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var event: Event!
    
    func configureCell(event: Event!){
        nameLabel.text = event.name
        if event.addressName == "" {
            addressLabel.text = event.address
        } else {
            addressLabel.text = event.addressName
        }
        timeLabel.text = "\(event.date)   \(event.time)"
    }
    
}
