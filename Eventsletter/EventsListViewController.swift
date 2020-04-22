//
//  EventsListViewController.swift
//  Eventsletter
//
//  Created by Yi Li on 4/20/20.
//  Copyright © 2020 Yi Li. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseUI
import GoogleSignIn

class EventsListViewController: UIViewController {
    var events: Events!
    var authUI: FUIAuth!
    
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        authUI = FUIAuth.defaultAuthUI()
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI.delegate = self
        
        listTableView.delegate = self
        listTableView.dataSource = self
        events = Events()
        events.eventsArray.append(Event(name: "Example1", address: "Address1", coordinate: CLLocationCoordinate2D(), date: "Date1", time: "Time1", description: "Description1", numberOfLikes: 0, postingUserID: "", documentID: ""))
        events.eventsArray.append(Event(name: "Example2", address: "Address2", coordinate: CLLocationCoordinate2D(), date: "Date2", time: "Time2", description: "Description2", numberOfLikes: 0, postingUserID: "", documentID: ""))
        events.eventsArray.append(Event(name: "Example3", address: "Address3", coordinate: CLLocationCoordinate2D(), date: "Date3", time: "Time3", description: "Description3", numberOfLikes: 0, postingUserID: "", documentID: ""))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signin()
    }
    
    func signin() {
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
        ]
        if authUI.auth?.currentUser == nil {
            self.authUI.providers = providers
            let authviewController = authUI.authViewController()
            authviewController.modalPresentationStyle = .fullScreen
            self.present(authviewController, animated: true, completion: nil)
        }
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

extension EventsListViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
      if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
        return true
      }
      // other URL handling goes here.
      return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            print("*** We signed in with the user \(user.email ?? "unknown e-mail")")
        }
    }
}
