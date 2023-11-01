//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 30.10.2023.
//

import Foundation
import UIKit

final class ProfileImageService {
    
    //MARK: - Public Properties
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    //MARK: - Private Properties
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private (set) var avatarURL: String?
    
    //MARK: - Initializers
    private init() {}
    
    //MARK: - Public Methods
    func fetchProfileImageURL (userName: String,_ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        let request = avatarURLRequest(userName: userName)
        let task = object(for: request) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let body):
                let avatarURL = body.profileImage.avatarURL
                self.avatarURL = avatarURL
                completion(.success(avatarURL))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarURL])
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

extension ProfileImageService {
    private func object(
        for request: URLRequest,
completion: @escaping (Result<UserResult, Error>) -> Void) -> URLSessionTask {
            let decoder = JSONDecoder()
            return urlSession.data(for: request) { (result: Result<Data, Error>) in
                let response = result.flatMap {data -> Result<UserResult, Error> in
                    Result { try decoder.decode(UserResult.self, from: data)}
                }
                completion(response)
            }
        }
    
    private func avatarURLRequest(userName: String) -> URLRequest {
        let token = OAuth2TokenStorage().token ?? ""
        var request = URLRequest.makeHTTPRequest(
            path: "/users"
            + "/\(userName)",
            httpMethod: "GET",
            baseURL: DefaultBaseURL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private struct UserResult: Codable {
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
    
}
