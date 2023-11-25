//
//  ViewController.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 02.09.2023.
//

import UIKit
import Kingfisher

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
}

final class ImagesListViewController: UIViewController {
    //MARK: - Public Properties
    var photos: [Photo] = []
    
    //MARK: - IB Outlets
    @IBOutlet private var tableView: UITableView!
    
    //MARK: - Private Properties
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    //MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(delegate: self)
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else {return}
                self.updateTableViewAnimated()
            }
        imagesListService.fetchPhotosNextPage()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            guard let fullImageURL = URL(string: photos[indexPath.row].largeImageURL) else
            {
                assertionFailure("No fullImageURL")
                return
            }
            viewController.fullImageURL = fullImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    //MARK: - Private Methods
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photos = imagesListService.photos
        let placeholder = UIImage(named: "Stub")
        guard let url = URL(string: photos[indexPath.row].thumbImageURL)
        else {
            assertionFailure("No photo URL")
            return
        }
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: url, placeholder: placeholder)
        { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            cell.cellImage.kf.indicatorType = .none
        }
        
        guard let date = photos[indexPath.row].createdAt else {
            assertionFailure("No photo date")
            return
        }
        cell.dateLabel.text = dateFormatter.string(from: date)
        
        
        if photos[indexPath.row].isLiked == true {cell.likeButton.setImage(UIImage(named: "LikeActive"), for: .normal)} else {cell.likeButton.setImage(UIImage(named: "LikeNoActive"), for: .normal)}
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPath = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPath, with: .automatic)
            } completion: { _ in }
        }
    }
}

//extension ImagesListViewController: ImagesListViewControllerProtocol {
//    var presenter: ImagesListPresenterProtocol?
//
//}

//MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else { return UITableViewCell() }
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

//MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

//MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(id: photo.id, isLiked: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.photos = self.imagesListService.photos
                cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
            case .failure(_):
                self.showAlert()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func showAlert() {
        let alert = AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось поставить лайк",
            buttonOneText: "Ok",
            completionOne: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)},
        buttonTwoText: nil)
        self.alertPresenter?.showAlert(alertModel: alert)
    }
}



