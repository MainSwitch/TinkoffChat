import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var gcdButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var coreDataButton: UIButton!
    let imagePickerController: UIImagePickerController = UIImagePickerController()
    private var userStorageFacade: IUserStorageFacade
    private var assembly: IPresentationAssembly
    var editingMode: Bool = false {
        didSet {
            self.setEditingMode(isEditing: editingMode)
        }
    }
    private var user: ProfileUser?
    private var repeatSaveBlock: (() -> Void)?
    private var profileWasEdited: Bool {
        return self.user?.usernameWasEdited ?? false ||
            self.user?.descriptionWasEdited ?? false ||
            self.user?.avatarWasEdited ?? false
    }
    init(userStorageFacade: IUserStorageFacade, assembly: IPresentationAssembly) {
        self.userStorageFacade = userStorageFacade
        self.assembly = assembly
        super.init(nibName: "ProfileViewController", bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel,
                                                                     target: self,
                                                                     action: #selector(close))
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        self.detailTextView.delegate = self
        self.imagePickerController.delegate = self
        self.imagePickerController.allowsEditing = false
        self.logButtonFrame(button: self.editProfileButton, function: #function)
        let profileButtonRadius = self.profileButton.bounds.width / 2
        profileImageView.layer.cornerRadius = profileButtonRadius
        profileButton.layer.cornerRadius = profileButtonRadius
        profileButton.clipsToBounds = true
        profileButton.isHidden = true
        editProfileButton.layer.borderWidth = 1
        editProfileButton.layer.borderColor = UIColor.black.cgColor
        editProfileButton.layer.cornerRadius = 10
        editProfileButton.setTitleColor(.black, for: .normal)
        coreDataButton.layer.borderWidth = 1
        coreDataButton.layer.borderColor = UIColor.black.cgColor
        coreDataButton.layer.cornerRadius = 10
        coreDataButton.setTitleColor(.black, for: .normal)
        self.profileImageView.contentMode = .scaleAspectFill
        self.editingMode = false
        self.loadUser()
        self.detailTextView.text = "Нет данных"
        self.detailTextView.textColor = UIColor.lightGray
        self.user = ProfileUser(username: self.userNameField.text,
                                description: self.detailTextView.text,
                                avatar: self.profileImageView.image)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.logButtonFrame(button: self.editProfileButton, function: #function)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func userNameEditingChange(_ sender: UITextField) {
        if let usernameText = sender.text {
            self.user!.usernameWasEdited = usernameText != self.user!.username ?? ""
            self.setEnabledButton(isEnabled: self.profileWasEdited)
        }
    }
    @IBAction func editProfile(sender: UIButton) {
        self.editingMode = true
        self.profileButton.isHidden = false
        self.setEnabledButton(isEnabled: false)
    }
    @IBAction func saveButtonTouch(_ sender: UIButton) {
        self.userNameField.resignFirstResponder()
        self.detailTextView.resignFirstResponder()
        self.repeatSaveBlock = {
            self.activityIndicator.startAnimating()
            self.setEnabledButton(isEnabled: false)
            UserDefaults.standard.set(self.userNameField.text, forKey: "userName")
            self.user!.username = self.userNameField.text
            self.user!.description = self.detailTextView.text
            self.user!.avatar = self.profileImageView.image
            if sender.tag == 0 {
                self.userStorageFacade.selectStrategy(userStorageService: .operation)
            } else if sender.tag == 1 {
                self.userStorageFacade.selectStrategy(userStorageService: .gcdStorage)
            } else {
                self.userStorageFacade.selectStrategy(userStorageService: .coreDataStorage)
            }
            self.userStorageFacade.updateUser(user: self.user!, completionClosure: { (withError: Bool) in
                self.activityIndicator.stopAnimating()
                if withError {
                    self.presentErrorAlertController()
                } else {
                    self.loadUser()
                    self.presentSuccessAlertController()
                    self.profileButton.isHidden = true
                }
                self.setEnabledButton(isEnabled: true)
                self.editingMode = withError
            })
        }
        self.repeatSaveBlock?()
    }
    @IBAction func profileButtonTouch(sender: UIButton) {
        if !self.editingMode {
            return
        }
        print("Выбери изображение профиля")
        let alertController = UIAlertController(title: "Выбрать изображение профиля",
                                                message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Установить из галлереи",
                                                style: .default, handler: self.chooseFromGallery))
        alertController.addAction(UIAlertAction(title: "Сделать фото", style: .default, handler: self.makePhoto))
        alertController.addAction(UIAlertAction(title: "Загрузить фото", style: .default, handler: self.loadPhotos))
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    @objc func keyboardDidShow(notification: NSNotification) {
        if let keyboardSize =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        //self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        //self.scrollView.contentInset = UIEdgeInsets.zero
        self.view.frame.origin.y = 0
    }
    private func loadUser() {
        self.userStorageFacade.getUser(completionClosure: {(user) in
            if let userUnwrapped = user {
                self.user = userUnwrapped
                self.detailTextView.text = userUnwrapped.description
                self.detailTextView.textColor = UIColor.black
            }
            self.profileImageView.image = user?.avatar ?? UIImage.init(named: "im_user_placeholder")
            self.userNameField.text = user?.username ?? ""
        })
    }
    private func setEditingMode(isEditing: Bool) {
        self.userNameField.borderStyle = isEditing ? .roundedRect : .none
        self.editProfileButton.isHidden = isEditing
        self.userNameField.isEnabled = isEditing
        self.detailTextView.isEditable = isEditing
        //self.gcdButton.isHidden = !isEditing
        self.coreDataButton.isHidden = !isEditing
    }
    private func setEnabledButton(isEnabled: Bool) {
        //self.gcdButton.isEnabled = isEnabled
        self.coreDataButton.isEnabled = isEnabled
    }
    private func logButtonFrame(button: UIButton?, function: String) {
        guard let buttonUnwrapped = button else {
            print("\n\nКнопка не проинициализирована в \(function)")
            return
        }
        print("\n\nРазмер кнопки = \(buttonUnwrapped.frame) в \(function) ")
    }
}

// MARK: - UIAlerController
extension ProfileViewController {
    private func loadPhotos(action: UIAlertAction) {
        let photosViewController = self.assembly.photosViewController()
        photosViewController.collectionPickerDelegate = self
        self.present(UINavigationController(rootViewController: photosViewController), animated: true, completion: nil)
    }
    private func chooseFromGallery(action: UIAlertAction) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("Нет доступа к галереи")
        }
    }
    private func makePhoto(action: UIAlertAction) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("Нет доступа к камере")
        }
    }
    private func presentSuccessAlertController() {
        let alertController = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    private func presentErrorAlertController() {
        let alertController = UIAlertController(title: "Ошибка",
                                                message: "Не удалось сохранить данные",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Повторить",
                                                style: .default) { _ in
            self.repeatSaveBlock?()
        })
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Image Picker Delegate
extension ProfileViewController {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage]  as? UIImage {
            self.profileImageView.image = image
            if let previousImage = self.user!.avatar {
                let newImage = image.pngData()!
                let oldImage = previousImage.pngData()!
                self.user!.avatarWasEdited = !newImage.elementsEqual(oldImage)
            } else {
                self.user!.avatarWasEdited = true
            }
            self.setEnabledButton(isEnabled: self.profileWasEdited)
        } else {
            print("Не удалось выбрать изображение")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
// MARK: - IPhotosViewControllerDelegate
extension ProfileViewController: IPhotosViewControllerDelegate {
    func collectionPickerController(_ picker: PhotosViewController, didFinishPickingImage image: UIImage) {
        self.profileImageView.image = image
        if let previousImage = self.user!.avatar {
            let newImage = image.pngData()!
            let oldImage = previousImage.pngData()!
            self.user!.avatarWasEdited = !newImage.elementsEqual(oldImage)
        } else {
            self.user!.avatarWasEdited = true
        }
        self.setEnabledButton(isEnabled: self.profileWasEdited)
        picker.dismiss(animated: true, completion: nil)
    }
}
// MARK: - Text View Delegate
extension ProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let detailText = textView.text {
            self.user!.descriptionWasEdited = detailText != self.user!.description ?? ""
            self.setEnabledButton(isEnabled: self.profileWasEdited)
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Нет данных"
            textView.textColor = UIColor.lightGray
        }
    }
}
