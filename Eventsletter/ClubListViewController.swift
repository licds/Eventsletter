//
//  ClubListViewController.swift
//  Eventsletter
//
//  Created by Yi Li on 4/23/20.
//  Copyright © 2020 Yi Li. All rights reserved.
//

import UIKit

class ClubListViewController: UIViewController {
    var clubMeetings: ClubMeetings!
    
    @IBOutlet weak var clubMeetingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        clubMeetingsTableView.delegate = self
        clubMeetingsTableView.dataSource = self
            
        clubMeetings = ClubMeetings()
        sortByDate()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        clubMeetings.loadData {
            self.clubMeetingsTableView.reloadData()
        }
    }
    
    func sortByDate() {
        clubMeetings.clubMeetingsArray.sort(by: {$0.meetingDate < $1.meetingDate})
    }
    
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowClubMeeting" {
            let destination = segue.destination as! ClubDetailViewController
            let selectedIndexPath = clubMeetingsTableView.indexPathForSelectedRow!
            destination.clubMeeting = clubMeetings.clubMeetingsArray[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = clubMeetingsTableView.indexPathForSelectedRow {
                clubMeetingsTableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
}

extension ClubListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubMeetings.clubMeetingsArray.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ClubTableViewCell
        cell.configureCell(clubMeeting: clubMeetings.clubMeetingsArray[indexPath.row])
        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
        
}


