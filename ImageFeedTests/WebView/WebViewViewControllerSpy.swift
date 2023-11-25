//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Anton Filipchuk on 20.11.2023.
//

import Foundation
import ImageFeed

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    var loadRequestCallsed: Bool = false
    
    func load(request: URLRequest) {
        loadRequestCallsed = true
    }
    
    func setProgressValue(_ newValue: Float) { }
    
    func setProgressHidden(_ isHidden: Bool) { }
    
    
}
