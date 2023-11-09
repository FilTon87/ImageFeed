//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 11.10.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    private let authToken = "authToken"
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: authToken)
        }
        set {
            guard let newValue = newValue else {
                KeychainWrapper.standard.remove(forKey: "authToken")
                return
            }
            KeychainWrapper.standard.set(newValue, forKey: authToken)
        }
    }
}
