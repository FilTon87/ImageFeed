//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Anton Filipchuk on 23.11.2023.
//

import Foundation
import ImageFeed

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var reciveAvatarURLCalled: Bool = false
    
    func profileObserver() { }
    func exitProfile() { }
    func reciveAvatarURL() -> URL? {
        reciveAvatarURLCalled = true
        return nil        
    }
    
    
}
