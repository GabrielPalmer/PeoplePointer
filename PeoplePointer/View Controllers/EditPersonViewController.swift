//
//  EditPersonViewController.swift
//  PeoplePointer
//
//  Created by Gabriel Blaine Palmer on 10/12/18.
//  Copyright © 2018 Gabriel Blaine Palmer. All rights reserved.
//

import UIKit

class EditPersonViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var person: Person?
    var imageSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        scrollView.delegate = self
        
        updateZoomFor(size: CGSize(width: 200, height: 200))
        
        scrollView.layer.borderWidth = 2
        scrollView.layer.borderColor = UIColor.gray.cgColor
        scrollView.layer.cornerRadius = 0
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        let isPresentingInAddMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("EditPersonViewController is not in navigation controller")
        }
        
    }
    
    //========================================
    // MARK: - Scroll View Delegate
    //========================================
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        imageView.layer.opacity = 0.5
        scrollView.clipsToBounds = false
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.clipsToBounds = true
        imageView.layer.opacity = 1
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        imageView.layer.opacity = 0.5
        scrollView.clipsToBounds = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollView.clipsToBounds = true
        imageView.layer.opacity = 1
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func updateZoomFor(size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let scale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = scale
        scrollView.zoomScale = scale
    }
 
    
    //========================================
    // MARK: - UITextFieldDelegate
    //========================================
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveButton.isEnabled = validValuesToSave()
    }
    
    //========================================
    // MARK: - UIImagePickerControllerDelegate
    //========================================
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        //hide keyboard
        nameTextField.resignFirstResponder()
        
        if !imageSelected {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            
            let alertController = UIAlertController(
                title: nil,
                message: nil,
                preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil)
            alertController.addAction(cancelAction)
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let photosAction = UIAlertAction(
                    title: "Photos",
                    style: .default) { _ in
                        imagePickerController.sourceType = .photoLibrary
                        self.present(imagePickerController, animated: true)
                }
                alertController.addAction(photosAction)
            }
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let cameraAction = UIAlertAction(
                    title: "Camera",
                    style: .default) { _ in
                        imagePickerController.sourceType = .camera
                        self.present(imagePickerController, animated: true)
                }
                alertController.addAction(cameraAction)
            }
            
            present(alertController, animated: true)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
        
        saveButton.isEnabled = validValuesToSave()
    }
    
    func imagePickerController(_ _picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {fatalError()}
        scrollView.isScrollEnabled = true
        imageSelected = true
        
        //Set photoImageView to display the selected image.
        imageView.image = selectedImage
        scrollView.layoutIfNeeded()
        updateZoomFor(size: scrollView.bounds.size)
        
        if selectedImage.size.width != selectedImage.size.height {
            //notify user to resize image
        }
        
        //Dismiss the picker.
        dismiss(animated: true, completion: nil)
        
        saveButton.isEnabled = validValuesToSave()
    }
    
    //========================================
    // MARK: - Navigation
    //========================================

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {return}
        
        guard let image = imageView.image else {return}
        let text = nameTextField.text ?? "<invalid name saved>"
        
        person = Person(image: image, name: text)
    }
    
    //Mark: Private Functions
    
    fileprivate func validValuesToSave() -> Bool {
        
        guard imageView.image != UIImage(named: "testDefaultPhoto") else {return false}
        
        guard nameTextField.text?.trimmingCharacters(in: .whitespaces) != "" && nameTextField.text != nil else {return false}
        
        return true
    }

}

