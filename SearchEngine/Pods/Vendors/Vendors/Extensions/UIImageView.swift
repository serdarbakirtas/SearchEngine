//
//  UIImageView.swift
//  Pods
//
//  Created by Admin on 11/24/16.
//
//

#if os(iOS) || os(tvOS)
    import UIKit

    public extension UIImageView {

        public func cropAsCircleWithBorder(borderColor: UIColor, strokeWidth: Int) {
            let strokeWidthFloat = CGFloat(strokeWidth)

            var radius = min(self.bounds.width, self.bounds.height)
            var drawingRect: CGRect = self.bounds
            drawingRect.size.width = radius
            drawingRect.origin.x = (self.bounds.size.width - radius) / 2
            drawingRect.size.height = radius
            drawingRect.origin.y = (self.bounds.size.height - radius) / 2

            radius /= 2

            var path = UIBezierPath(roundedRect: drawingRect.insetBy(dx: strokeWidthFloat / 2, dy: strokeWidthFloat / 2), cornerRadius: radius)
            let border = CAShapeLayer()
            border.fillColor = UIColor.clear.cgColor
            border.path = path.cgPath
            border.strokeColor = borderColor.cgColor
            border.lineWidth = strokeWidthFloat
            layer.addSublayer(border)

            path = UIBezierPath(roundedRect: drawingRect, cornerRadius: radius)
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }

        // MARK: - Functions

        /// Create an UIImageView with the given image and frame
        ///
        /// - Parameters:
        ///   - frame: UIImageView frame.
        ///   - image: UIImageView image.
        /// - Returns: Returns the created UIImageView.
        public convenience init(frame: CGRect, image: UIImage) {
            self.init(frame: frame)
            self.image = image
        }

        // Make image view blurry
        ///
        /// - Parameter withStyle: UIBlurEffectStyle (default is .light).
        public func blur(withStyle: UIBlurEffectStyle = .light) {
            let blurEffect = UIBlurEffect(style: withStyle)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
            self.addSubview(blurEffectView)
            self.clipsToBounds = true
        }

        /// Create an UIImageView with the given image, size and center.
        ///
        /// - Parameters:
        ///   - image: UIImageView image.
        ///   - size: UIImageView size.
        ///   - center: UIImageView center.
        /// - Returns: Returns the created UIImageView.
        public convenience init(image: UIImage, size: CGSize, center: CGPoint) {
            self.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            self.image = image
            self.center = center
        }

        /// Create an UIImageView with the given image and center.
        ///
        /// - Parameters:
        ///   - image: UIImageView image.
        ///   - center: UIImageView center.
        /// - Returns: Returns the created UIImageView.
        public convenience init(image: UIImage, center: CGPoint) {
            self.init(image: image)
            self.center = center
        }

        /// Create an UIImageView with the given image and center.
        ///
        /// - Parameters:
        ///   - imageTemplate: UIImage template.
        ///   - tintColor: Template color.
        /// - Returns: Returns the created UIImageView.
        public convenience init(imageTemplate: UIImage, tintColor: UIColor) {
            var _imageTemplate = imageTemplate
            self.init(image: _imageTemplate)
            _imageTemplate = _imageTemplate.withRenderingMode(.alwaysTemplate)
            self.tintColor = tintColor
        }

        /// Mask the current UIImageView with an UIImage.
        ///
        /// - Parameter image: The mask UIImage.
        public func mask(image: UIImage) {
            let mask: CALayer = CALayer()
            mask.contents = image.cgImage
            mask.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            self.layer.mask = mask
            self.layer.masksToBounds = false
        }

        public func blurImage() {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.bounds

            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
            self.addSubview(blurEffectView)
        }

        public func blurImageLightly() {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.bounds

            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
            self.addSubview(blurEffectView)
        }

        public func blurImageExtraLightly() {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.bounds

            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
            self.addSubview(blurEffectView)
        }

    }
#endif
