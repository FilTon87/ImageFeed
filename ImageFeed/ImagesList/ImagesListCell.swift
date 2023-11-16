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
    weak var delegate: ImagesListCellDelegate?
    static let reuseIdentifier = "ImagesListCell"
    

    @IBAction private func likeButtonCliked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(isLiked: Bool) {
        if isLiked == true {likeButton.setImage(UIImage(named: "LikeActive"), for: .normal)} else {likeButton.setImage(UIImage(named: "LikeNoActive"), for: .normal)}
    }
}

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
