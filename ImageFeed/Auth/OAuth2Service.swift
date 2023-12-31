//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 11.10.2023.
//

import Foundation

final class OAuth2Service {
    //MARK: - Public Properties
    static let shared = OAuth2Service()
    
    
    //MARK: - Private Properties
    private let urlSession = URLSession.shared
    private var lastCode: String?
    private var task: URLSessionTask?
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    
    private (set) var authToken: String? {
        get {
            return oAuth2TokenStorage.token
        }
        set {
            oAuth2TokenStorage.token = newValue
        }
    }
    
    //MARK: - Initializers
    private init() {}
    
    //MARK: - Public Methods
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        let request = authTokenRequest(code: code)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                self.task = nil
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
                self.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
}

extension OAuth2Service {
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(AccessKey)"
            + "&&client_secret=\(SecretKey)"
            + "&&redirect_uri=\(RedirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        )
    }
}

// MARK: - HTTP Request
extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = DefaultBaseURL) -> URLRequest {
            var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
            request.httpMethod = httpMethod
            return request
        }
}
