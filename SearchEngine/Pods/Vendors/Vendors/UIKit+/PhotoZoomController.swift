//
//  PhotoZoomController.swift
//  fotobaski
//
//  Created by ALI KIRAN on 27/09/2016.
//  Copyright © 2016 ALI KIRAN. All rights reserved.
//

import Foundation

import QuartzCore

open class PhotoZoomController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var btnClose: UIButton!

    open var placeHolderImage: UIImage?

    open var photo: String? {
        didSet {
            if self.isViewLoaded {
                self.updateUI()
            }
        }
    }

    open override func viewDidLoad() {
        self.updateUI()
        self.scroll.delegate = self

        self.btnClose.shadowOpacity = 0.5
        self.btnClose.shadowColor = UIColor.darkGray
        self.btnClose.shadowRadius = 1.4
        self.btnClose.shadowOffset = CGSize(width: 3.0, height: 3.0)

    }

    func updateUI() {
        //        guard let photo = self.photo else {
        //            return
        //        }

        //        let imagePackageURL = URL(string: photo)!

        //        self.image.kf.setImage(with: imagePackageURL, placeholder: placeHolderImage, options: nil, progressBlock: nil, completionHandler: { [weak self](image, error, cacheType, imageURL) in
        //            guard let `self` = self else {
        //                return
        //            }
        //
        //            guard let image = image else {
        //                self.image.image = self.placeHolderImage
        //                return
        //            }
        //
        //            self.image.image = image
        //            self.renderScroll()
        //
        //            })

    }

    func renderScroll() {
        self.scroll.contentSize = self.image.size

        self.scroll.maximumZoomScale = 1

        var widthScale: CGFloat = 1.0
        var heightScale: CGFloat = 1.0

        widthScale = (self.view.width - 40) / image.image!.size.width.g
        heightScale = (self.view.height - 40) / image.image!.size.height.g

        self.scroll.minimumZoomScale = min(widthScale, heightScale)
        self.scroll.zoomScale = self.scroll.minimumZoomScale

        self.view.layoutAndWait({ [unowned self] () in
            self.scrollViewDidZoom(self.scroll)
            self.scroll.setZoomScale(self.scroll.minimumZoomScale, animated: true)
        })

        self.setupGestureRecognizer()
    }

    open func viewForZooming(in _: UIScrollView) -> UIView? {
        return image
    }

    open func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = image.frame.size
        let scrollViewSize = scrollView.bounds.size

        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0

        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }

    //
    func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(PhotoZoomController.handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        scroll.addGestureRecognizer(doubleTap)
    }

    func handleDoubleTap(_: UITapGestureRecognizer) {

        if scroll.zoomScale > scroll.minimumZoomScale {
            scroll.setZoomScale(scroll.minimumZoomScale, animated: true)
        } else {
            scroll.setZoomScale(scroll.maximumZoomScale, animated: true)
        }
    }
}
