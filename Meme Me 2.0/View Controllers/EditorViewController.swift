//
//  EditorViewController.swift
//  Meme Me 2.0
//
//  Created by Erich Clark on 4/14/18.
//  Copyright © 2018 Erich Clark. All rights reserved.
//

import Foundation
import UIKit

class EditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
UITextFieldDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: Outlets
    
    @IBOutlet weak var sharingToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topMemeTextField: UITextField!
    @IBOutlet weak var bottomMemeTextField: UITextField!
    @IBOutlet weak var imageSourceToolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var galleryButton: UIBarButtonItem!
    
    // MARK: viewDidLoad
    // Sets default captioning text attributes, resets text and image
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultTextAttributes(textfield: self.topMemeTextField)
        setDefaultTextAttributes(textfield: self.bottomMemeTextField)
        
        resetTheWorld()
    }
    
    // MARK: ViewWillAppear
    // Subscribes to keyboad, hides naviagation bar
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: resetTheWorld - resets the app to an initial state
    
    func resetTheWorld() {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false
        topMemeTextField.text = "TOP"
        bottomMemeTextField.text = "BOTTOM"
        imagePickerView.image = UIImage(named: "MemeGeneratorIcon-1024.png")
    }
    
    // MARK: ViewWill Dissapear
    // unsubscribes from keyboard, unhides navigation bar
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: Actions
    // Image Buttons for Album / Camera
    
    @IBAction func requestImageFromAlbums(_ sender: Any) {
        importImage(source: .photoLibrary)
    }
    
    @IBAction func requestImageFromCamera (_ sender: Any) {
        importImage(source: .camera)
    }
    
    // MARK: Saves meme to app delegate when sharing is complete
    
    func saveMeme(_ meme: Meme) {
        // Add it to the memes array in the Application Delegate
        appDelegate.memes.append(meme)
    }
    
    // MARK: Default meme text formatting
    
    let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "impact", size: 55)!,
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.strokeWidth.rawValue: -6.0]
    
    func setDefaultTextAttributes(textfield: UITextField) {
        textfield.delegate = self
        textfield.textColor = UIColor.white
        textfield.defaultTextAttributes = memeTextAttributes
        textfield.textAlignment = .center
    }
    
    // MARK: Keyboard show / hide / subscribe
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomMemeTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if bottomMemeTextField.isFirstResponder {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Hides/shows toolbars during screen capture.
    
    func showToolbars(show: Bool) {
        if show {
            sharingToolbar.isHidden = false
            imageSourceToolbar.isHidden = false
        } else {
            sharingToolbar.isHidden = true
            imageSourceToolbar.isHidden = true
        }
        
    }
    
    // MARK: Sharing Action Button
    
    @IBAction func requestShare(_ sender: AnyObject) {
        if imagePickerView.image == nil {
            print("Image View is empty.")
        } else {
            let meme = generateMeme()
            let memedImage = meme.memedImage!
            
            let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            
            activityVC.completionWithItemsHandler = {
                (UIActivityType, completed, returnedItems, error) in
                if completed {
                    self.saveMeme(meme)
                }
            }
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    // MARK: Cancel button
    
    @IBAction func cancelAndResetTheWorld(_ sender: AnyObject) {
        resetTheWorld()
        returnToGalleries()
    }
    
    // MARK: generateMeme - handles screen capture
    
    func generateMeme() -> Meme {
        
        showToolbars(show: false)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.imagePickerView.frame.size)
        view.drawHierarchy(in: self.imagePickerView.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        showToolbars(show: true)
        
        let meme = Meme(topText: topMemeTextField.text!, bottomText: bottomMemeTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        return meme
    }
    
    func returnToGalleries() {
        self.navigationController?.popViewController(animated: true)
    }

}

