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

final class ProfileViewController: UIViewController {
    var presenter: ProfileViewPresenterProtocol?
    
    //MARK: - Private Properties
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let loginNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let logoutButton = UIButton()
    private let profileService = ProfileService.shared
//    private var alertPresenter: AlertPresenter?
    
    //MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileView()
        
 //       alertPresenter = AlertPresenter()
        
        updateProfileDetils(profile: profileService.profile)
        
        avatarObserver()
    }
    
    func updateAvatar() {
        guard let avatar = presenter?.reciveAvatarURL() else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 12)
        avatarImageView.kf.setImage(with: avatar, options: [.processor(processor), .cacheSerializer(FormatIndicatedCacheSerializer.png)])
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
    }
}

extension ProfileViewController: ProfileViewControllerProtocol {
    func avatarObserver() {
        presenter = ProfileViewPresenter()
        presenter?.view = self
        presenter?.profileObserver()
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
        avatarImageView.layer.cornerRadius = 35
        
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
        nameLabel.text = profile.name
        loginNameLabel.text = "@\(profile.userName)"
        descriptionLabel.text = profile.bio
    }
    
    @objc func logoutAlert() {
        DispatchQueue.main.async {
            let alert = AlertModel(
                title: "Пока, пока!",
                message: "Уверены, что хотите выйти?",
                buttonOneText: "Да",
                completionOne: { [weak self] in
                    guard let self = self else { return }
                    presenter?.exitProfile()},
                buttonTwoText: "Нет",
                completionTwo: { [weak self] in
                    guard let self = self else { return }
                    self.dismiss(animated: true)
                })
            AlertPresenter.showAlert(viewController: self, alertModel: alert)
        }
    }
}
