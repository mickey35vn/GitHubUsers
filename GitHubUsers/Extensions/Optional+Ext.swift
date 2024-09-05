//
//  Optional+Ext.swift
//  GitHubUsers
//
//  Created by Tram Nguyen on 29/08/2024.
//

import Foundation

extension Optional where Wrapped == String {
    
    /// A computed property that checks if the optional string is either `nil` or empty.
    var isNilOrEmpty: Bool {
        return self == nil || self?.isEmpty == true
    }
}
