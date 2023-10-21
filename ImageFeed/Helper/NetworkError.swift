//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 21.10.2023.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}
