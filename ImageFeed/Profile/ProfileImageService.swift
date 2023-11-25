//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 30.10.2023.
//
import UIKit

final class ProfileImageService {
    
    //MARK: - Public Properties
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    //MARK: - Private Properties
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private (set) var avatarURL: String?
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    
    //MARK: - Initializers
    private init() {}
    
    //MARK: - Public Methods
    func fetchProfileImageURL (userName: String,_ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        let request = avatarURLRequest(userName: userName)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let body):
                let avatarURL = body.profileImage.avatarURL
                self.avatarURL = avatarURL
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarURL])
                self.task = nil
                completion(.success(avatarURL))
            case .failure(let error):
                self.task = nil
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

extension ProfileImageService {
    
    private func avatarURLRequest(userName: String) -> URLRequest {
        let token = oAuth2TokenStorage.token ?? ""
        var request = URLRequest.makeHTTPRequest(
            path: "/users"
            + "/\(userName)",
            httpMethod: "GET",
            baseURL: DefaultBaseURL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
