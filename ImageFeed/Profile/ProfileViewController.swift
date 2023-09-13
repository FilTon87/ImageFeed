//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 12.09.2023.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
    }
}
