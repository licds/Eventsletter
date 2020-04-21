//
//  EventsListViewController.swift
//  Eventsletter
//
//  Created by Yi Li on 4/20/20.
//  Copyright © 2020 Yi Li. All rights reserved.
//

import UIKit
import CoreLocation

class EventsListViewController: UIViewController {
    var events: Events! //5
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        listTableView.delegate = self
        listTableView.dataSource = self
        events = Events() //5
        events.eventsArray.append(Event(name: "Example1", address: "Address1", coordinate: CLLocationCoordinate2D(), date: "Date1", time: "Time1", description: "Description1", numberOfLikes: 0, postingUserID: "", documentID: ""))
        events.eventsArray.append(Event(name: "Example2", address: "Address2", coordinate: CLLocationCoordinate2D(), date: "Date2", time: "Time2", description: "Description2", numberOfLikes: 0, postingUserID: "", documentID: ""))
        events.eventsArray.append(Event(name: "Example3", address: "Address3", coordinate: CLLocationCoordinate2D(), date: "Date3", time: "Time3", description: "Description3", numberOfLikes: 0, postingUserID: "", documentID: ""))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEvent" {
            let destination = segue.destination as! EventDetailViewController
            let selectedIndexPath = listTableView.indexPathForSelectedRow!
            destination.event = events.eventsArray[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = listTableView.indexPathForSelectedRow {
                listTableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
}

extension EventsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.eventsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventTableViewCell
        cell.nameLabel.text = events.eventsArray[indexPath.row].name
//        cell.dateLabel.text = "\(events.eventsArray[indexPath.row].date)"
//        cell.addressLabel.text = events.eventsArray[indexPath.row].address
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
