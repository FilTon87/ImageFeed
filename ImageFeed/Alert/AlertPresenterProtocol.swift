//
//  AlertPresenterProtocol.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 22.11.2023.
//

import Foundation

protocol AlertPresenterProtocol: AnyObject {
    func showAlert(alertModel: AlertModel)
}
