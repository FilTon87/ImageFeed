//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Anton Filipchuk on 23.11.2023.
//

import Foundation
import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfileViewPresenterProtocol?
    var updateAvatarCalled: Bool = false
    
    func updateAvatar() {
        updateAvatarCalled = true
    }
    
    
}


