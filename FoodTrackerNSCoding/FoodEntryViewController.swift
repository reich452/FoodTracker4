//
//  FoodEntryViewController.swift
//  FoodTrackerNSCoding
//
//  Created by Nick Reichard on 3/20/17.
//  Copyright © 2017 Nick Reichard. All rights reserved.
//

import UIKit

class FoodEntryViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var MealNameLabel: UILabel!
    @IBOutlet weak var mealTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControll: RatingControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field’s user input through delegate callbacks
        mealTextField.delegate = self
        
    }
    
    //MARK: UITextFieldDelegate
    
    @IBOutlet weak var setDefaultLabelText: UIButton!

    
    // MARK: - Protocosl
    
    // Gets called when the user taps Return or done
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        MealNameLabel.text = textField.text
    }
    
    @IBAction func selectImageFromPhotos(_ sender: UITapGestureRecognizer) {
        mealTextField.resignFirstResponder()
        // UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provied the folowing: \(info)")
        }
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismissed the picer. 
        dismiss(animated: true, completion: nil)
    }
    
    
    
}


extension FoodEntryViewController: UINavigationControllerDelegate {
    
}
