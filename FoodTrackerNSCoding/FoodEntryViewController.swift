//
//  FoodEntryViewController.swift
//  FoodTrackerNSCoding
//
//  Created by Nick Reichard on 3/20/17.
//  Copyright © 2017 Nick Reichard. All rights reserved.
//

import UIKit
import os.log

class FoodEntryViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var mealTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControll: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
    
    // MARK: - Properties
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field’s user input through delegate callbacks
        mealTextField.delegate = self
        
        // Set up views if editing an existing meal
        
        if let meal = meal {
            navigationItem.title = meal.name
            mealTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControll.rating = meal.rating
        }
        updateSaveButtonState()
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        navigationItem.title = textField.text
        updateSaveButtonState()
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
    // MARK: - Private Methods
    private func updateSaveButtonState() {
        // Disable the save button if the text field is empty
        // This is a helper method to disable the Save Button if the text field is empty.
        let text = mealTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
        
    }
    
    // MARK: - Cancel 
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
            else if let owingNavigationController = navigationController {
                owingNavigationController.popViewController(animated: true)
            } else {
                fatalError("The MealViewController is not inside the nav controller")
            }
        }
    }



extension FoodEntryViewController: UINavigationControllerDelegate {
    
    //MARK: Navigation
    
    // This method lets you configure a view controller before it's presendted
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressd
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = mealTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControll.rating
        
        // Set the mail to be passed to MealTableiewControll after the unwind segue.
        meal = Meal(name: name, photo: photo, rating: rating)

    }
}
