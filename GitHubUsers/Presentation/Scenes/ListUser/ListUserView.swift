//
//  ListUserView.swift
//  GitHubUsers
//
//  Created by Tram Nguyen on 29/08/2024.
//

import SwiftUI
import Stinsen
import ProgressHUD

struct ListUserView: View {
    
    @StateObject var viewModel = ListUserViewModel()
    
    private var loadingIndicator: some View {
        ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .listRowSeparator(.hidden)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.state.users, id: \.id) { user in
                    UserInfoView(model: user, displayType: .landingPage)
                        .onTapGesture {
                            viewModel.pushToDetail(user: user)
                        }
                        .listRowSeparator(.hidden)
                        .onAppear {
                            if self.viewModel.isLast(user: user) {
                                self.viewModel.fetchNextPageIfPossible()
                            }
                        }
                }
                if viewModel.canLoadNextPage {
                    loadingIndicator
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Github Users", displayMode: .inline)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: viewModel.fetchNextPageIfPossible)
        }
    }
}

#Preview {
    ListUserView()
}
