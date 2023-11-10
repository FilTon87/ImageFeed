//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 25.10.2023.
//
import UIKit
import ProgressHUD

final class ProfileService {
    
    //MARK: - Public Properties
    static let shared = ProfileService()
    
    //MARK: - Private Properties
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private (set) var profile: Profile?
    
    //MARK: - Initializers
    private init() {}
    
    
    //MARK: - Public Methods
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        let request = profileRequest(token: token)
        let task = object(for: request) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let body):
                let userName = body.userName ?? ""
                let firstName = body.firstName ?? ""
                let lastName = body.lastName ?? ""
                let name = firstName + " " + lastName
                let bio = body.bio ?? ""
                let profile = Profile(userName: userName, name: name, bio: bio)
                self.profile = profile
                completion(.success(profile))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
}


extension ProfileService {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<ProfileResult, Error>) -> Void) -> URLSessionTask {
            let decoder = JSONDecoder()
            return urlSession.objectTask(for: request) { (result: Result<Data, Error>) in
                let response = result.flatMap {data -> Result<ProfileResult, Error> in
                    Result { try decoder.decode(ProfileResult.self, from: data)}
                }
                completion(response)
            }
        }
    
    private func profileRequest(token: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            baseURL: DefaultBaseURL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private struct ProfileResult: Codable {
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
}
