//
//  ProfileServiceModel.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 21.11.2023.
//

import Foundation

struct ProfileResult: Codable {
    let userName: String?
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

struct Profile {
    let userName: String
    let name: String
    let bio: String
}
