//
//  AvatarView.swift
//  GitHubUsers
//
//  Created by Tram Nguyen on 29/08/2024.
//

import Foundation
import SwiftUI
import CachedAsyncImage

struct AvatarView: View {
    var imageUrl: String

    var body: some View {
        CachedAsyncImage(url: URL(string: imageUrl)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
        } placeholder: {
            ProgressView()
        }
    }
}

#Preview {
    AvatarView(imageUrl: "https://avatars.githubusercontent.com/u/94581?v=4")
}
