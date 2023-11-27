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
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private var lastLoadedPage: Int?
    private (set) var photos: [Photo] = []
    private lazy var dateFormatter = ISO8601DateFormatter()
    
    //MARK: - Initializers
    private init() {}
    
    //MARK: - Public Methods
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        task?.cancel()
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        let request = photoRequest(nextPage: nextPage)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let body):
                body.forEach { photoResult in self.photos.append(
                    Photo(
                        id: photoResult.id,
                        size: CGSize(width: photoResult.width, height: photoResult.height),
                        createdAt: self.dateFormatter.date(from: photoResult.createdAt ?? ""),
                        welcomeDescription: photoResult.welcomeDescription,
                        thumbImageURL: photoResult.urls.thumbImageURL,
                        largeImageURL: photoResult.urls.largeImageURL,
                        isLiked: photoResult.isLiked))
                }
                self.lastLoadedPage = nextPage
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["photos": photos])
                self.task = nil
            case .failure:
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    func changeLike (id: String, isLiked: Bool, _ completion: @escaping (Result<[Photo], Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        let request = if isLiked == false { delteLikeRequest(id: id) } else { makeLikeRequest(id: id) }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(_):
                if let index = self.photos.firstIndex(where: { $0.id == id}) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked)
                    self.photos[index] = newPhoto
                }
                self.task = nil
                completion(.success(photos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

extension ImagesListService {
    private func photoRequest(nextPage: Int) -> URLRequest {
        let token = oAuth2TokenStorage.token ?? ""
        var request = URLRequest.makeHTTPRequest(
            path: "/photos"
            + "?page=\(nextPage)"
            + "&per_page=10",
            httpMethod: "GET",
            baseURL: DefaultBaseURL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func delteLikeRequest(id: String) -> URLRequest {
        let token = oAuth2TokenStorage.token ?? ""
        var request = URLRequest.makeHTTPRequest(
            path: "/photos"
            + "/\(id)"
            + "/like",
            httpMethod: "DELETE",
            baseURL: DefaultBaseURL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func makeLikeRequest(id: String) -> URLRequest {
        let token = oAuth2TokenStorage.token ?? ""
        var request = URLRequest.makeHTTPRequest(
            path: "/photos"
            + "/\(id)"
            + "/like",
            httpMethod: "POST",
            baseURL: DefaultBaseURL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
