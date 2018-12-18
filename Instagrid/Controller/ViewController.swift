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
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientionDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(animationView(_:)))
        mainLayout.addGestureRecognizer(panGestureRecognizer)
    }
    
    // Call the setShareIndication method
    @objc private func deviceOrientionDidChange() {
        mainLayout.setShareIndication(orientation: UIDevice.current.orientation)
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
    
    // Animation management
    @objc func animationView(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            dragView(gesture: sender)
        case .cancelled, .ended:
            resetView(gesture: sender)
        default:
            break
        }
    }
    
    // Returns the main view to its original position with an animation
    private func resetView(gesture: UIPanGestureRecognizer) {
        mainLayout.transform = .identity
        mainLayout.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.mainLayout.transform = .identity
        }, completion: nil)
    }
    
    // Move the main view and call displayShareSheet or resetMainLayout when the view reaches a certain position
    private func dragView(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: mainLayout)
        
        switch UIDevice.current.orientation {
        case .portrait:
            let transform = CGAffineTransform(translationX: 0, y: translation.y)
            mainLayout.transform = transform
            if translation.y < -115 {
                displayShareSheet()
            } else if translation.y > 115 {
                mainLayout.resetMainLayout()
            }
        case .landscapeLeft ,.landscapeRight:
            let transform = CGAffineTransform(translationX: translation.x, y: 0)
            mainLayout.transform = transform
            if translation.x < -115 {
                displayShareSheet()
            } else if translation.x > 115 {
                mainLayout.resetMainLayout()
            }        default:
            break
        }
    }
    
    // Display a pop-up with different sharing options
    private func displayShareSheet() {
        let image = convert()
        if image != nil {
            let activityViewController = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
            present(activityViewController, animated: true, completion: nil)
        } else {
            alert(title: "Erreur", massage: "Erreur l'or de la création de l'image")
        }
    }
    
    // Converted the main view to UIImage
    func convert() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(mainLayout.layer.frame.size, false, 0.0)
        mainLayout.layer.render(in: UIGraphicsGetCurrentContext()!)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return viewImage
    }
}

