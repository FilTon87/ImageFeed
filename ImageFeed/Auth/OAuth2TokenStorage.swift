//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 11.10.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    var token: String? {
        get {
//            return UserDefaults.standard.string(forKey: "authToken")
            let token: String? = KeychainWrapper.standard.string(forKey: "authToken")
            return token
        }
        set {
            guard let token = token else { return }
            let isSuccess = KeychainWrapper.standard.set(token, forKey: "authToken")
            guard isSuccess else { return
                //ошибка
            }
//            let defaults = UserDefaults.standard
//            if let token = newValue {
//                defaults.setValue(token, forKey: "authToken")
            }
        }
    }
