//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 25.11.2023.
//

import Foundation

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func loadImages()
    func tapLike(id: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
    
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    private let imagesListService = ImagesListService.shared

    var view: ImagesListViewControllerProtocol?
    private var imagesListServiceObserver: NSObjectProtocol?
    
    func loadImages() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else {return}
                view?.updateTableViewAnimated()
            }
        imagesListService.fetchPhotosNextPage()
    }
    
    func tapLike(id: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        imagesListService.changeLike(id: id, isLiked: isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}

