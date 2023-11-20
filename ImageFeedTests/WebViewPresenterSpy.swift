//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Anton Filipchuk on 20.11.2023.
//

import Foundation
import ImageFeed

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var view: ImageFeed.WebViewViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
    
    
}
