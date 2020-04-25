//
//  ViewController.swift
//  Meme Mania
//
//  Created by Fiza Rasool on 12/06/19.
//  Copyright © 2019 Fiza Rasool. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var pickedImage: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    var activeTextField = UITextField()
    
    
    var memeImage = UIImage()
    
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareButton.isEnabled = false
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        setupTextField(tf: topTextField, text: "TOP")
        setupTextField(tf: bottomTextField, text: "BOTTOM")
        
    }
    
    func setupTextField(tf: UITextField, text: String) {
        tf.defaultTextAttributes = [
            NSAttributedStringKey.foregroundColor.rawValue : UIColor.white,
            NSAttributedStringKey.strokeColor.rawValue : UIColor.black,
            NSAttributedStringKey.font.rawValue : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: -4.0,
        ]
        tf.textColor = UIColor.white
        tf.backgroundColor = UIColor.clear
        tf.tintColor = UIColor.white
        tf.textAlignment = .center
        tf.text = text
        tf.delegate = self
    }
    //        let memeTextAttributes : [String : Any]? = [
    //            NSAttributedStringKey.font.rawValue : UIFont(name: "HelveticaNeue-CondensedBlack", size: 38)!
    //        ]
    //
    //        topTextField.defaultTextAttributes = memeTextAttributes!
    //        topTextField.textAlignment = .center
    //        topTextField.textColor = UIColor.white
    //        topTextField.backgroundColor = UIColor.clear
    //        topTextField.borderStyle = .none
    //        bottomTextField.defaultTextAttributes = memeTextAttributes!
    //        bottomTextField.textAlignment = .center
    //        bottomTextField.textColor = UIColor.white
    //        bottomTextField.backgroundColor = UIColor.clear
    //        bottomTextField.borderStyle = .none
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications() //calling this method to be sign up to notify when the keyboard appears
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()  //calling this method to be sign up to notify when the keyboard disappears
    }
    
    
    // MARK :- UIImagePickerController Delegate method to fetch the image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            pickedImage.image = userPickedImage
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    // Mark :-  Getting the Image from Camera or Photo library
    @IBAction func pickImageFromCamera(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion:  nil)
    }
    
    
    @IBAction func pickImageFromLibrary(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK : - Text Field Delegate methods
    
    //    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    //        activeTextField = textField
    //        return true
    //    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == topTextField && topTextField.text == "TOP"{
            topTextField.text = ""
        }
        
        if textField == bottomTextField && bottomTextField.text == "BOTTOM" {
            bottomTextField.text = ""
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
        
    }
    
    //MARK :- Notifying when the keyboard appears and disappears
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    //MARK :- When the keyboardWillShow notification is received, shift the view's frame up
    @objc func keyboardWillShow(_ notification : Notification) {
        
        if (bottomTextField.isEditing) {
            view.frame.origin.y -= getKeyBoardHeight(notification)
        }
        
    }
    
    func getKeyBoardHeight(_ notification : Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification : Notification) {
        view.frame.origin.y = 0
        shareButton.isEnabled = true
        
    }
    
    //MARK :- Saving the memed image
    
    func generateMemedImage() -> UIImage {
        
        hideToolBars(true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        hideToolBars(false)
        
        return memedImage
        
    }
    
    func hideToolBars(_ hide: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.toolbar.isHidden = true
    }
    
    //MARK :- Sharing the meme
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        
        memeImage = generateMemedImage()
        
        let shareController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
        
        shareController.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed){
                //save meme
                _ = Meme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, originalImage : self.pickedImage.image!, memedImage: self.memeImage)
            }
            //Dismiss the shareActivityViewController
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
}




