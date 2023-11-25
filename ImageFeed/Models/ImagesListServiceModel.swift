//
//  ImagesListServiceModel.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 21.11.2023.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let width: CGFloat
    let height: CGFloat
    let createdAt: String?
    let welcomeDescription: String?
    let urls: UrlsResult
    let isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case createdAt = "created_at"
        case welcomeDescription = "description"
        case urls = "urls"
        case isLiked = "liked_by_user"
    }
}

struct UrlsResult: Codable {
    let thumbImageURL: String
    let largeImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case thumbImageURL = "thumb"
        case largeImageURL = "full"
    }
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct LikeResult: Codable {
    let photo: PhotoResult?
}
