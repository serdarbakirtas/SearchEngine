//
//  UIImage.swift
//  Pods
//
//  Created by Admin on 11/24/16.
//
//

import Foundation

import CoreImage
import CoreGraphics
import Accelerate
#if !os(macOS)
    import UIKit
    public extension UIImage {

        /// Create a dummy image.
        ///
        /// - Parameter dummy: This parameter must contain: "100x100", "100x100.#FFFFFF".
        public convenience init?(dummyImage dummy: String) {
            var size: CGSize = CGSize.zero, color: UIColor = UIColor.lightGray

            let array: Array = dummy.components(separatedBy: ".")
            if !array.isEmpty {
                let sizeString: String = array[0]

                if array.count > 1 {
                    color = UIColor(hexString: array[1])
                }

                size = UIImage.size(sizeString: sizeString)
            }

            UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)

            let rect: CGRect = CGRect(origin: .zero, size: size)

            color.setFill()
            UIRectFill(rect)

            let sizeString: String = "\(Int(size.width)) x \(Int(size.height))"
            let style: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle // swiftlint:disable:this force_cast
            style.alignment = .center
            style.minimumLineHeight = size.height / 2
            let attributes: Dictionary = [NSParagraphStyleAttributeName: style]
            sizeString.draw(in: rect, withAttributes: attributes)

            if let result = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                self.init(cgImage: result.cgImage!, scale: UIScreen.main.scale, orientation: .up)
            } else {
                UIGraphicsEndImageContext()
                self.init(color: color)
            }
        }

        /// Create a dummy image.
        ///
        /// - Parameters:
        ///   - width: Width of dummy image.
        ///   - height: Height of dummy image.
        ///   - color: Color of dummy image. Can be HEX.
        public convenience init?(width: CGFloat, height: CGFloat, color: String = "#CCCCCC") {
            self.init(dummyImage: "\(Int(width))x\(Int(height)).\(color)")
        }

        /// Create a dummy image.
        ///
        /// - Parameters
        ///   - size: Size of dummy image.
        ///   - color: Color of dummy image.
        public convenience init?(size: CGSize, color: String = "#CCCCCC") {
            self.init(width: size.height, height: size.width, color: color)
        }

        /// Create an image from a given text.
        ///
        /// - Parameters:
        ///   - text: Text.
        ///   - font: Text font name.
        ///   - fontSize: Text font size.
        ///   - imageSize: Image size.
        public convenience init?(text: String, name: String, fontSize: CGFloat, imageSize: CGSize) {
            UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale)

            text.draw(at: CGPoint(x: 0.0, y: 0.0), withAttributes: [NSFontAttributeName: UIFont(name: name, size: fontSize)!])

            guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
                UIGraphicsEndImageContext()
                return nil
            }

            UIGraphicsEndImageContext()

            self.init(cgImage: image.cgImage!, scale: UIScreen.main.scale, orientation: .up)
        }

        /// Create an image with a background color and with a text with a mask.
        ///
        /// - Parameters:
        ///   - maskedText: Text to mask.
        ///   - font: Text font name.
        ///   - fontSize: Text font size.
        ///   - imageSize: Image size.
        ///   - backgroundColor: Image background color.
        public convenience init?(maskedText: String, name: String, fontSize: CGFloat, imageSize: CGSize, backgroundColor: UIColor) {
            let fontName: UIFont = UIFont(name: name, size: fontSize)!
            let textAttributes = [NSFontAttributeName: fontName]

            let textSize: CGSize = maskedText.size(attributes: textAttributes)

            UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale)
            guard let ctx: CGContext = UIGraphicsGetCurrentContext() else {
                return nil
            }

            ctx.setFillColor(backgroundColor.cgColor)

            let path: UIBezierPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
            ctx.addPath(path.cgPath)
            ctx.fillPath()

            ctx.setBlendMode(.destinationOut)
            let center: CGPoint = CGPoint(x: imageSize.width / 2 - textSize.width / 2, y: imageSize.height / 2 - textSize.height / 2)
            maskedText.draw(at: center, withAttributes: textAttributes)

            guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
                UIGraphicsEndImageContext()
                return nil
            }

            UIGraphicsEndImageContext()

            self.init(cgImage: image.cgImage!, scale: UIScreen.main.scale, orientation: .up)
        }

        /// Create an image from a given color.
        ///
        /// - Parameter color: Color value.
        public convenience init?(color: UIColor) {
            let rect: CGRect = CGRect(x: 0, y: 0, width: 1 * UIScreen.main.scale, height: 1 * UIScreen.main.scale)
            UIGraphicsBeginImageContext(rect.size)

            color.setFill()
            UIRectFill(rect)

            guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
                UIGraphicsEndImageContext()
                return nil
            }
            UIGraphicsEndImageContext()

            self.init(cgImage: image.cgImage!, scale: UIScreen.main.scale, orientation: .up)
        }

        /// Create an image from a base64 String.
        ///
        /// - Parameter base64: Base64 String.
        public convenience init?(base64: String) {
            guard let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) else {
                return nil
            }
            self.init(data: data)
        }

        /// Create a CGSize with a given string (100x100).
        ///
        /// - Parameter sizeString: String with the size.
        /// - Returns: Returns the created CGSize.
        private static func size(sizeString: String) -> CGSize {
            let array: Array = sizeString.components(separatedBy: "x")
            guard array.count >= 2 else {
                return CGSize.zero
            }

            return CGSize(width: CGFloat(array[0].floatValue), height: CGFloat(array[1].floatValue))
        }

        public func fixedOrientation(_ kMaxResolution: Float = 1024.0) -> UIImage? {
            //        let kMaxResolution :Float = 640.0
            // Or whatever
            let imgRef = self.cgImage!
            let width: Float = imgRef.width.f
            let height: Float = imgRef.height.f
            var transform = CGAffineTransform.identity
            var bounds = CGRect(x: 0.0, y: 0.0, width: width.g, height: height.g)
            if width > kMaxResolution || height > kMaxResolution {
                let ratio: Float = width / height
                if ratio > 1 {
                    bounds.size.width = kMaxResolution.g
                    bounds.size.height = roundf(bounds.size.width.f / ratio).g
                } else {
                    bounds.size.height = kMaxResolution.g
                    bounds.size.width = roundf(bounds.size.height.f * ratio).g
                }
            }

            let scaleRatio: Float = bounds.size.width.f / width
            let imageSize = CGSize(width: imgRef.width.g, height: imgRef.height.g)
            var boundHeight: CGFloat
            let orient = self.imageOrientation
            switch orient {
            case .up:
                // EXIF = 1
                transform = CGAffineTransform.identity
            case .upMirrored:
                // EXIF = 2
                transform = CGAffineTransform(translationX: imageSize.width, y: 0.0)
                transform = transform.scaledBy(x: -1.0, y: 1.0)
            case .down:
                // EXIF = 3
                transform = CGAffineTransform(translationX: imageSize.width, y: imageSize.height)
                transform = transform.rotated(by: Double.pi.g)
            case .downMirrored:
                // EXIF = 4
                transform = CGAffineTransform(translationX: 0.0, y: imageSize.height)
                transform = transform.scaledBy(x: 1.0, y: -1.0)
            case .leftMirrored:
                // EXIF = 5
                boundHeight = bounds.size.height
                bounds.size.height = bounds.size.width
                bounds.size.width = boundHeight
                transform = CGAffineTransform(translationX: imageSize.height, y: imageSize.width)
                transform = transform.scaledBy(x: -1.0, y: 1.0)
                transform = transform.rotated(by: 3.0 * Double.pi.g / 2.0)
            case .left:
                // EXIF = 6
                boundHeight = bounds.size.height
                bounds.size.height = bounds.size.width
                bounds.size.width = boundHeight
                transform = CGAffineTransform(translationX: 0.0, y: imageSize.width)
                transform = transform.rotated(by: 3.0 * Double.pi.g / 2.0)
            case .rightMirrored:
                // EXIF = 7
                boundHeight = bounds.size.height
                bounds.size.height = bounds.size.width
                bounds.size.width = boundHeight
                transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                transform = transform.rotated(by: Double.pi.g / 2.0)
            case .right:
                // EXIF = 8
                boundHeight = bounds.size.height
                bounds.size.height = bounds.size.width
                bounds.size.width = boundHeight
                transform = CGAffineTransform(translationX: imageSize.height, y: 0.0)
                transform = transform.rotated(by: Double.pi.g / 2.0)
            }

            UIGraphicsBeginImageContext(bounds.size)
            guard let context = UIGraphicsGetCurrentContext() else {
                return nil
            }

            if orient == .right || orient == .left {
                context.scaleBy(x: -scaleRatio.g, y: scaleRatio.g)
                context.translateBy(x: -height.g, y: 0)
            } else {
                context.scaleBy(x: scaleRatio.g, y: -scaleRatio.g)
                context.translateBy(x: 0, y: -height.g)
            }
            context.concatenate(transform)
            UIGraphicsGetCurrentContext()!.draw(imgRef, in: CGRect(x: 0, y: 0, width: width.g, height: height.g))
            let imageCopy = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return imageCopy
        }

        /**
         Returns the data for the image in JPEG format.

         - parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality).
         - returns: A data object containing the JPEG data, or `nil` if there was a problem generating the data. This function may return `nil` if the image has no data or if the underlying `CGImageRef` contains data in an unsupported bitmap format.
         */
        public func jpeg(quality: CGFloat) -> Data? {
            return UIImageJPEGRepresentation(self, quality)
        }

        /// Returns the data for the image in JPEG format in the best quality.
        public var jpeg: Data? {
            return jpeg(quality: 1.0)
        }

        /// Returns the data for the image in PNG format.
        public var png: Data? {
            return UIImagePNGRepresentation(self)
        }

        /**
         Creates a bitmap image using the data contained within a subregion of an existing bitmap image.

         - parameter bounds: A rectangle whose coordinates specify the area to create an image from.
         - returns: A UIImage object that specifies a subimage of the image. If the `rect` parameter defines an area that is not in the image, returns `nil`.
         */
        public func crop(to bounds: CGRect) -> UIImage? {
            guard let cgImage = cgImage, bounds.contains(bounds) else { return nil }
            return UIImage(cgImage: cgImage.cropping(to: bounds)!, scale: 0.0, orientation: imageOrientation)
        }

        /// Returns a square bitmap image cropping the sides.
        public var square: UIImage? {
            let size = CGSize(width: self.size.width * scale, height: self.size.height * scale)
            let shortest = min(size.width, size.height)
            let left: CGFloat = size.width > shortest ? (size.width - shortest) / 2.0 : 0.0
            let top: CGFloat = size.height > shortest ? (size.height - shortest) / 2.0 : 0.0
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            let insetRect = rect.insetBy(dx: left, dy: top)

            return crop(to: insetRect)
        }

        /**
         Returns a resized non-stretched copy of the image.

         - parameter size: The desired size of the image.
         - returns: A resized non-stretched UIImage object.
         */
        public func resize(to size: CGSize) -> UIImage? {
            guard let cgImage = cgImage else { return nil }

            let horizontalRatio = size.width / self.size.width
            let verticalRatio = size.height / self.size.height
            let ratio = min(horizontalRatio, verticalRatio)

            let rect = CGRect(x: 0, y: 0, width: self.size.width * ratio, height: self.size.height * ratio)
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
            guard let context = CGContext(data: nil, width: Int(rect.size.width), height: Int(rect.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else { return nil }
            let transform = CGAffineTransform.identity

            context.concatenate(transform)
            context.interpolationQuality = .medium
            context.draw(cgImage, in: rect)

            guard let coreImage = context.makeImage() else { return nil }

            return UIImage(cgImage: coreImage, scale: scale, orientation: imageOrientation)
        }

        /**
         Returns a copy of the image with a border.

         - parameter borderWidth: The desired width of the border.
         - parameter borderColor: The desired color of the border.
         - returns: A bordered UIImage object.
         */
        public func border(width borderWidth: CGFloat, color borderColor: UIColor) -> UIImage? {
            guard let cgImage = cgImage else { return nil }

            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

            let width = cgImage.width
            let height = cgImage.height
            let bits = cgImage.bitsPerComponent
            let colorSpace = cgImage.colorSpace
            let bitmapInfo = cgImage.bitmapInfo
            guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bits, bytesPerRow: 0, space: colorSpace!, bitmapInfo: bitmapInfo.rawValue) else { return nil }
            var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0

            borderColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            context.setStrokeColor(red: red, green: green, blue: blue, alpha: alpha)
            context.setLineWidth(borderWidth)

            let rect = CGRect(x: 0.0, y: 0.0, width: size.width * scale, height: size.height * scale)
            let inset = rect.insetBy(dx: borderWidth * scale / 2.0, dy: borderWidth * scale / 2.0)

            context.stroke(rect)
            context.draw(cgImage, in: inset)

            guard let coreImage = context.makeImage() else { return nil }
            UIGraphicsEndImageContext()

            return UIImage(cgImage: coreImage)
        }

        /**
         Returns a color of the given point.

         - parameter point: The point to get color with.
         - returns: A UIColor object.
         */
        public func color(atPoint point: CGPoint) -> UIColor? {
            guard let dataProvider = cgImage?.dataProvider, let data = CFDataGetBytePtr(dataProvider.data) else { return nil }

            let pixelInfo = ((Int(self.size.width) * Int(point.y)) + Int(point.x)) * 4

            let r = CGFloat(data[pixelInfo]) / 255.0
            let g = CGFloat(data[pixelInfo + 1]) / 255.0
            let b = CGFloat(data[pixelInfo + 2]) / 255.0
            let a = CGFloat(data[pixelInfo + 3]) / 255.0

            return UIColor(red: r, green: g, blue: b, alpha: a)
        }

        // Size in bytes of UIImage
        public var bytesSize: Int {
            return UIImageJPEGRepresentation(self, 1)?.count ?? 0
        }

        // Size in kilo bytes of UIImage
        public var kilobytesSize: Int {
            return bytesSize / 1024
        }

        /// SwifterSwift: UIImage with .alwaysOriginal rendering mode.
        public var original: UIImage {
            return withRenderingMode(.alwaysOriginal)
        }

        /// SwifterSwift: UIImage with .alwaysTemplate rendering mode.
        public var template: UIImage {
            return withRenderingMode(.alwaysTemplate)
        }

        // UIImage filled with color
        ///
        /// - Parameter color: color to fill image with.
        /// - Returns: UIImage filled with given color.
        public func filled(withColor color: UIColor) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
            color.setFill()
            guard let context = UIGraphicsGetCurrentContext() else {
                return self
            }
            context.translateBy(x: 0, y: self.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.setBlendMode(CGBlendMode.normal)

            let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
            guard let mask = self.cgImage else {
                return self
            }
            context.clip(to: rect, mask: mask)
            context.fill(rect)

            guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
                return self
            }
            UIGraphicsEndImageContext()
            return newImage
        }

        /// Create an image from a given rect of self.
        ///
        /// - Parameter rect:  Rect to take the image.
        /// - Returns: Returns the image from a given rect.
        public func cropped(in rect: CGRect) -> UIImage {
            let imageRef: CGImage = self.cgImage!.cropping(to: CGRect(x: rect.origin.x * self.scale, y: rect.origin.y * self.scale, width: rect.size.width * self.scale, height: rect.size.height * self.scale))!
            let subImage: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)

            return subImage
        }

        /// Apply the given Blend Mode.
        ///
        /// - Parameters:
        ///   - image: Image to be added to blend.
        ///   - blendMode: Blend Mode.
        /// - Returns: Returns the image.
        public func blended(image: UIImage, blendMode: CGBlendMode) -> UIImage {
            let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)

            UIGraphicsBeginImageContextWithOptions(self.size, true, 0)
            guard let context = UIGraphicsGetCurrentContext() else {
                return self
            }

            context.setFillColor(UIColor.white.cgColor)
            context.fill(rect)

            self.draw(in: rect, blendMode: .normal, alpha: 1)
            image.draw(in: rect, blendMode: blendMode, alpha: 1)

            guard let result = UIGraphicsGetImageFromCurrentImageContext() else {
                UIGraphicsEndImageContext()
                return self
            }
            UIGraphicsEndImageContext()

            return result
        }

        /// Rotate the image to the given radians.
        ///
        /// - Parameter radians: Radians to rotate to
        /// - Returns: Returns the rotated image.
        public func rotated(radians: Float) -> UIImage {

            return self.rotated(degrees: radians.radiansToDegrees)
        }

        /// Rotate the image to the given degrees.
        ///
        /// - Parameter degrees: Degrees to rotate to.
        /// - Returns: Returns the rotated image.
        public func rotated(degrees: Float) -> UIImage {
            let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            let transformation: CGAffineTransform = CGAffineTransform(rotationAngle: degrees.degreesToRadians.g)
            rotatedViewBox.transform = transformation
            let rotatedSize: CGSize = CGSize(width: Int(rotatedViewBox.frame.size.width), height: Int(rotatedViewBox.frame.size.height))

            UIGraphicsBeginImageContextWithOptions(rotatedSize, false, UIScreen.main.scale)
            guard let context: CGContext = UIGraphicsGetCurrentContext() else {
                UIGraphicsEndImageContext()
                return self
            }

            context.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)

            context.rotate(by: degrees.degreesToRadians.g)

            context.scaleBy(x: 1.0, y: -1.0)
            context.draw(self.cgImage!, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))

            guard let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
                UIGraphicsEndImageContext()
                return self
            }
            UIGraphicsEndImageContext()

            return newImage
        }

        /// Flip the image horizontally, like a mirror.
        ///
        /// Example: Image -> egamI.
        ///
        /// - Returns: Returns the flipped image.
        public func horizontallyFlipped() -> UIImage {
            UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
            guard let context: CGContext = UIGraphicsGetCurrentContext() else {
                UIGraphicsEndImageContext()
                return self
            }

            context.translateBy(x: 0, y: self.size.height)
            context.scaleBy(x: 1.0, y: -1.0)

            context.translateBy(x: self.size.width, y: 0)
            context.scaleBy(x: -1.0, y: 1.0)

            context.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))

            guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
                UIGraphicsEndImageContext()
                return self
            }
            UIGraphicsEndImageContext()

            return newImage
        }

        /// Flip the image vertically.
        ///
        /// Example: Image -> Iɯɐƃǝ.
        ///
        /// - Returns: Returns the flipped image.
        public func verticallyFlipped() -> UIImage {
            UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
            guard let context: CGContext = UIGraphicsGetCurrentContext() else {
                UIGraphicsEndImageContext()
                return self
            }

            context.translateBy(x: 0, y: 0)
            context.scaleBy(x: 1.0, y: 1.0)

            context.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))

            guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
                UIGraphicsEndImageContext()
                return self
            }
            UIGraphicsEndImageContext()

            return newImage
        }

        /// Check if the image has alpha.
        ///
        /// - Returns: Returns true if has alpha, otherwise false.
        public func hasAlpha() -> Bool {
            let alpha: CGImageAlphaInfo = self.cgImage!.alphaInfo
            return (alpha == .first || alpha == .last || alpha == .premultipliedFirst || alpha == .premultipliedLast)
        }

        /// Remove the alpha of the image.
        ///
        /// - Returns: Returns the image without alpha.
        public func alphaRemoved() -> UIImage {
            guard self.hasAlpha() else {
                return self
            }

            let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
            let mainViewContentContext: CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!

            mainViewContentContext.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            let mainViewContentBitmapContext: CGImage = mainViewContentContext.makeImage()!
            let newImage: UIImage = UIImage(cgImage: mainViewContentBitmapContext)

            return newImage
        }

        /// Fill the alpha with the given color.
        ///
        /// Default is white.
        ///
        /// - Parameter color: Color to fill.
        /// - Returns: Returns the filled image.
        public func alphaFilled(color: UIColor = UIColor.white) -> UIImage {
            let imageRect: CGRect = CGRect(origin: CGPoint.zero, size: self.size)

            let cgColor: CGColor = color.cgColor

            UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
            guard let context: CGContext = UIGraphicsGetCurrentContext() else {
                UIGraphicsEndImageContext()
                return self
            }
            context.setFillColor(cgColor)
            context.fill(imageRect)
            self.draw(in: imageRect)

            guard let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
                UIGraphicsEndImageContext()
                return self
            }
            UIGraphicsEndImageContext()

            return newImage
        }

        /// Check if the image is in grayscale.
        ///
        /// - Returns: Returns true if is in grayscale, otherwise false.
        public func isGrayscale() -> Bool {
            let imgReference: CGImage = self.cgImage!
            let model: CGColorSpaceModel = imgReference.colorSpace!.model

            return model == CGColorSpaceModel.monochrome
        }

        /// Transform the image to grayscale.
        ///
        /// - Returns: Returns the transformed image.
        public func grayscaled() -> UIImage {
            let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)

            let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
            let context: CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: .allZeros)!

            context.draw(self.cgImage!, in: rect)

            let grayscale: CGImage = context.makeImage()!
            let newImage: UIImage = UIImage(cgImage: grayscale)

            return newImage
        }

        /// Transform the image to black and white.
        ///
        /// - Returns: Returns the transformed image.
        public func blackened() -> UIImage {
            let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
            let context: CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: .allZeros)!

            context.interpolationQuality = .high
            context.setShouldAntialias(false)
            context.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))

            let bwImage: CGImage = context.makeImage()!
            let newImage: UIImage = UIImage(cgImage: bwImage)

            return newImage
        }

        /// Invert the color of the image.
        ///
        /// - Returns: Returns the transformed image.
        public func colorsInverted() -> UIImage {
            UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
            UIGraphicsGetCurrentContext()?.setBlendMode(.copy)
            self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            UIGraphicsGetCurrentContext()?.setBlendMode(.difference)
            UIGraphicsGetCurrentContext()?.setFillColor(UIColor.white.cgColor)
            UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))

            let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()

            return newImage
        }

        /// Scele the image to the given size.
        ///
        /// - Parameter targetSize: The site to scale to.
        /// - Returns: Returns the scaled image.
        public func scaled(toSize targetSize: CGSize) -> UIImage {
            let sourceImage: UIImage = self

            let targetWidth: CGFloat = targetSize.width
            let targetHeight: CGFloat = targetSize.height

            let scaledWidth: CGFloat = targetWidth
            let scaledHeight: CGFloat = targetHeight

            let thumbnailPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)

            UIGraphicsBeginImageContextWithOptions(targetSize, false, UIScreen.main.scale)

            var thumbnailRect: CGRect = CGRect.zero
            thumbnailRect.origin = thumbnailPoint
            thumbnailRect.size.width = scaledWidth
            thumbnailRect.size.height = scaledHeight

            sourceImage.draw(in: thumbnailRect)

            guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
                UIGraphicsEndImageContext()
                return self
            }
            UIGraphicsEndImageContext()

            return newImage
        }

        /// Apply a filter to the image.
        /// Full list of CIFilters [here](https://developer.apple.com/library/prerelease/content/documentation/GraphicsImaging/Reference/CoreImageFilterReference/).
        ///
        /// - Parameters:
        ///   - name: Filter name.
        ///   - parameters: Keys and values of the filter. A key example is kCIInputCenterKey.
        /// - Returns: Returns the transformed image.
        public func filtered(name: String, parameters: [String: Any] = [:]) -> UIImage {
            let context: CIContext = CIContext(options: nil)
            guard let filter = CIFilter(name: name), let ciImage: CIImage = CIImage(image: self) else {
                return self
            }

            filter.setValue(ciImage, forKey: kCIInputImageKey)

            for (key, value) in parameters {
                filter.setValue(value, forKey: key)
            }

            guard let outputImage = filter.outputImage, let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
                return self
            }

            let newImage: UIImage = UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: self.imageOrientation)

            return newImage.scaled(toSize: self.size)
        }

        /// Apply the bloom effect to the image.
        ///
        /// - Parameters:
        ///   - radius: Radius of the bloom.
        ///   - intensity: Intensity of the bloom.
        /// - Returns: Returns the transformed image.
        public func bloomed(radius: Float, intensity: Float) -> UIImage {
            return self.filtered(name: "CIBloom", parameters: [kCIInputRadiusKey: radius, kCIInputIntensityKey: intensity])
        }

        /// Apply the bump distortion effect to the image.
        ///
        /// - Parameters:
        ///   - center: Vector of the distortion. Use CIVector(x: X, y: Y).
        ///   - radius: Radius of the effect.
        ///   - scale: Scale of the effect.
        /// - Returns: Returns the transformed image.
        public func bumpDistortioned(center: CIVector, radius: Float, scale: Float) -> UIImage {
            return self.filtered(name: "CIBumpDistortion", parameters: [kCIInputCenterKey: center, kCIInputRadiusKey: radius, kCIInputScaleKey: scale])
        }

        /// Apply the bump distortion linear effect to the image.
        ///
        /// - Parameters:
        ///   - center: Vector of the distortion. Use CIVector(x: X, y: Y).
        ///   - radius: Radius of the effect.
        ///   - scale: Scale of the effect.
        ///   - angle: Angle of the effect in radians.
        /// - Returns: Returns the transformed image.
        public func bumpDistortionLineared(center: CIVector, radius: Float, scale: Float, angle: Float) -> UIImage {
            return self.filtered(name: "CIBumpDistortionLinear", parameters: [kCIInputCenterKey: center, kCIInputRadiusKey: radius, kCIInputScaleKey: scale, kCIInputAngleKey: angle])
        }

        /// Apply the circular splash distortion effect to the image
        ///
        /// - Parameters:
        ///   - center: Vector of the distortion. Use CIVector(x: X, y: Y).
        ///   - radius: Radius of the effect.
        /// - Returns: Returns the transformed image.
        public func circleSplashDistortioned(center: CIVector, radius: Float) -> UIImage {
            return self.filtered(name: "CICircleSplashDistortion", parameters: [kCIInputCenterKey: center, kCIInputRadiusKey: radius])
        }

        /// Apply the circular wrap effect to the image.
        ///
        /// - Parameters:
        ///   - center: Vector of the distortion. Use CIVector(x: X, y: Y).
        ///   - radius: Radius of the effect.
        ///   - angle: Angle of the effect in radians.
        /// - Returns: Returns the transformed image.
        public func circularWrapped(center: CIVector, radius: Float, angle: Float) -> UIImage {
            return self.filtered(name: "CICircularWrap", parameters: [kCIInputCenterKey: center, kCIInputRadiusKey: radius, kCIInputAngleKey: angle])
        }

        /// Apply the CMY halftone effect to the image.
        ///
        /// - Parameters:
        ///   - center: Vector of the distortion. Use CIVector(x: X, y: Y).
        ///   - width: Width value.
        ///   - angle: Angle of the effect in radians.
        ///   - sharpness: Sharpness Value.
        ///   - gcr: GCR value.
        ///   - ucr: UCR value
        /// - Returns: Returns the transformed image.
        public func cmykHalftoned(center: CIVector, width: Float, angle: Float, sharpness: Float, gcr: Float, ucr: Float) -> UIImage {
            return self.filtered(name: "CICMYKHalftone", parameters: [kCIInputCenterKey: center, kCIInputWidthKey: width, kCIInputSharpnessKey: sharpness, kCIInputAngleKey: angle, "inputGCR": gcr, "inputUCR": ucr])
        }

        /// Apply the sepia filter to the image.
        ///
        /// - Parameter intensity: Intensity of the filter.
        /// - Returns: Returns the transformed image.
        public func sepiaToned(intensity: Float) -> UIImage {
            return self.filtered(name: "CISepiaTone", parameters: [kCIInputIntensityKey: intensity])
        }

        /// Apply the blur effect to the image.
        ///
        /// - Parameters:
        ///   - blurRadius: Blur radius.
        ///   - saturation: Saturation delta factor, leave it default (1.8) if you don't what is.
        ///   - tintColor: Blur tint color, default is nil.
        ///   - maskImage: Apply a mask image, leave it default (nil) if you don't want to mask.
        /// - Returns: Return the transformed image.
        public func blured(radius blurRadius: CGFloat, saturation: CGFloat = 1.8, tintColor: UIColor? = nil, maskImage: UIImage? = nil) -> UIImage {
            guard size.width > 1 && size.height > 1, let selfCGImage = cgImage else {
                return self
            }

            let imageRect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
            var effectImage = self

            let hasBlur = Float(blurRadius) > Float.ulpOfOne
            let hasSaturationChange = Float(abs(saturation - 1)) > Float.ulpOfOne

            if hasBlur || hasSaturationChange {
                UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
                guard let effectInContext = UIGraphicsGetCurrentContext() else {
                    UIGraphicsEndImageContext()
                    return self
                }
                effectInContext.scaleBy(x: 1, y: -1)
                effectInContext.translateBy(x: 0, y: -size.height)
                effectInContext.draw(selfCGImage, in: imageRect)
                var effectInBuffer = vImage_Buffer(data: effectInContext.data, height: UInt(effectInContext.height), width: UInt(effectInContext.width), rowBytes: effectInContext.bytesPerRow)

                UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
                guard let effectOutContext = UIGraphicsGetCurrentContext() else {
                    UIGraphicsEndImageContext()
                    return self
                }
                var effectOutBuffer = vImage_Buffer(data: effectOutContext.data, height: UInt(effectOutContext.height), width: UInt(effectOutContext.width), rowBytes: effectOutContext.bytesPerRow)

                if hasBlur {
                    let inputRadius = blurRadius * UIScreen.main.scale
                    var radius = UInt32(floor(inputRadius * 3.0 * CGFloat(sqrt(2 * Double.pi)) / 4 + 0.5))
                    if radius % 2 != 1 {
                        radius += 1
                    }

                    let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
                    vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                    vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                    vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                }

                if hasSaturationChange {
                    let s = saturation
                    let floatingPointSaturationMatrix = [
                        0.0722 + 0.9278 * s, 0.0722 - 0.0722 * s, 0.0722 - 0.0722 * s, 0,
                        0.7152 - 0.7152 * s, 0.7152 + 0.2848 * s, 0.7152 - 0.7152 * s, 0,
                        0.2126 - 0.2126 * s, 0.2126 - 0.2126 * s, 0.2126 + 0.7873 * s, 0,
                        0, 0, 0, 1
                    ]

                    let divisor: CGFloat = 256
                    let saturationMatrix = floatingPointSaturationMatrix.map {
                        return Int16(round($0 * divisor))
                    }

                    if hasBlur {
                        vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                    } else {
                        vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                    }
                }

                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
            }

            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            guard let outputContext = UIGraphicsGetCurrentContext() else {
                UIGraphicsEndImageContext()
                return self
            }
            outputContext.scaleBy(x: 1, y: -1)
            outputContext.translateBy(x: 0, y: -size.height)

            outputContext.draw(selfCGImage, in: imageRect)

            if hasBlur {
                outputContext.saveGState()
                if let maskImage = maskImage {
                    outputContext.clip(to: imageRect, mask: maskImage.cgImage!)
                }
                outputContext.draw(effectImage.cgImage!, in: imageRect)
                outputContext.restoreGState()
            }

            if let tintColor = tintColor {
                outputContext.saveGState()
                outputContext.setFillColor(tintColor.cgColor)
                outputContext.fill(imageRect)
                outputContext.restoreGState()
            }

            guard let outputImage = UIGraphicsGetImageFromCurrentImageContext() else {
                UIGraphicsEndImageContext()
                return self
            }
            UIGraphicsEndImageContext()

            return outputImage
        }

        /**
         Returns a copy of self, tinted by the given color.

         - parameter tintColor: The UIColor to tint by.
         - returns: A copy of self, tinted by the tintColor.
         */
        public func tinted(_ tintColor: UIColor) -> UIImage {
            guard let cgImage = cgImage else { return self }

            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)

            defer { UIGraphicsEndImageContext() }

            let context = UIGraphicsGetCurrentContext()
            context?.saveGState()

            tintColor.setFill()

            context?.translateBy(x: 0, y: size.height)
            context?.scaleBy(x: 1, y: -1)
            context?.setBlendMode(.normal)

            let rect = CGRect(origin: .zero, size: size)
            context?.draw(cgImage, in: rect)

            context?.clip(to: rect, mask: cgImage)
            context?.addRect(rect)
            context?.drawPath(using: .fill)
            context?.restoreGState()

            return UIGraphicsGetImageFromCurrentImageContext() ?? self
        }

    }
#endif
