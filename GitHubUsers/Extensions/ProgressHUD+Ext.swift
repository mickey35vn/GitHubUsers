//
//  ProgressHUD+Ext.swift
//  GitHubUsers
//
//  Created by Tram Nguyen on 29/08/2024.
//

import Foundation
import ProgressHUD

extension ProgressHUD {
    
    /// Displays or dismisses a loading indicator based on the provided state.
    /// - Parameter willLoading: A Boolean value indicating whether to show or hide the loading indicator.
    static func commonLoading(_ willLoading: Bool) {
        if willLoading {
            self.colorBackground = .black.withAlphaComponent(0.25)
            self.animationType = .circleStrokeSpin
            self.colorHUD = .systemGray
            self.animate(interaction: false)
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dismiss()
            }
        }
    }
}
