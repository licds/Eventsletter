//
//  EventDetailViewController.swift
//  Eventsletter
//
//  Created by Yi Li on 4/18/20.
//  Copyright © 2020 Yi Li. All rights reserved.
//

import UIKit
import MapKit

class EventDetailViewController: UIViewController {
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var likeButton: UIButton!
    
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if event == nil {
            event = Event()
        }
        nameTextView.text = event.name
        dateTextField.text = event.date
        timeTextField.text = event.time
        addressTextField.text = event.address
        descriptionTextView.text = event.description
        
    }
    
    
    @IBAction func lookupLocationButtonPressed(_ sender: UIButton) {
    }
    @IBAction func likeButtonPressed(_ sender: UIButton) {
    }
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
    }
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
}
