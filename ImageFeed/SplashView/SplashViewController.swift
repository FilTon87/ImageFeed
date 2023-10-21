//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 17.10.2023.
//

import Foundation
import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Private Properties
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    // MARK: - View Life Cycles
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = OAuth2TokenStorage().token {
            switchToTabBarController()
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
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        OAuth2Service.shared.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.switchToTabBarController()
            case .failure:
                print ("Error: in SplashViewController")
                break
            }
        }
    }
}
