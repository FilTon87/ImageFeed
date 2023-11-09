//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 17.10.2023.
//
import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Private Properties
    private let logoImageView = UIImageView()
//    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private var wasChecked: Bool = false
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        makeSplashScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuthStatus()
    }
    
    // MARK: - Private Methods
    private func checkAuthStatus() {
        guard !wasChecked else { return }
        wasChecked = true
        if let token = oAuth2TokenStorage.token {
            fetchProfile(token: token)
        } else {
            switchToAuthViewController()
        }
    }
    
    private func makeSplashScreen() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.ypBlack
        view.addSubview(logoImageView)
        logoImageView.image = UIImage(named: "splash_screen_logo")
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func switchToAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let authViewContoller = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController {
            authViewContoller.delegate = self
            authViewContoller.modalPresentationStyle = .fullScreen
            present(authViewContoller, animated: true)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration")}
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(identifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        OAuth2Service.shared.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure:
                self.showAlert(message: "Не удалось войти в систему")
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success:
                guard let userName = self.profileService.profile?.userName else {return}
                self.profileImageService.fetchProfileImageURL(userName: userName) { result in
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            self.switchToTabBarController()
                        }
                    case .failure:
                        self.showAlert(message: "Не удалось получить аватар пользователя")
                    }
                }
            case .failure:
                self.showAlert(message: "Не удалось загрузить профиль пользователя")
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "Ok",
            style: .default) { [weak self] _ in
                self?.switchToAuthViewController()
            })
        self.present(alert, animated: true)
    }
}
