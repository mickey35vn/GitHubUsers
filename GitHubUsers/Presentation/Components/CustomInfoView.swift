//
//  CustomInfoView.swift
//  GitHubUsers
//
//  Created by Tram Nguyen on 29/08/2024.
//

import Foundation
import SwiftUI

struct CustomInfoView: View {
    var imageName: String
    var headline: String
    var subheadline: String

    var body: some View {
        VStack {
            ZStack {
                Color.gray.opacity(0.1)
                    .cornerRadius(25)
                    .frame(width: 50, height: 50)

                Image(systemName: imageName)
                    .foregroundColor(.black)
                    .font(.system(size: 20))
            }
            Text(headline)
                .font(.subheadline)
            Text(subheadline )
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
}

#Preview {
    CustomInfoView(imageName: "person.2.fill", headline: "100+", subheadline: "Follower")
}
