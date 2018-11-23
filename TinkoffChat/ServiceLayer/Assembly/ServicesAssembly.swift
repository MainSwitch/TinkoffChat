//
//  ServiceAssembly.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 15/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation

protocol IServicesAssembly {
    var themeService: IThemeService {get}
    var communicationManager: ICommunicationManager {get}
    var userStorageService: IUserStorageService {get}
    var photosService: IPhotosService {get}
    var coreDataService: ICoreDataService {get}
}

class ServicesAssembly: IServicesAssembly {
    private let coreAssembly: ICoreAssembly
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    lazy var themeService: IThemeService = ThemeService(defaults: UserDefaults.standard)
    lazy var communicationManager: ICommunicationManager =
        NewCommunicationManager(storage: self.coreAssembly.communicatorStorageService,
                                communicator: self.coreAssembly.multipeerCommuncator)
    lazy var userStorageService: IUserStorageService = UserCoreDataStorage(dataStack: self.coreAssembly.coreDataStack)
    lazy var coreDataService: ICoreDataService = CoreDataService(coreData: self.coreAssembly.coreDataStack)
    lazy var photosService: IPhotosService = PhotosService(requestSender: self.coreAssembly.requestSender)
}
