//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 11.10.2023.
//

import Foundation

final class OAuth2TokenStorage {
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: "authToken")
        }
        set {
            let defaults = UserDefaults.standard
            if let token = newValue {
                defaults.setValue(token, forKey: "authToken")
            }
        }
    }
}
