//
//  EventDetailViewController.swift
//  Eventsletter
//
//  Created by Yi Li on 4/18/20.
//  Copyright © 2020 Yi Li. All rights reserved.
//
//IMPORTANT: Saving and passing of nameTextView data needs to be handled better

import UIKit
import MapKit
import GooglePlaces
import Contacts

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    return dateFormatter
}()

class EventDetailViewController: UIViewController {
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var descriptionTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewInScrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var flagTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var showMapButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var lookupButton: UIButton!
    @IBOutlet weak var descriptionTextViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var getDirectionButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    
    var event: Event!
    let regionDistance: CLLocationDistance = 750 // 750 meters
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    var mapIsAvailable: Bool!
    
    var activeView: UITextView?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide keyboard if we tap outside of a field
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
//        mapView.delegate = self
        
        descriptionTextView.delegate = self
        nameTextView.delegate = self
        
        
        // Observe keyboard change
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Add touch gesture for contentView
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnTextView(gesture:))))
        
        if event == nil {
            event = Event()
            getLocation()
            nameTextView.addBorder(width: 0.5, radius: 5.0, color: .lightGray)
            dateTextField.addBorder(width: 0.5, radius: 5.0, color: .lightGray)
            startTimeTextField.addBorder(width: 0.5, radius: 5.0, color: .lightGray)
            addressTextField.addBorder(width: 0.5, radius: 5.0, color: .lightGray)
            descriptionTextView.addBorder(width: 0.5, radius: 5.0, color: .lightGray)
            saveButton.isEnabled = false
            showMapButton.setTitle("Enable Map", for: .normal)
            getDirectionButton.isHidden = true
        } else {
            nameTextView.isEditable = false
            nameTextView.backgroundColor = UIColor.clear
            nameTextView.noBorder()
            dateTextField.isEnabled = false
            dateTextField.backgroundColor = UIColor.white
            dateTextField.noBorder()
            startTimeTextField.isEnabled = false
            startTimeTextField.backgroundColor = UIColor.white
            startTimeTextField.noBorder()
            addressTextField.isEnabled = false
            addressTextField.backgroundColor = UIColor.white
            addressTextField.noBorder()
            descriptionTextView.isEditable = false
            descriptionTextView.backgroundColor = UIColor.white
            descriptionTextView.noBorder()
            saveButton.title = ""
            cancelButton.title = ""
            saveButton.isEnabled = false
            lookupButton.isHidden = true
            if event.map == false {
                showMapButton.isHidden = true
                flagTopConstraint.constant -= 30
                descriptionTextViewTopConstraint.constant -= 30
            }
        }

        getDirectionButton.isHidden = true
        let region = MKCoordinateRegion(center: event.coordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        mapView.setRegion(region, animated: true)
        updateUserInterface()
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTextFont(textView: nameTextView)
        descriptionTextViewHeightConstraint.constant = self.descriptionTextView.contentSize.height
        viewInScrollViewHeightConstraint.constant = eventImageView.frame.size.height + descriptionTextViewHeightConstraint.constant + 368 + 150
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        dateTextField.text = formatter.string(from: sender.date)
        event.date = sender.date
    }
    
    @objc func startTimePickerValueChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        startTimeTextField.text = formatter.string(from: sender.date)
        event.startTime = sender.date
    }
    
    @objc func returnTextView(gesture: UIGestureRecognizer) {
        guard activeView != nil else {
            return
        }
        
        activeView?.resignFirstResponder()
        activeView = nil
    }
    
    func updateDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.addTarget(self, action: #selector(EventDetailViewController.datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        dateTextField.inputView = datePicker
    }
    
    func updateStartTimePicker() {
        let startTimePicker = UIDatePicker()
        startTimePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        startTimePicker.addTarget(self, action: #selector(EventDetailViewController.startTimePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        startTimeTextField.inputView = startTimePicker
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func CGPointMake(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    
    func CGSizeMake(_ width: CGFloat, _ height: CGFloat) -> CGSize {
        return CGSize(width: width, height: height)
    }
    
    func updateTextFont(textView: UITextView) {
        let size = CGSize.zero
        if (textView.text.isEmpty || textView.bounds.size.equalTo(size)) {
            return;
        }

        let textViewSize = textView.frame.size;
        let fixedWidth = textViewSize.width;
        let expectSize = textView.sizeThatFits(CGSizeMake(fixedWidth, CGFloat(MAXFLOAT)));

        var expectFont = textView.font;
        if (expectSize.height > textViewSize.height) {
            while (textView.sizeThatFits(CGSizeMake(fixedWidth, CGFloat(MAXFLOAT))).height > textViewSize.height) {
                expectFont = textView.font!.withSize(textView.font!.pointSize - 1)
                textView.font = expectFont
            }
        }
        else {
            while (textView.sizeThatFits(CGSizeMake(fixedWidth, CGFloat(MAXFLOAT))).height < textViewSize.height) {
                expectFont = textView.font;
                textView.font = textView.font!.withSize(textView.font!.pointSize + 1)
            }
            textView.font = expectFont;
        }
    }
    
    
    func updateUserInterface() {
        nameTextView.text = event.name
        updateDatePicker()
        updateStartTimePicker()
//        updateEndTimePicker()
        dateTextField.text = dateFormatter.string(from: event.date)
        startTimeTextField.text = dateFormatter.string(from: event.startTime)
//        endTimeTextField.text = timeFormatter.string(from: event.endTime)
        addressTextField.text = event.eventAddress
        descriptionTextView.text = event.eventDescription
        updateMap()
    }
    
    func updateMap() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(event)
        mapView.setCenter(event.coordinate, animated: true)
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func addressTextFieldEditingChanged(_ sender: UITextField) {
        saveButton.isEnabled = !(addressTextField.text == "")
        event.eventAddress = addressTextField.text!
    }
    
    @IBAction func addressTextFieldReturnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
        event.name = nameTextView.text!
        addressTextField.text = event.eventAddress
        updateUserInterface()
    }
    
    
    @IBAction func lookupLocationButtonPressed(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func showMap(_ sender: UIButton) {
        if showMapButton.currentTitle == "Show Map" {
            mapViewHeightConstraint.constant = 170
            flagTopConstraint.constant += 170
            showMapButton.setTitle("Hide Map", for: .normal)
            getDirectionButton.isHidden = false
        } else if showMapButton.currentTitle == "Hide Map" {
            mapViewHeightConstraint.constant = 0
            flagTopConstraint.constant -= 170
            showMapButton.setTitle("Show Map", for: .normal)
            getDirectionButton.isHidden = true
        } else if showMapButton.currentTitle == "Enable Map" {
            mapViewHeightConstraint.constant = 170
            flagTopConstraint.constant += 170
            showMapButton.setTitle("Disable Map", for: .normal)
            event.map = true
        } else if showMapButton.currentTitle == "Disable Map" {
            mapViewHeightConstraint.constant = 0
            flagTopConstraint.constant -= 170
            showMapButton.setTitle("Enable Map", for: .normal)
            event.map = false
        }
    }
    @IBAction func getDirectionButtonPressed(_ sender: UIButton) {
        let coordinate = event.coordinate
        let regionDistance: CLLocationDistance = 1000
        let regionSpan = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = event.addressName
        mapItem.openInMaps(launchOptions: options)
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
    }
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
    }
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        event.name = nameTextView.text!
        event.eventDescription = descriptionTextView.text!
        event.eventAddress = addressTextField.text!
        event.saveData { success in
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
    
}
extension EventDetailViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        event.addressName = place.name!
        event.eventAddress = place.formattedAddress ?? "Unknown Address"
        event.coordinate = place.coordinate
        dismiss(animated: true, completion: nil)
        updateUserInterface()
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }

    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension EventDetailViewController: CLLocationManagerDelegate {
    func getLocation() {
        // Creating a CLLocationManager will automatically check authorization
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleAuthenticalStatus(status: status)
    }
    func handleAuthenticalStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            showAlert(title: "Location services denied", message: "It may be that parental controls are restricting location use in the app.")
        case .denied:
            showAlertToPrivacySettings(title: "User has not authorized location services", message: "Select 'Settings' below to enable device settings and enable location services for this app.")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            print("DEVELOPER ALERT: Unknown case of status in handleAuthenticalStatus\(status)")
        }
    }
    
    func showAlertToPrivacySettings(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {
            print("Something went wrong getting the UIApplication.opernSettingsURLString")
            return
        }
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) in
            UIApplication.shared.open(settingURL, options: [:], completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard event.addressName == "" else {
            return
        }
        let geoCoder = CLGeocoder()
        var name = ""
        var address = ""
        currentLocation = locations.last
        event.coordinate = currentLocation.coordinate
        geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: {placemarks, error in
            if placemarks != nil {
                let placemark = placemarks?.last
                name = placemark?.name ?? "name unknown"
                // need to import Contacts to use this code:
                if let postalAddress = placemark?.postalAddress {
                    address = CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress)
                }
            } else {
                print("*** ERROR: retrieving place. Error code: \(error!.localizedDescription)")
            }
            self.event.addressName = name
            self.event.address = address
            self.updateUserInterface()
        })
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR: \(error.localizedDescription). Failed to get device location.")
    }
}

extension EventDetailViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        activeView = textView
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        activeView?.resignFirstResponder()
        activeView = nil
        return true
    }
}


extension EventDetailViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if keyboardHeight != nil {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//IMPORTANT: Room for improvement
            keyboardHeight = keyboardSize.height
            // so increase contentView's height by keyboard height
            UIView.animate(withDuration: 0.3, animations: {
                self.constraintContentHeight.constant += self.keyboardHeight
            })
            // move if keyboard hide input field
            var a = scrollView.frame.size.height
            let b = activeView?.frame.origin.y
            let c = activeView?.frame.size.height
            if b != nil {
                if c != nil {
                    a = a - b! - c!
                } else {
                    a = a - b!
                }
            } else {
                if c != nil {
                    a = a - c!
                }
            }
//          let distanceToBottom = self.scrollView.frame.size.height - (activeView?.frame.origin.y)! - (activeView?.frame.size.height)
            let collapseSpace = keyboardHeight - a
            if collapseSpace < 0 {
            // no collapse
                return
            }
            // set new offset for scroll view
            UIView.animate(withDuration: 0.3, animations: {
                // scroll to the position above keyboard 10 points
                self.scrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 80)
            })
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.constraintContentHeight.constant -= self.keyboardHeight
            if self.lastOffset != nil {
                self.scrollView.contentOffset = self.lastOffset!
            }
        }
            
        keyboardHeight = nil
    }
}

