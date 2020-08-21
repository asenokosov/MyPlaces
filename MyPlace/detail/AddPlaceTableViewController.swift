//
//  AddPlaceTableViewController.swift
//  MyPlace
//
//  Created by User on 17/08/2020.
//  Copyright © 2020 HomeMade. All rights reserved.
//

import UIKit

class AddPlaceTableViewController: UITableViewController {

    @IBOutlet weak var imagePlace: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }

//Mark: Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let photoIcon = #imageLiteral(resourceName: "photo")
            let cameraIcon = #imageLiteral(resourceName: "camera")
            
            let choosAction = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let actionPhoto = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImage(source: .photoLibrary)
            }
            actionPhoto.setValue(photoIcon, forKey: "image")
            actionPhoto.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let actionCamera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImage(source: .camera)
            }
            actionCamera.setValue(cameraIcon, forKey: "image")
            actionCamera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            choosAction.addAction(actionPhoto)
            choosAction.addAction(actionCamera)
            choosAction.addAction(cancelAction)
            present(choosAction, animated: true)
        } else {
            tableView.endEditing(true)
        }
    }
}

// MARK: text Field delegate

extension AddPlaceTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
//MARK: Work with image

extension AddPlaceTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImage(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePlace.image = info[.editedImage] as? UIImage
        imagePlace.contentMode = .scaleToFill
        imagePlace.clipsToBounds = true
        dismiss(animated: true)
    }
}

