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

}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    
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
}
