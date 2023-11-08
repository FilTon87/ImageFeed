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
            KeychainWrapper.standard.string(forKey: "authToken")
        }
        set {
            guard let newValue = newValue else { return }
            let isSuccess = KeychainWrapper.standard.set(newValue, forKey: "authToken")
            guard isSuccess else { return }
        }
    }
}
