//
//  URLSession.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 05.11.2023.
//

import Foundation

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
            let fulfillCompletion: (Result<T, Error>) -> Void = { result in
                DispatchQueue.main.async {
                    completion(result)
                    print("->RESULT: \(result)")
                }
            }
            let task = dataTask(with: request, completionHandler: {data, response, error in
                if let data = data,
                   let response = response,
                   let statusCode = (response as? HTTPURLResponse)?.statusCode
                {
                    if 200 ..< 300 ~= statusCode {
                        fulfillCompletion(.success(data as! T))
                        print("->STATUS_CODE: \(statusCode)")
                    } else {
                        fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                        print("->STATUS_CODE: \(statusCode)")
                    }
                } else if let error = error {
                    fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
                } else {
                    fulfillCompletion(.failure(NetworkError.urlSessionError))
                }
            })

            task.resume()
            return task
        }
}

