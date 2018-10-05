//
//  ViewController.swift
//  tinkoffChat
//
//  Created by Anton on 20.09.2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit
import AVKit

class ProfileViewController: UIViewController {
    
    let imagePicker: UIImagePickerController? = UIImagePickerController()
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    @IBAction func selectProfileImage(_ sender: Any) {
        print("Выбери изображение профиля")
        guard let existingPicker = self.imagePicker else {
            return
        }
        showPhotoAlert(imagePicker: existingPicker)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let _ = selectImageButton {
            print("Select button frame in 'init':\(self.editButton.frame)")
        } else {
            print("The Select button does not exist yet")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Select button frame in '\(#function)':\(self.editButton.frame)")
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        selectImageButton.layer.cornerRadius = selectImageButton.frame.height / 2
    }
    //MARK: viewDidAppear
    /*
    Во viewDidAppear представление контроллера было добавлено в иерархию представлений и в данном делегате мы работаем с фреймами того устройства, на котором запущено приложение, метод вызывается после завершения работы autolayout
    Во viewDidLoad печатаются фреймы из нашего storyboard, там вёрстка на iPhone SE, но так как мы запускаем приложение на iPhone8Plus или X, то эти фреймы отличаются.
    */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            print("Select button frame in '\(#function)':\(self.editButton.frame)")
    }
    
    private func setupUI(){
        imagePicker?.delegate = self
        
        editButton.backgroundColor = .white
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.black.cgColor
        editButton.layer.cornerRadius = 10
        editButton.setTitleColor(.black, for: .normal)
        
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = selectImageButton.layer.cornerRadius
    }
    
     @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage]  as? UIImage else {
            return
        }
        self.profileImage.image = chosenImage
        dismiss(animated: true, completion: nil)
    }

    
}

