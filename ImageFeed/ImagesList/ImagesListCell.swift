//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 02.09.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gradienView: UIView!
    
    private var gradient: CAGradientLayer!
    
    static let reuseIdentifier = "ImagesListCell"
    
//заготовка для градиента ячейки
//   func createGradient() {
//    gradient = CAGradientLayer()
//        let startColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0).cgColor
//        let endColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0.8).cgColor
//    gradient.colors = [startColor, endColor]
//    gradient.frame = self.gradienView.bounds
//        self.gradienView.layer.addSublayer(gradient)
//    }
    
}
