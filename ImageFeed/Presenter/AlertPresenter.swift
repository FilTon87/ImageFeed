//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 21.11.2023.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    private weak var delegate: UIViewController?
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    
    func showAlert(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
            title: alertModel.buttonOneText,
            style: .default) {  _ in
                alertModel.completionOne()
            })
        
        if let buttonTwoText = alertModel.buttonTwoText {
            alert.addAction(UIAlertAction(
                title: buttonTwoText,
                style: .default) { _ in
                    alertModel.completionTwo()
                })
        }
        delegate?.present(alert, animated: true)
    }
}
