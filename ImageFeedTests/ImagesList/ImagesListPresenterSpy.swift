//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Anton Filipchuk on 25.11.2023.
//

import Foundation
import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImageFeed.ImagesListViewControllerProtocol?
    var loadImagesCalled = false
    
    func loadImages() {
        loadImagesCalled = true
    }
    
    func tapLike(id: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        
    }

}
