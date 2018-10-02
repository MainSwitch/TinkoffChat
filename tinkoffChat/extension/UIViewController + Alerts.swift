//
//  UIViewController + Alerts.swift
//  tinkoffChat
//
//  Created by Anton on 28/09/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

//MARK: Alert with title and massage
extension UIViewController {
    
    func showAlertWith(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: ImagePiker with image picker
extension UIViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func showPhotoAlert(imagePicker: UIImagePickerController) {
        let alert = UIAlertController(title: "Выберите фотографию", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Установить из галлереи", style: .default, handler: { (alert) in
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cделать фото", style: .default, handler: { (action) in
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                imagePicker.allowsEditing = false
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.cameraCaptureMode = .photo
                self.present(imagePicker, animated: true, completion: nil)
            }else{
                self.showAlertWith(title: "Camera Not Found", message: "This device has no Camera")
            }
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
