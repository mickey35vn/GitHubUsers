//
//  View+Ext.swift
//  GitHubUsers
//
//  Created by Tram Nguyen on 29/08/2024.
//

import Foundation
import SwiftUI
import Combine
import ProgressHUD

extension View {
    
    /// Handles error reception from a publisher and displays the error using the Common utility.
    /// - Parameter publisher: A publisher that emits errors.
    /// - Returns: A view that receives errors and handles them.
    func onReceiveError(_ publisher: AnyPublisher<Error, Never>) -> some View {
        onReceive(publisher) { error in
            Common.showError(error)
        }
    }
    
    /// Handles loading state reception from a publisher and shows a loading indicator.
    /// - Parameter publisher: A publisher that emits Boolean values indicating loading state.
    /// - Returns: A view that reacts to loading state changes.
    func onReceiveLoading(_ publisher: AnyPublisher<Bool, Never>) -> some View {
        onReceive(publisher) { isLoading in
            ProgressHUD.commonLoading(isLoading)
        }
    }
}
