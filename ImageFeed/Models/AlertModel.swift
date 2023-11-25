//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 21.11.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonOneText: String
    var completionOne: () -> Void
    let buttonTwoText: String?
    var completionTwo: () -> Void = {}
}
