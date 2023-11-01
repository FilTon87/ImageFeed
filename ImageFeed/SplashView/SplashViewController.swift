//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 17.10.2023.
//

import Foundation
import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    // MARK: - Private Properties
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    // MARK: - View Life Cycles
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if OAuth2TokenStorage().token != nil {
            switchToTabBarController()
            fetchProfile(token: OAuth2TokenStorage().token!)
        } else {
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    // MARK: - Public Methods
    func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration")}
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(identifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                fatalError("Faild to prepare for \(ShowAuthenticationScreenSegueIdentifier)")
            }
            
            viewController.delegate = self }
        else {
            super.prepare(for: segue, sender: sender)
        }
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
                UIBlockingProgressHUD.dismiss()
            case .failure:
                print ("Error: in SplashViewController")
                UIBlockingProgressHUD.dismiss()
                break
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                print("\(token)")
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
                guard let userName = profileService.profile?.userName else {return}
                profileImageService.fetchProfileImageURL(userName: userName) { [weak self] result in
                    guard let self = self else {return}
                    switch result {
                    case .success(let avatarURL):
                        print ("\(avatarURL)")
                    case .failure:
                        print ("Error: in fetchProfileImageURL")
                    }
                }
            case .failure:
                print ("Error: in fetchProfile")
                break
            }
        }
    }
}
