//
//  UserRow.swift
//  GitHubUsers
//
//  Created by Tram Nguyen on 29/08/2024.
//

import SwiftUI

enum UserInfoDisplayType {
    case landingPage
    case location
}

struct UserInfoView: View {
    
    var model: GithubUserModel
    var displayType: UserInfoDisplayType
    
    var body: some View {
        HStack(alignment: .top) {
            AvatarView(imageUrl: model.avatar ?? "")
            
            VStack(alignment: .leading) {
                Text(model.login ?? "").font(.headline)
                Divider()
                if displayType == .landingPage {
                    Text(model.landingPage ?? "")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            if let url = URL(string: model.landingPage ?? "") {
                                UIApplication.shared.open(url)
                            }
                        }
                } else {
                    if displayType == .location {
                        HStack {
                            Image(systemName: "location")
                                .foregroundColor(.gray)
                            Text(model.location ?? "Unknown")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding(.leading, 10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    UserInfoView(model: GithubUserModel(login: "mickey35vn", avatar: "https://avatars.githubusercontent.com/u/94581?v=4", landingPage: "https://github.com/mickey35vn", location: "Vietnam"), displayType: .location)
}
