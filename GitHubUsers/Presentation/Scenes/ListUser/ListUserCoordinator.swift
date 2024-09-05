//
//  ListUserCoordinator.swift
//  GitHubUsers
//
//  Created by Tram Nguyen on 29/08/2024.
//

import Foundation
import Stinsen
import SwiftUI

final class ListUserCoordinator: NavigationCoordinatable {

    let stack = NavigationStack(initial: \ListUserCoordinator.start)
    
    @Root var start = makeStart
    @Route(.push) var pushToDetail = makeDetail
}

extension ListUserCoordinator {
    
    /// Creates the initial view for listing users.
    /// - Returns: A view representing the list of GitHub users.
    @ViewBuilder func makeStart() -> some View {
        ListUserView()
    }
    
    /// Creates the detail view for a specific GitHub user.
    /// - Parameter user: The GitHub user model to display in the detail view.
    /// - Returns: A view representing the details of the specified user.
    @ViewBuilder func makeDetail(user: GithubUserModel) -> some View {
        DetailUserView(user: user)
    }
}
