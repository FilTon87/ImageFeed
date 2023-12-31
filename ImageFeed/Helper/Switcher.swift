//
//  Switcher.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 25.11.2023.
//

import UIKit

final class Switcher {
    static let shared = Switcher()
    private init() {}
    
    func switchToSplashScreen() {
        guard let window = UIApplication.shared.windows.first
        else {assertionFailure("Invalid Configuration")
        return }
        let splashScreenViewController = SplashViewController()
        window.rootViewController = splashScreenViewController
    }
    
    
}
