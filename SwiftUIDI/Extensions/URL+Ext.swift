//
//  URL+Ext.swift
//  SwiftUI-DI
//
//  Created by Maysam Shahsavari on 2024-01-07.
//

import Foundation

extension URL {
    var isValid: Bool {
        get {
            let regEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,6}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
            let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [regEx])
            return predicate.evaluate(with: self.absoluteString)
        }
    }
}
