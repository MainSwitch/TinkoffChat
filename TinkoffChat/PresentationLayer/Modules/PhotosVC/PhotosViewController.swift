//
//  PhotosVIewController.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 23/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation
import UIKit

class PhotosViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    weak var collectionPickerDelegate: IPhotosViewControllerDelegate?
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    private var photosFacade: IPhotosFacade
    private var dataSource: [PhotoDisplayModel] = []
    private let imageCache = NSCache<AnyObject, AnyObject>.sharedInstance
    init(photosFacade: IPhotosFacade) {
        self.photosFacade = photosFacade
        super.init(nibName: "PhotosViewController", bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Yellow flowers"
        self.collectionView.register(UINib(nibName: PhotoCollectionViewCell.idenfitifier,
                                           bundle: nil),
                                     forCellWithReuseIdentifier: PhotoCollectionViewCell.idenfitifier)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                target: self,
                                                                action: #selector(close))
    }
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.activityIndicatorView.startAnimating()
        self.photosFacade.fetchChosenImage()
    }
}

// MARK: - IPhotoModelDelegate
extension PhotosViewController: IPhotoModelDelegate {
    func setup(dataSource: [PhotoDisplayModel]) {
        self.dataSource = dataSource
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.collectionView.reloadData()
        }
    }
    func show(error message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: PhotoCollectionViewCell =
            collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.idenfitifier,
                                               for: indexPath) as? PhotoCollectionViewCell {
            cell.imageView.image = UIImage(named: "placeholder")
            let photoDisplayModel = self.dataSource[indexPath.item]
            if let cashedimage = imageCache.object(forKey: photoDisplayModel.imageUrl as NSString),
                let existImage = cashedimage as? UIImage {
                cell.configure(image: existImage, photoDisplayModel: photoDisplayModel)
                return cell
            } else {
                DispatchQueue.global(qos: .userInitiated).async {
                    // swiftlint:disable all
                    self.photosFacade.fetchImage(urlString: photoDisplayModel.webformatUrl) { (image,loadedURL) in
                        // swiftlint:enable all
                        if let image = image, let url = loadedURL {
                            DispatchQueue.main.async {
                                guard self.imageCache.object(forKey: url as NSString) != nil else {
                                    if cell.imageView.image == UIImage(named: "placeholder") {
                                        if url == photoDisplayModel.webformatUrl {
                                            cell.configure(image: image, photoDisplayModel: photoDisplayModel)
                                        }
                                    } else if cell.imageView.image != UIImage(named: "placeholder") {
                                        return
                                    }
                                    return
                                }
                                //cell.configure(image: existImage, photoDisplayModel: photoDisplayModel)
                            }
                            self.imageCache.setObject(image, forKey: photoDisplayModel.imageUrl as NSString)
                        }
                    }
                }
                return cell
            }
        }
        return PhotoCollectionViewCell(frame: CGRect.zero)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell: PhotoCollectionViewCell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell {
            guard let image = cell.imageView.image else {
                return
            }
            self.collectionPickerDelegate?.collectionPickerController(self, didFinishPickingImage: image)
        }
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = self.sectionInsets.left * (self.itemsPerRow + 1)
        let availableWidth = self.view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.sectionInsets.left
    }
}
