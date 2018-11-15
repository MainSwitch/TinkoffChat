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
    //@IBOutlet var reductOperationBtn: UIButton!
    var rightItemBack: UIBarButtonItem!
    var presenter: ProfilePresenter!
    var operationManager: ProfileDataSaveManager!
    let storageManager = (UIApplication.shared.delegate as? AppDelegate)?.storageManager ?? StorageManager()
    var operationQueue = OperationQueue()
    @IBAction func selectProfileImage(_ sender: Any) {
        print("Выбери изображение профиля")
        guard let existingPicker = self.imagePicker else {
            return
        }
        showPhotoAlert(imagePicker: existingPicker)
    }
    @IBAction func saveAction(_ sender: Any) {
//        let completion = {
//            OperationQueue.main.addOperation({
//                if self.operationManager.errors.isEmpty {
//                    self.activityView.stopAnimating()
//                    self.showAlertWith(title: "Данные сохранены", message: nil, completion: {
//                        self.presenter.setSeveData()
//                        self.reductGCDBtn.isEnabled = true
//                        self.reductOperationBtn.isEnabled = true
//                        self.navigationItem.rightBarButtonItem?.isEnabled = true
//                        self.cancelButton()
//                    })
//                } else {
//                    self.showSaveAlertWith(title: "Ошибка", message: "Не удалось сохранить данные", completionOK: {
//                        self.activityView.stopAnimating()
//                        self.operationManager = nil
//                        self.reductGCDBtn.isEnabled = true
//                        self.reductOperationBtn.isEnabled = true
//                        self.navigationItem.rightBarButtonItem?.isEnabled = true
//                    }, completionRepeat: {
//                        self.gcdAction(self.reductGCDBtn)
//                    })
//                }
//            })
//        }
//        self.operationManager = GCDDataManager(completionBlock: completion)
//        activityView.isHidden = false
//        activityView.startAnimating()
//        self.reductGCDBtn.isEnabled = false
//        self.reductOperationBtn.isEnabled = false
//        self.navigationItem.rightBarButtonItem?.isEnabled = false
//        self.tapOnView(sender: self)
//        self.operationManager.saveData(name: reductNameTextField.text,
        //about: reductTextView.text, image: reductImageView.image)
        activityView.isHidden = false
        activityView.startAnimating()
        if let name = reductNameTextField.text {
            if let about = reductTextView.text {
                if let image = reductImageView.image?.pngData() {
                    storageManager.saveProfileData(name: name, about: about, image: image)
                }
            }
        }
        userName.text = reductNameTextField.text
        userDescription.text = reductTextView.text
        profileImage.image = reductImageView.image
        cancelButton()
    }
//    @IBAction func CoreData(_ sender: Any) {
//        if let name = reductNameTextField.text {
//            if let about = reductTextView.text {
//                storageManager.savePrifileData(name: name, about: about)
//            }
//        }
//
//    }
//
//    @IBAction func fetch(_ sender: Any) {
//        userName.text = storageManager.fetch()
//    }
//    @IBAction func operationAction(_ sender: Any) {
//        let completion = {
//            OperationQueue.main.addOperation({
//                if self.operationManager.errors.isEmpty {
//                    self.activityView.stopAnimating()
//                    self.showAlertWith(title: "Данные сохранены", message: nil, completion: {
//                        self.presenter.setSeveData()
//                        self.reductGCDBtn.isEnabled = true
//                        self.reductOperationBtn.isEnabled = true
//                        self.navigationItem.rightBarButtonItem?.isEnabled = true
//                        self.cancelButton()
//                    })
//                } else {
//                    self.showSaveAlertWith(title: "Ошибка", message: "Не удалось сохранить данные",completionOK: {
//                        self.activityView.stopAnimating()
//                        self.operationManager = nil
//                        self.reductGCDBtn.isEnabled = true
//                        self.reductOperationBtn.isEnabled = true
//                        self.navigationItem.rightBarButtonItem?.isEnabled = true
//                    }, completionRepeat: {
//                        self.activityView.stopAnimating()
//                        self.operationManager = nil
//                        self.reductGCDBtn.isEnabled = true
//                        self.reductOperationBtn.isEnabled = true
//                        self.navigationItem.rightBarButtonItem?.isEnabled = true
//                        self.operationAction(self.reductOperationBtn)
//                    })
//                }
//            })
//        }
//        self.operationManager = OperationDataManager(image: reductImageView.image,
//        name: self.reductNameTextField.text, about: self.reductTextView.text,completionBlock: completion,
//        opration: OperationDataManager.OperationType.write)
//        
//        self.operationManager.saveData(name: self.reductNameTextField.text,
//        about: self.reductTextView.text, image: reductImageView.image)
//        activityView.isHidden = false
//        activityView.startAnimating()
//        self.reductGCDBtn.isEnabled = false
//        self.reductOperationBtn.isEnabled = false
//        self.navigationItem.rightBarButtonItem?.isEnabled = false
//        self.tapOnView(sender: self)
//        if let operation = operationManager as? OperationDataManager {
//            operationQueue.maxConcurrentOperationCount = 1
//            operationQueue.addOperation(operation)
//        }
//    }
    @IBAction func reduct(_ sender: Any) {
        navigationItem.leftBarButtonItem?.isEnabled = false
        isHiddenReductUI(isHidden: false)
        isHiddenMainUI(isHidden: true)
        self.reductGCDBtn.isEnabled = false
        //self.reductOperationBtn.isEnabled = false
        self.rightItemBack = UIBarButtonItem(barButtonSystemItem: .cancel,
                                             target: self,
                                             action: #selector(cancelButton))
        navigationItem.rightBarButtonItem = self.rightItemBack
    }
    @objc func cancelButton() {
        isHiddenReductUI(isHidden: true)
        isHiddenMainUI(isHidden: false)
        presenter.loadReductData()
        presenter.loadMainData()
        tapOnView(sender: self)
        activityView.stopAnimating()
        navigationItem.leftBarButtonItem?.isEnabled = true
        navigationItem.rightBarButtonItem = nil
    }
    @objc func backButton() {
        self.dismiss(animated: true, completion: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if selectImageButton != nil {
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
    // MARK: viewDidAppear

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            print("Select button frame in '\(#function)':\(self.editButton.frame)")
    }
    private func setupUI() {
        imagePicker?.delegate = self
        reductNameTextField.delegate = self
        reductTextView.delegate = self
        self.operationQueue.maxConcurrentOperationCount = 1
        self.presenter.loadReductData()
        let closeNavigationVCItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                    target: self,
                                                    action: #selector(backButton))
        self.navigationItem.leftBarButtonItem = closeNavigationVCItem
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        let tapOnView = UITapGestureRecognizer(target: self, action: #selector(self.tapOnView(sender:)))
        self.view.addGestureRecognizer(tapOnView)
        setupBtn(button: editButton)
        setupBtn(button: reductGCDBtn)
        //setupBtn(button: reductOperationBtn)
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
        if let keyboardSize =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
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
        //reductOperationBtn.isHidden = isHidden
        selectImageButton.isHidden = isHidden
        reductAboutLabel.isHidden = isHidden
        reductImageView.isHidden = isHidden
        reductTextView.isHidden = isHidden
        reductGCDBtn.isHidden = isHidden
    }
    func isEnabledSave(isEnabled: Bool) {
        //reductOperationBtn.isEnabled = isEnabled
        reductGCDBtn.isEnabled = isEnabled
    }
    @objc func imagePickerController(_ picker: UIImagePickerController,
                                     didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage]  as? UIImage else {
            return
        }
        guard let fetchImageData = storageManager.fetch()["image"],
            let fetchImage = UIImage(data: fetchImageData) else {
            isEnabledSave(isEnabled: true)
            self.reductImageView.image = chosenImage
            dismiss(animated: true, completion: nil)
            return
        }
        isEnabledSave(isEnabled: chosenImage == fetchImage)
        self.reductImageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: ProfileSaveView {
    func getSaveData() {
        loadMainData() // Дабы удовлетворить пункт 9
//        self.profileImage.image = reductImageView.image
//        self.userName.text = reductNameTextField.text
//        self.userDescription.text = reductTextView.text
    }
    func loadMainData() {
//        let completion = {
//            OperationQueue.main.addOperation {
//                if let name = self.operationManager.userName {
//                    self.userName.text = name
//                }
//                if let about = self.operationManager.about {
//                    self.userDescription.text = about
//                }
//                if let image = self.operationManager.image {
//                    self.profileImage.image = image
//                }
//            }
//        }
//        self.operationManager = OperationDataManager(image: nil,
//                                                     name: nil, about: nil,
//                                                     completionBlock: completion,
//                                                     opration: .get)
//        if let operation = operationManager as? OperationDataManager {
//            self.operationQueue.addOperation(operation)
//        }
        let dictionary = storageManager.fetch()
        guard let name = dictionary["name"], let about = dictionary["about"], let image = dictionary["image"] else {
            return
        }
        userName.text = String(data: name, encoding: .utf8)
        userDescription.text = String(data: about, encoding: .utf8)
        profileImage.image = UIImage(data: image)
    }
    func loadReductData() {
        let dictionary = storageManager.fetch()
        guard let name = dictionary["name"], let about = dictionary["about"], let image = dictionary["image"] else {
            return
        }
        reductNameTextField.text = String(data: name, encoding: .utf8)
        reductTextView.text = String(data: about, encoding: .utf8)
        reductImageView.image = UIImage(data: image)
//        let completion = {
//            OperationQueue.main.addOperation {
//                if let name = self.operationManager.userName {
//                    self.reductNameTextField.text = name
//                }
//                if let about = self.operationManager.about {
//                    self.reductTextView.text = about
//                }
//                if let image = self.operationManager.image {
//                    self.reductImageView.image = image
//                }
//            }
//        }
//        self.operationManager = OperationDataManager(image: nil,
//                                                     name: nil, about: nil,
//                                                     completionBlock: completion,
//                                                     opration: .get)
//        if let operation = operationManager as? OperationDataManager {
//            self.operationQueue.addOperation(operation)
//        }
    }
}

extension ProfileViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let text = textView.text {
            guard let name = storageManager.fetch()["name"] else {
                isEnabledSave(isEnabled: true)
                return true
            }
            if text != String(data: name, encoding: .utf8) {
                isEnabledSave(isEnabled: true)
            } else {
                isEnabledSave(isEnabled: false)
            }
        }
        return true
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        var resultText: String?
        guard let about = storageManager.fetch()["about"] else {
            isEnabledSave(isEnabled: true)
            return true
        }
        guard let text = textField.text else {
            isEnabledSave(isEnabled: true)
            return true
        }
        switch range.length {
        case 0:
            resultText = text + string
        case 1:
            resultText = text
            resultText?.removeLast()
        default:
            break
        }
        if String(data: about, encoding: .utf8) != resultText {
            isEnabledSave(isEnabled: true)
        } else {
            isEnabledSave(isEnabled: false)
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tapOnView(sender: self)
        return true
    }
}