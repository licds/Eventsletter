//
//  MyDetailViewController.swift
//  Eventsletter
//
//  Created by Yi Li on 4/21/20.
//  Copyright © 2020 Yi Li. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseUI
import GoogleSignIn
import SDWebImage

class MyDetailViewController: UIViewController {
//    @IBOutlet weak var myImageView: UIImageView!
//
//    @IBOutlet weak var userNameLabel: UILabel!
    
    var authUI: FUIAuth!
//    let storageRef = Storage.storage().reference()
//    let databaseRef = DatabaseReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        authUI = FUIAuth.defaultAuthUI()
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI.delegate = self
//        setUp()
//        eventsletterUser.loadData {
//
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
//    var eventsletterUser: EventsletterUser! {
//        didSet {
//            myImageView.layer.cornerRadius = myImageView.frame.size.width / 2
//            myImageView.clipsToBounds = true
//
//            userNameLabel.text = eventsletterUser.displayName
//
//            guard let url = URL(string: eventsletterUser.photoURL) else {
//                myImageView.image = UIImage(named: "singleUser")
//                print("😡 ERROR: Could not convert photoURL named \(eventsletterUser.photoURL) into a valid URL")
//                return
//            }
//            myImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "singleUser"))
//        }
//    }
//
//
//    @IBAction func saveChangesButtonPressed(_ sender: UIButton) {
//        saveChanges()
//    }
//    @IBAction func uploadImageButtonPressed(_ sender: UIButton) {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.allowsEditing = true
//        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
//        self.present(picker, animated: true, completion: nil)
//    }
//
//    func setUp() {
//        let uid = authUI.auth?.currentUser?.uid
//        databaseRef.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
//            if let dictionary = snapshot.value as? [String: AnyObject] {
//                self.userNameLabel.text = dictionary["userName"] as? String
//                if let profileImageURL = dictionary["imageURL"] as? String {
//                    let url = URL(string: profileImageURL)
//                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//                        if error != nil {
//                            print(error!)
//                            return
//                        }
//                        DispatchQueue.main.async {
//                            self.myImageView?.image = UIImage(data: data!)
//                        }
//                    }) .resume()
//                }
//            }
//        })
//    }
//
//    func saveChanges() {
//        let imageName = NSUUID().uuidString
//        let storedImage = storageRef.child("profileImages").child(imageName)
//        if let uploadData = self.myImageView.image!.pngData() {
//            storedImage.putData(uploadData, metadata: nil, completion: { (metadata, error) in
//                if error != nil {
//                    print(error!)
//                    return
//                }
//                storedImage.downloadURL(completion: { (url, error) in
//                    if error != nil {
//                        print(error!)
//                        return
//                    }
//                    if let urlText = url?.absoluteString{
//                        self.databaseRef.child("users").child((Auth.auth().currentUser?.uid)!).updateChildValues(["imageURL": urlText], withCompletionBlock: { (error, ref) in
//                            if error != nil {
//                                print(error!)
//                                return
//                            }
//                        })
//                    }
//                })
//            })
//        }
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        var selectedImage: UIImage?
//        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
//            selectedImage = editedImage
//        } else if let originalImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
//            selectedImage = originalImage
//        }
//        if let image = selectedImage {
//            myImageView.image = image
//        }
//        dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
    
    func signin() {
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
        ]
        if authUI.auth?.currentUser == nil {
            self.authUI.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        }
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        do {
            try authUI!.signOut()
            print("^^^ Successfully sign out!")
        } catch {
            print("*** ERROR: Couldn't sign out.")
        }
        
    }
    
}
extension MyDetailViewController: FUIAuthDelegate {
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
            print("*** We signed in with the \(user.email)")
        }
    }
}
