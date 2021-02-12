//
//  Date+Extensions.swift
//  MarvelCharacters
//
//  Created by Daniel Rincon on 11/02/2021.
//

import Foundation

public extension Date {
    func formatddMMyyyyhhmmUTC() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyyHHmm"
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        return dateFormatter.string(from: self)
    }
}
