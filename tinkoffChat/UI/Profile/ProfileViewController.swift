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
    
    @IBOutlet var activityView: UIActivityIndicatorView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userDescription: UILabel!
    
    @IBOutlet var reductImageView: UIImageView!
    @IBOutlet var reductUserNameLabel: UILabel!
    @IBOutlet var reductNameTextField: UITextField!
    @IBOutlet var reductAboutLabel: UILabel!
    @IBOutlet var reductTextView: UITextView!
    @IBOutlet var reductGCDBtn: UIButton!
    @IBOutlet var reductOperationBtn: UIButton!
    
    var rightItemBack: UIBarButtonItem!
    
    var presenter: ProfilePresenter!
    var operationManager: OperationDataManager!
    
    @IBAction func selectProfileImage(_ sender: Any) {
        print("Выбери изображение профиля")
        guard let existingPicker = self.imagePicker else {
            return
        }
        isEnabledSave(isEnabled: true)
        showPhotoAlert(imagePicker: existingPicker)
    }
    @IBAction func gcdAction(_ sender: Any) {
    }
    
    
    @IBAction func operationAction(_ sender: Any) {
        self.operationManager = OperationDataManager(image: reductImageView.image, name: self.reductNameTextField.text, about: self.reductTextView.text, opration: OperationDataManager.OperationType.write)
        let operationQueue = OperationQueue()
        activityView.isHidden = false
        activityView.startAnimating()
        self.reductGCDBtn.isEnabled = false
        self.reductOperationBtn.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        operationManager.completionBlock = {
            OperationQueue.main.addOperation({
                if self.operationManager.errors.isEmpty {
                    self.activityView.stopAnimating()
                    self.showAlertWith(title: "Данные сохранены", message: nil, completion: {
                        self.presenter.setSeveData()
                        self.reductGCDBtn.isEnabled = true
                        self.reductOperationBtn.isEnabled = true
                        self.navigationItem.rightBarButtonItem?.isEnabled = true
                        self.cancelButton()
                    })
                } else {
                    self.showSaveAlertWith(title: "Ошибка", message: "Не удалось сохранить данные", completionRepeat: {
                        self.operationAction(self.reductOperationBtn)
                    })
                }
            })
        }
        operationQueue.addOperation(operationManager)
    }
    
    @IBAction func reduct(_ sender: Any) {
        navigationItem.leftBarButtonItem?.isEnabled = false
        isHiddenReductUI(isHidden: false)
        isHiddenMainUI(isHidden: true)
        self.reductGCDBtn.isEnabled = false
        self.reductOperationBtn.isEnabled = false
        self.rightItemBack = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButton))
        navigationItem.rightBarButtonItem = self.rightItemBack
    }
    
    @objc func cancelButton() {
        isHiddenReductUI(isHidden: true)
        isHiddenMainUI(isHidden: false)
        presenter.loadReductData()
        navigationItem.leftBarButtonItem?.isEnabled = true
        navigationItem.rightBarButtonItem = nil
    }
    
    @objc func backButton() {
        self.dismiss(animated: true, completion: nil)
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
        presenter = ProfilePresenter()
        presenter.view = self
        presenter.loadMainData()
        activityView.hidesWhenStopped = true
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
        reductNameTextField.delegate = self
        reductTextView.delegate = self
        
        self.loadReductData()
        let closeNavigationVCItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(backButton))
        self.navigationItem.leftBarButtonItem = closeNavigationVCItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapOnView = UITapGestureRecognizer(target: self, action: #selector(self.tapOnView(sender:)))
        self.view.addGestureRecognizer(tapOnView)
        
        setupBtn(button: editButton)
        setupBtn(button: reductGCDBtn)
        setupBtn(button: reductOperationBtn)
        
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = selectImageButton.layer.cornerRadius
    }
    
    private func setupBtn(button: UIButton) {
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    @objc func tapOnView(sender: UIViewController) {
        self.view.endEditing(true)
    }
    
    private func isHiddenMainUI(isHidden: Bool) {
        profileImage.isHidden = isHidden
        editButton.isHidden = isHidden
        stackView.isHidden = isHidden
    }
    
    private func isHiddenReductUI(isHidden: Bool) {
        reductUserNameLabel.isHidden = isHidden
        reductNameTextField.isHidden = isHidden
        reductOperationBtn.isHidden = isHidden
        selectImageButton.isHidden = isHidden
        reductAboutLabel.isHidden = isHidden
        reductImageView.isHidden = isHidden
        reductTextView.isHidden = isHidden
        reductGCDBtn.isHidden = isHidden
    }
    
    func isEnabledSave(isEnabled: Bool) {
        reductOperationBtn.isEnabled = isEnabled
        reductOperationBtn.isEnabled = isEnabled
    }
     @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage]  as? UIImage else {
            return
        }
        self.reductImageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: ProfileSaveView {
    func getSaveData() {
        self.profileImage.image = reductImageView.image
        self.userName.text = reductNameTextField.text
        self.userDescription.text = reductTextView.text
    }
    
    func loadMainData() {
        self.operationManager = OperationDataManager()
        if let name = UserDefaults.standard.string(forKey: "name") {
            self.userName.text = name
            self.reductNameTextField.text = name
        }
        if let about = UserDefaults.standard.string(forKey: "about") {
            self.userDescription.text = about
            self.reductTextView.text = about
        }
        if let dataImage = operationManager.getImage() {
            let image = UIImage(data: dataImage)
            self.profileImage.image = image
            self.reductImageView.image = image
        }
    }
    
    func loadReductData() {
        self.operationManager = OperationDataManager(image: nil, name: nil, about: nil, opration: .get)
        let operationQueue = OperationQueue()
        operationManager.completionBlock = {
            OperationQueue.main.addOperation {
                if let name = self.operationManager.userName {
                    self.reductNameTextField.text = name
                }
                if let about = self.operationManager.about {
                    self.reductTextView.text = about
                }
                if let image = self.operationManager.image {
                    self.reductImageView.image = image
                }
            }
        }
        
        operationQueue.addOperation(operationManager)
    }
}

extension ProfileViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let text = textView.text {
            if text != operationManager.about {
                isEnabledSave(isEnabled: true)
            } else {
                isEnabledSave(isEnabled: false)
            }
        }
        return true
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            if text != operationManager.userName {
                isEnabledSave(isEnabled: true)
            } else {
                isEnabledSave(isEnabled: false)
            }
        }
        return true
    }
}
