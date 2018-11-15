//
//  Date + String.swift
//  tinkoffChat
//
//  Created by Anton on 04/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
            func compareTo(date: Date, toGranularity: Calendar.Component) -> ComparisonResult {
                let cal = Calendar.current
                return cal.compare(Date(), to: date, toGranularity: toGranularity)
            }
        dateFormatter.dateFormat = compareTo(date: self,
                                             toGranularity: .day) == .orderedDescending ? "dd MMMto" : "HH:mm"
        return dateFormatter.string(from: self)
    }
}
