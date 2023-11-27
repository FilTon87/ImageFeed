//
//  Constants.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 27.09.2023.
//

import UIKit

let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
let AccessKey = "L2pMiPXZ7WCG-dIl8Ml_g5uFXUaAsie66Olnq3209DU"
let SecretKey = "iEwX56zhKcWmezAkhZD4Cf2eEt4X4dXvwB0uh3JhEhg"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
let DefaultBaseURL = URL(string: "https://api.unsplash.com/")!

struct AuthConfiguration {
    let acessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(acessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, authURLString: String) {
        self.acessKey = acessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            acessKey: AccessKey,
            secretKey: SecretKey,
            redirectURI: RedirectURI,
            accessScope: AccessScope,
            defaultBaseURL: DefaultBaseURL,
            authURLString: UnsplashAuthorizeURLString)
    }
}
