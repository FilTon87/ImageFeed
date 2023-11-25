//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Anton Filipchuk on 25.11.2023.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    
    func testImagesListLoadPhotos() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        viewController.loadImages()
        
        //then
        XCTAssertTrue(presenter.loadImagesCalled)
    }
    
}
