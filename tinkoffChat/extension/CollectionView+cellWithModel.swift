//
//  CollectionView+cellWithModel.swift
//  tinkoffChat
//
//  Created by Anton on 04/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

extension UITableView {
    
    func dequeueReusableCell(withModel model: CellViewAnyModel, for indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: type(of: model).cellAnyType)
        let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        model.setupAny(cell: cell)
        return cell
    }
}
