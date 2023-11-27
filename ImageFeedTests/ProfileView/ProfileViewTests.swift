//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Anton Filipchuk on 23.11.2023.
//

@testable import ImageFeed
import XCTest
import SwiftKeychainWrapper

final class ProfileViewTests: XCTestCase {
    
    func testProfileViewControllerUpdateAvatar() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.profileObserver()
        
        //then
        XCTAssertTrue(viewController.updateAvatarCalled)
    }
    
    func testControllerAskAvatarURLfromPresenter() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        viewController.updateAvatar()
        
        //then
        XCTAssertTrue(presenter.reciveAvatarURLCalled)
        
    }
    
    func testProfileExitRemoveToken() {
        //given
        let presenter = ProfileViewPresenter()
        let keyInStorage = KeychainWrapper.standard.string(forKey: "authToken")
        
        //when
        presenter.exitProfile()
        sleep(5)

        //then
        XCTAssertEqual(keyInStorage, nil)
    }
    
}
