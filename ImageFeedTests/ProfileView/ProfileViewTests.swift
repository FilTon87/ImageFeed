//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Anton Filipchuk on 23.11.2023.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    
//    func testProfileViewControllerUpdateAvatar() {
//        //given
//        
//        
//        //when
//        
//        //then
//    }
    
    func testShowingProfileLogoutAlert() {
        //given
        let view = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        view.presenter = presenter
        presenter.view = view
        
        //when
        
        //then
    }
    
}
