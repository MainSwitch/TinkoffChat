//
//  PresentationAssembly.swift
//  tinkoffChat
//
//  Created by Anton on 16/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation

protocol IPresentationAssembly {
    var themeFacade: IThemeFacade {get}
    var userStorageFacade: IUserStorageFacade {get}
    var communicationFacade: ICommunicationFacade {get}
    var coreDataFacade: ICoreDataFacade {get}
    func photosViewController() -> PhotosViewController
    func profileViewController() -> ProfileViewController
}
class PresentationAssembly: IPresentationAssembly {
    private let serviceAssembly: IServicesAssembly
    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    lazy var themeFacade: IThemeFacade = ThemeFacade(themeService: self.serviceAssembly.themeService)
    lazy var userStorageFacade: IUserStorageFacade =
        UserStorageFacade(userStorageService: self.serviceAssembly.userStorageService,
                          // swiftlint:disable:next force_cast
                          userCoreDataStorage: self.serviceAssembly.userStorageService as! UserCoreDataStorage)
    // swiftlint:disable:previous force_cast
    lazy var communicationFacade: ICommunicationFacade =
        CommunicationFacade(communicationManager: self.serviceAssembly.communicationManager)
    lazy var coreDataFacade: ICoreDataFacade = CoreDataFacade(coreData: self.serviceAssembly.coreDataService)
    // MARK: - ViewControllers
    func profileViewController() -> ProfileViewController {
        return ProfileViewController(userStorageFacade: self.userStorageFacade, assembly: self)
    }
    func photosViewController() -> PhotosViewController {
        let photoFacade: IPhotosFacade = PhotosFacade(photosService: self.serviceAssembly.photosService)
        let photosViewController = PhotosViewController(photosFacade: photoFacade)
        photoFacade.delegate = photosViewController
        return photosViewController
    }
}
