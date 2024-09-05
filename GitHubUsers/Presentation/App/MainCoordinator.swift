//
//  MainCoordinator.swift
//  GitHubUsers
//
//  Created by Tram Nguyen on 29/08/2024.
//

import Foundation
import Stinsen
import SwiftUI

final class MainCoordinator: NavigationCoordinatable {
    
    var stack: Stinsen.NavigationStack<MainCoordinator>
    
    @Root var listUser = makeListUser
    
    init() {
        stack = NavigationStack(initial: \MainCoordinator.listUser)
    }
    
    /// A shared view modifier that applies common logic to the view.
    /// - Parameter view: The view to be modified.
    /// - Returns: A modified view with additional behavior.
    @ViewBuilder func sharedView(_ view: AnyView) -> some View {
        view
            .onAppear {
                self.root(\.listUser)
            }
    }
    
    /// Customizes the provided view by applying shared behavior.
    /// - Parameter view: The view to customize.
    /// - Returns: A customized view.
    func customize(_ view: AnyView) -> some View {
        sharedView(view)
    }
}

extension MainCoordinator {
    
    /// Creates the list user coordinator and its associated navigation view.
    /// - Returns: A navigation view coordinator for the ListUserCoordinator.
    func makeListUser() -> NavigationViewCoordinator<ListUserCoordinator> {
        NavigationViewCoordinator(ListUserCoordinator())
    }
}
