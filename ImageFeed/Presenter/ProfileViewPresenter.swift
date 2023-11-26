//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 21.11.2023.
//

import Foundation

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func profileObserver()
    func exitProfile()
    func reciveAvatarURL() -> URL?

}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let profileImageService = ProfileImageService.shared
    private let switcher = Switcher.shared
    
    func profileObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) {[weak self] _ in
                guard let self = self else {return}
                view?.updateAvatar()
            }
        view?.updateAvatar()
    }
    
    func reciveAvatarURL() -> URL? {
            let profileImageURL = profileImageService.avatarURL ?? ""
            let url = URL(string: profileImageURL)
        return url
    }
    
    func exitProfile() {
        oAuth2TokenStorage.removeToken()
        switcher.switchToSplashScreen()
    }
}
