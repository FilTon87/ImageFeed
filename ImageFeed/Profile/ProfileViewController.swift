//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 12.09.2023.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func updateAvatar()
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    
    //MARK: - Private Properties
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let loginNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let logoutButton = UIButton()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private var alertPresenter: AlertPresenterProtocol?
    
    //MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileView()
        
        alertPresenter = AlertPresenter(delegate: self)
        
        updateProfileDetils(profile: profileService.profile)
        
        presenter = ProfileViewPresenter()
        presenter?.view = self
        presenter?.profileObserver()
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 12)
        avatarImageView.kf.setImage(with: url, options: [.processor(processor), .cacheSerializer(FormatIndicatedCacheSerializer.png)])
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
    }
}

private extension ProfileViewController {
    
    //MARK: - Private Methods
    private func setupProfileView() {
        view.backgroundColor = .ypBlack
        makeAvatar()
        makeUserName()
        makeLoginName()
        makeDescription()
        makeLogoutButton()
    }
    
    private func makeAvatar() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        avatarImageView.image = UIImage(named: "userPhoto")
        
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])
    }
    
    private func makeUserName() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor.ypWhite
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func makeLoginName() {
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = UIColor.ypGray
        loginNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        
        NSLayoutConstraint.activate([
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func makeDescription() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = UIColor.ypWhite
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func makeLogoutButton() {
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.accessibilityIdentifier = "Exit"
        logoutButton.setImage(UIImage(named: "Exit"), for: .normal)
        logoutButton.tintColor = .red
        logoutButton.addTarget(self, action: #selector(logoutAlert), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func updateProfileDetils (profile: Profile?) {
        guard let profile = profileService.profile else {
            assertionFailure("no profile")
            return }
        nameLabel.text = profileService.profile?.name
        loginNameLabel.text = profileService.profile?.userName
        descriptionLabel.text = profileService.profile?.bio
    }
    
    @objc func logoutAlert() {
        DispatchQueue.main.async {
            let alert = AlertModel(
                title: "Пока, пока!",
                message: "Уверены, что хотите выйти?",
                buttonOneText: "Да",
                completionOne: { [weak self] in
                    guard let self = self else { return }
                    self.exit()},
                buttonTwoText: "Нет",
                completionTwo: { [weak self] in
                    guard let self = self else { return }
                    self.dismiss(animated: true)
                })
            self.alertPresenter?.showAlert(alertModel: alert)
        }
    }
    
    private func exit() {
        oAuth2TokenStorage.removeToken()
        switchToSplashScreen()
    }
    
    private func switchToSplashScreen() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration")}
        let splashScreenViewController = SplashViewController()
        window.rootViewController = splashScreenViewController
    }
}
