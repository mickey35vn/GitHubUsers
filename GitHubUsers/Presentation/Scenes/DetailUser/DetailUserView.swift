//
//  DetailUserView.swift
//  GitHubUsers
//
//  Created by Tram Nguyen on 29/08/2024.
//

import SwiftUI
import Stinsen

struct DetailUserView: View {
    
    @StateObject var viewModel = DetailUserViewModel()
    
    var user: GithubUserModel
    
    private var blog: String {
        if viewModel.user.blog.isNilOrEmpty {
            return  viewModel.user.landingPage ?? ""
        }
        return viewModel.user.blog ?? ""
    }
    
    private var btnBack : some View { 
        Button(action: { viewModel.back() }) {
            HStack {
                Image(systemName: "arrow.backward")
                    .foregroundColor(.black)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                UserInfoView(model: viewModel.user, displayType: .location)
                HStack {
                    Spacer()
                    CustomInfoView(imageName: "person.2.fill", headline: Common.formatNumber(viewModel.user.followers ?? 0), subheadline: "Follower")
                    Spacer()
                    CustomInfoView(imageName: "medal.star", headline: Common.formatNumber(viewModel.user.following ?? 0), subheadline: "Following")
                    Spacer()
                }
                .padding(24)
                Text("Blog").font(.headline)
                Text(blog)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .onTapGesture {
                        if let url = URL(string: blog) {
                            UIApplication.shared.open(url)
                        }
                    }
                Spacer()
            }
            .padding(24)
            .onReceiveError(viewModel.errorTracker.errorPublisher)
            .onReceiveLoading(viewModel.activityIndicator.isLoadingPublisher)
        }
        .navigationBarTitle("User Details", displayMode: .inline)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .onAppear(perform: {
            viewModel.user = user
            viewModel.login = user.login ?? ""
        })
    }
}

#Preview {
    DetailUserView(user: GithubUserModel(login: "mickey35vn", avatar: "https://avatars.githubusercontent.com/u/94581?v=4", landingPage: "https://github.com/mickey35vn", location: "Vietnam"))
}
