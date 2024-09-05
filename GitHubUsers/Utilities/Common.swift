//
//  Common.swift
//  GitHubUsers
//
//  Created by Tram Nguyen on 29/08/2024.
//

import Foundation
import SwiftMessages

class Common {
    
    /// Formats an integer into a user-friendly string representation.
    /// - Parameter number: The integer to format.
    /// - Returns: A formatted string.
    static func formatNumber(_ number: Int) -> String {
        if number >  100 {
            let roundedNumber = (number / 100) * 100
            return "\(roundedNumber)+"
        }
        
        if number > 10 {
            let roundedNumber = (number / 10) * 10
            return "\(roundedNumber)+"
        }
        
        return "\(number)"
    }
    
    /// Displays an error message based on the provided error.
    /// - Parameter error: An optional error to display.
    static func showError(_ error: Error?) {
        if error != nil {
            if let error = error as? APIError {
                showSMErrorAlert(error.displayText)
            }
            else {
                let errorCode = (error as? NSError)?.code
                ///Error code = 13: NO interet connection
                
                if errorCode == 13 {
                    showSMErrorAlert("There is no internet connection", type: .warning)
                }
                else {
                    showSMErrorAlert(error?.localizedDescription ?? "")
                }
            }
        }
    }
    
    /// Shows a message alert using SwiftMessages.
    /// - Parameters:
    ///   - message: The message to display.
    ///   - type: The theme of the alert (default is error).
    static func showSMErrorAlert(_ message: String, type: Theme = .error) {
        Task { @MainActor in
            SwiftMessages.show {
                let view = MessageView.viewFromNib(layout: .tabView)
                view.configureTheme(type)
                view.configureContent(title: "", body: message)
                view.configureDropShadow()
                view.button?.isHidden = true
                return view
            }
         }
    }
}
