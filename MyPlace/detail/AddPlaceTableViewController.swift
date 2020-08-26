//
//  AddPlaceTableViewController.swift
//  MyPlace
//
//  Created by User on 17/08/2020.
//  Copyright © 2020 HomeMade. All rights reserved.
//

import UIKit

class AddPlaceTableViewController: UITableViewController {
    
    var currentPlace: Place?
    var imageIsChanges = false
    
    @IBOutlet weak var imagePlace: UIImageView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var localField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.tableFooterView = UIView()
        saveButton.isEnabled = false
        
        nameField.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        localField.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        typeField.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        editCell()
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
    
    func savePlace() {
        
        var image: UIImage?
        
        if imageIsChanges {
            image = imagePlace.image
        } else {
            image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        let imageData = image?.pngData()
        
        let newPlace = Place(name: nameField.text!, location: localField.text, type: typeField.text, imageData: imageData)
        
        if currentPlace != nil {
            try! realm.write(){
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
            }
        } else {
            SaveManager.saveObject(newPlace)
        }
    }
    
    private func editCell() {
        if currentPlace != nil {
            editNavigationBar()
            imageIsChanges = true
            guard  let data = currentPlace?.imageData, let image = UIImage(data: data) else { return }
            imagePlace.image = image
            imagePlace.contentMode = .scaleAspectFill
            nameField.text = currentPlace?.name
            localField.text = currentPlace?.location
            typeField.text = currentPlace?.type

        }
    }
    private func editNavigationBar(){
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
           // topItem.largeTitleDisplayMode = .always
        }
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: text Field delegate

extension AddPlaceTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldChange() {
        if nameField.text?.isEmpty == true || localField.text?.isEmpty == true
            || typeField.text?.isEmpty == true {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
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
        
        imageIsChanges = true
        
        dismiss(animated: true)
    }
}

