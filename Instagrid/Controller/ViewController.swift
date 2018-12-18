//
//  ViewController.swift
//  Instagrid
//
//  Created by Marques Lucas on 18/12/2018.
//  Copyright © 2018 Marques Lucas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var mainLayout: LayoutView! // Contains the main view
    @IBOutlet var layoutSelecter: [UIButton]!  // Contains the UIButton corresponding of the layout selector button
    
    private var index: Int = 0 // Stock the button value of the main view that was pressing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainLayout.layout = .layoutOne
    }
    
    // Change the layout value according to the pressed button
    @IBAction func didTapeLayoutSelecter(_ sender: UIButton) {
        switch sender {
        case layoutSelecter[0]:
            mainLayout.layout = .layoutOne
        case layoutSelecter[1]:
            mainLayout.layout = .layoutTwoo
        case layoutSelecter[2]:
            mainLayout.layout = .layoutThree
        default:
            print("erreur")
        }
    }
    
    // Call the method pop-up when one of the button in the main view is activate
    @IBAction func didTapeGridButton(_ sender: UIButton) {
        index = sender.tag
        popup()
    }

    // Display a pop-up offering 3 options to the user
    private func popup() {
        let alert = UIAlertController(title: "Choisis une option", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Choisir dans l'album", style: .default, handler: { _ in self.openLibrary() }))
        alert.addAction(UIAlertAction(title: "Prendre une nouvelle photo", style: .default, handler: { _ in self.openCamera() }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Open the device library
    private func openLibrary() {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    // Recover the images sent by the camera or the ibrary and displays on the UIImageView corespondant
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image: UIImageView? = nil
        if let imageChoice = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            mainLayout.hideButton(index: index)
            if let unclearImage = mainLayout.imageAssigned(index) {
                image = unclearImage
                image?.contentMode = .scaleToFill
                image?.image = imageChoice
            } else {
                alert(title: "Erreur", massage: "Une erreur est survenu de la sélection d'image.")
            }
        } else {
            alert(title: "Erreur", massage: "le fichier sélectionné n'est pas une image.")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // Open the camera if it has one
    private func openCamera() {
        let picker: UIImagePickerController = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.cameraCaptureMode = .photo
            present(picker, animated: true, completion: nil)
        } else {
            alert(title: "Erreur", massage: "Pas de caméra sur cet appareil.")
        }
    }
    
    // Display a custom pop-up based on the received parameters
    private func alert(title: String, massage: String) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}

