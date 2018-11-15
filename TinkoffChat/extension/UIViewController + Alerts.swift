//
//  UIViewController + Alerts.swift
//  tinkoffChat
//
//  Created by Anton on 28/09/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

// MARK: Alert with title and message
extension UIViewController {
    func showAlertWith(title: String, message: String?, completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(_) in
            completion?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func showSaveAlertWith(title: String,
                           message: String?,
                           completionOK: (() -> Void)?,
                           completionRepeat: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: { (_) in
        completionOK?()
    }))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { (_) in
            completionRepeat?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: ImagePiker with image picker
extension UIViewController: UIImagePickerControllerDelegate,
                            UINavigationControllerDelegate {
    func showPhotoAlert(imagePicker: UIImagePickerController) {
        let alert = UIAlertController(title: "Выберите фотографию", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Установить из галлереи", style: .default, handler: { (_) in
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cделать фото", style: .default, handler: { (_) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                imagePicker.allowsEditing = false
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.cameraCaptureMode = .photo
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                self.showAlertWith(title: "Camera Not Found", message: "This device has no Camera", completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
