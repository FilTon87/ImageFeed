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
    static let reuseIdentifier = "ImagesListCell"
    
}
