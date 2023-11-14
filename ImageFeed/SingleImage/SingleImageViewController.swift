//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Anton Filipchuk on 13.09.2023.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    //MARK: - IB Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    //MARK: - Public Properties
    var fullImageURL: URL! {
            didSet {
                guard isViewLoaded else { return }
            }
        }
    
    //MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        loadImage()
    }
    
    //MARK: - IB Action
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        let shareController = UIActivityViewController(activityItems: [imageView.image as Any], applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
    }
}

extension SingleImageViewController {
    
    //MARK: - Private Methods
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func loadImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: fullImageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showError()
            }
        }
    }
    
    private func showError() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Что-то пошло не так. Попробовать еще раз?",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "Повторить",
            style: .default) { [weak self] _ in
                self?.loadImage()
            })
        alert.addAction(UIAlertAction(
            title: "Не надо",
            style: .default) { [weak self] _ in
                                self?.didTapBackButton()})
        self.present(alert, animated: true)
    }
}

//MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
