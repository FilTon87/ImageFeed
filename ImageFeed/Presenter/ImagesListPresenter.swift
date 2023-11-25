//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 25.11.2023.
//

import Foundation

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
}

