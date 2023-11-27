//
//  ProfileImageServiceModel.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 21.11.2023.
//

import Foundation

struct UserResult: Codable {
    let profileImage: profileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct profileImage: Codable {
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case avatarURL = "small"
    }
}
