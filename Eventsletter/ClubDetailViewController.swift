//
//  ClubDetailViewController.swift
//  Eventsletter
//
//  Created by Yi Li on 4/23/20.
//  Copyright © 2020 Yi Li. All rights reserved.
//

import UIKit
import Contacts

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    return dateFormatter
}()

class ClubDetailViewController: UIViewController {
    @IBOutlet weak var clubMeetingTextView: UITextView!
    @IBOutlet weak var meetingDateTextField: UITextField!
    @IBOutlet weak var meetingStartTimeTextField: UITextField!
    @IBOutlet weak var meetingAddressTextField: UITextField!
    
    var clubMeeting: ClubMeeting!
    override func viewDidLoad() {
        super.viewDidLoad()
            
        if clubMeeting == nil {
            clubMeeting = ClubMeeting()
        }
        updateUserInterface()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        meetingDateTextField.text = formatter.string(from: sender.date)
        clubMeeting.meetingDate = sender.date
    }
    
    @objc func startTimePickerValueChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        meetingStartTimeTextField.text = formatter.string(from: sender.date)
        clubMeeting.meetingStartTime = sender.date
    }
    
    func updateDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.addTarget(self, action: #selector(ClubDetailViewController.datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        meetingDateTextField.inputView = datePicker
    }
    
    func updateStartTimePicker() {
        let startTimePicker = UIDatePicker()
        startTimePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        startTimePicker.addTarget(self, action: #selector(ClubDetailViewController.startTimePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        meetingStartTimeTextField.inputView = startTimePicker
    }
    
    func updateUserInterface() {
        clubMeetingTextView.text = clubMeeting.clubName
        updateDatePicker()
        updateStartTimePicker()
        meetingDateTextField.text = dateFormatter.string(from: clubMeeting.meetingDate)
        meetingStartTimeTextField.text = dateFormatter.string(from: clubMeeting.meetingStartTime)
        meetingAddressTextField.text = clubMeeting.meetingAddress
    }
    
    func leaveViewController() {
            let isPresentingInAddMode = presentingViewController is UINavigationController
            if isPresentingInAddMode {
                dismiss(animated: true, completion: nil)
            } else {
                navigationController?.popViewController(animated: true)
            }
        }
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        clubMeeting.clubName = clubMeetingTextView.text!
        clubMeeting.meetingAddress = meetingAddressTextField.text!
        clubMeeting.saveData { success in
            if success {
                self.leaveViewController()
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
            }
        }
    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
    }
}

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
