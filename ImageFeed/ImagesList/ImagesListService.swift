//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 10.11.2023.
//

import UIKit

final class ImagesListService {
    //MARK: - Public Properties
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let shared = ImagesListService()
    
    //MARK: - Private Properties
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private var lastLoadedPage: Int?
    private (set) var photos: [Photo] = []
    
    //MARK: - Initializers
    private init() {}
    
    //MARK: - Public Methods
    func fetchPhotosNextPage (_ completion: @escaping (Result<Array<Any>, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        let request = photoRequest(nextPage: nextPage)
        let task = object(for: request) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let body):
                let photo = Photo(
                    id: body.id,
 //                   size: <#T##CGSize#>,
                    createdAt: body.createdAt,
                    welcomeDescription: body.welcomeDescription,
                    thumbImageURL: body.urls.thumbImageURL,
                    largeImageURL: body.urls.largeImageURL,
                    isLiked: body.isLiked)
                photos.append(photo)
                self.photos = photos
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["photos": photos])
                self.task = nil
                lastLoadedPage! += 1
                completion(.success(photos))
            case .failure(let error):
                self.task = nil
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

extension ImagesListService {
    private func photoRequest(nextPage: Int) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/photos"
            + "?page=\(nextPage)"
            + "?per_page=10",
            httpMethod: "GET",
            baseURL: DefaultBaseURL)
        return request
    }
    
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<PhotoResult, Error>) -> Void) -> URLSessionTask {
            let decoder = JSONDecoder()
            return urlSession.objectTask(for: request) { (result: Result<Data, Error>) in
                let response = result.flatMap {data -> Result<PhotoResult, Error> in
                    Result { try decoder.decode(PhotoResult.self, from: data)}
                }
                completion(response)
            }
        }

    private struct PhotoResult: Codable {
        let id: String
        let width: String
        let height: String
        let createdAt: Date?
        let welcomeDescription: String?
        let urls: urlsResult
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
    
    struct urlsResult: Codable {
        let thumbImageURL: String
        let largeImageURL: String
        
        enum CodingKeys: String, CodingKey {
            case thumbImageURL = "thumb"
            case largeImageURL = "full"
        }
    }
    
     struct Photo {
        let id: String
//        let size: CGSize
        let createdAt: Date?
        let welcomeDescription: String?
        let thumbImageURL: String
        let largeImageURL: String
        let isLiked: Bool
    }
}
