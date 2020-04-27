//
//  ClubDetailViewController.swift
//  Eventsletter
//
//  Created by Yi Li on 4/23/20.
//  Copyright © 2020 Yi Li. All rights reserved.
//

import UIKit
import Contacts
import Firebase

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
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIButton!
    
    var clubMeeting: ClubMeeting!
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide keyboard if we tap outside of a field
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        if clubMeeting == nil {
            clubMeeting = ClubMeeting()
            clubMeetingTextView.addBorder(width: 0.5, radius: 5.0, color: .lightGray)
            meetingDateTextField.addBorder(width: 0.5, radius: 5.0, color: .lightGray)
            meetingStartTimeTextField.addBorder(width: 0.5, radius: 5.0, color: .lightGray)
            meetingAddressTextField.addBorder(width: 0.5, radius: 5.0, color: .lightGray)
            saveButton.isEnabled = false
        } else {
            clubMeetingTextView.isEditable = false
            clubMeetingTextView.backgroundColor = UIColor.clear
            clubMeetingTextView.noBorder()
            meetingDateTextField.isEnabled = false
            meetingDateTextField.backgroundColor = UIColor.white
            meetingDateTextField.noBorder()
            meetingStartTimeTextField.isEnabled = false
            meetingStartTimeTextField.backgroundColor = UIColor.white
            meetingStartTimeTextField.noBorder()
            meetingAddressTextField.isEnabled = false
            meetingAddressTextField.backgroundColor = UIColor.white
            meetingAddressTextField.noBorder()
            saveButton.title = ""
            cancelButton.title = ""
            saveButton.isEnabled = false
            if clubMeeting.postingUserID != Auth.auth().currentUser?.uid {
                deleteButton.isHidden = true
            }
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
    
    
    @IBAction func meetingAddressEditingChanged(_ sender: UITextField) {
        saveButton.isEnabled = !(meetingAddressTextField.text == "")
    }
    
    @IBAction func meetingAddressReturnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
        clubMeeting.clubName = clubMeetingTextView.text!
        clubMeeting.meetingAddress = meetingAddressTextField.text!
        updateUserInterface()
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
        clubMeeting.deleteData(clubMeeting: clubMeeting) { success in
            if success {
                self.leaveViewController()
            } else {
            print("😡 Delete unsuccessful.")
            }
        }
    }
}

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
