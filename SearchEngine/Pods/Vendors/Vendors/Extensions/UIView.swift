//
//  UIView.swift
//  Pods
//
//  Ali Kiran on 11/24/16.
//
//

#if os(iOS) || os(tvOS)
    import UIKit

    public extension UIView {

        @IBInspectable
        var rotation: Int {
            get {
                return 0
            } set {
                let radians = CGFloat(CGFloat(Double.pi) * CGFloat(newValue) / CGFloat(180.0))
                self.transform = CGAffineTransform(rotationAngle: radians)
            }
        }

        public func centerInRect(rect: CGRect) {
            self.center = CGPoint(x: rect.midX, y: rect.midY)
        }

        public func centerInSuperView() {
            self.centerInRect(rect: self.superview!.bounds)
        }

        // vertical positioning
        public func centerVerticallyInRect(rect: CGRect) {
            self.center = CGPoint(x: self.center.x, y: rect.midY)
        }

        public func centerVerticallyInSuperView() {
            self.centerVerticallyInRect(rect: self.superview!.bounds)
        }

        public func centerVerticallyToTheRightOf(view: UIView, padding: CGFloat = 0) {
            self.center = CGPoint(x: padding + view.frame.maxX + (self.frame.width / 2), y: view.center.y)
        }

        public func centerVerticallyToTheLeftOf(view: UIView, padding: CGFloat = 0) {
            self.center = CGPoint(x: view.frame.minX - (self.frame.width / 2) - padding, y: view.center.y)
        }

        // horizontal positioning
        public func centerHorizontallyInRect(rect: CGRect) {
            self.center = CGPoint(x: rect.midX, y: self.center.y)
        }

        public func centerHorizontallyInSuperView() {
            self.centerHorizontallyInRect(rect: self.superview!.bounds)
        }

        public func centerHorizontallyAbove(view: UIView, padding: CGFloat = 0) {
            self.center = CGPoint(x: view.center.x, y: view.frame.minY - (self.frame.height / 2) - padding)
        }

        public func centerHorizontallyBelow(view: UIView, padding: CGFloat = 0) {
            self.center = CGPoint(x: view.center.x, y: padding + view.frame.maxY + (self.frame.height / 2))
        }

        public func disableForWhile(duration: Double = 0.5) {
            self.isUserInteractionEnabled = false
            let dispatchTime: DispatchTime = DispatchTime.now() + duration
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                self.isUserInteractionEnabled = true
            }
        }

        @discardableResult func bringToFront() -> UIView {
            self.superview?.bringSubview(toFront: self)
            return self
        }

        @discardableResult func sendToBack() -> UIView {
            self.superview?.sendSubview(toBack: self)
            return self
        }

        /// UIView animation without the long variable names
        public class func animate(
            _ duration: TimeInterval,
            _ delay: TimeInterval,
            _ damping: CGFloat,
            _ velocity: CGFloat,
            _ options: UIViewAnimationOptions,
            _ animations: @escaping () -> Void,
            _ completion: @escaping (Bool) -> Void = { _ in }
        ) {
            UIView.animate(
                withDuration: duration,
                delay: delay,
                usingSpringWithDamping: damping,
                initialSpringVelocity: velocity,
                options: options,
                animations: animations,
                completion: completion
            )
        }

        /// UIView animation without the long variable names or completion block
        public class func animate(
            _ duration: TimeInterval,
            _ delay: TimeInterval,
            _ damping: CGFloat,
            _ velocity: CGFloat,
            _ options: UIViewAnimationOptions,
            _ animations: @escaping () -> Void
        ) {
            UIView.animate(
                withDuration: duration,
                delay: delay,
                usingSpringWithDamping: damping,
                initialSpringVelocity: velocity,
                options: options,
                animations: animations,
                completion: nil
            )
        }

        public func layoutAndWait(_ completion: (() -> Void)?) {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            setNeedsUpdateConstraints()
            layoutIfNeeded()
            setNeedsDisplay()
            CATransaction.commit()
        }

        public func digToKindOfClass(_ classObject: Swift.AnyClass) -> UIResponder? {
            var responder: UIResponder? = self.next
            while responder != nil {
                if responder!.isKind(of: classObject) {
                    return responder
                }
                //                if responder!.objectName == className {
                //                    return responder
                //                }
                //
                responder = responder!.next
            }

            return nil
        }

        public func digToClassName(_ className: String) -> UIResponder? {

            var responder: UIResponder? = self.next
            while responder != nil {
                if responder!.objectName == className {
                    return responder
                }

                responder = responder!.next
            }

            return nil
        }

        // First responder.
        public var firstResponder: UIView? {
            guard !self.isFirstResponder else {
                return self
            }
            for subView in subviews {
                if subView.isFirstResponder {
                    return subView
                }
            }
            return nil
        }

        // Take screenshot of view (if applicable).
        public var screenshot: UIImage? {
            UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0.0)
            defer {
                UIGraphicsEndImageContext()
            }
            guard let context = UIGraphicsGetCurrentContext() else {
                return nil
            }
            layer.render(in: context)
            return UIGraphicsGetImageFromCurrentImageContext()
        }

        @IBInspectable
        // Corner radius of view; also inspectable from Storyboard.
        public var cornerRadius: CGFloat {
            get {
                return layer.cornerRadius
            }
            set {
                layer.masksToBounds = newValue > 0

                layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
            }
        }

        @IBInspectable
        // Border color of view; also inspectable from Storyboard.
        public var borderColor: UIColor? {
            get {
                guard let color = layer.borderColor else {
                    return nil
                }
                return UIColor(cgColor: color)
            }
            set {
                guard let color = newValue else {
                    layer.borderColor = nil
                    return
                }

                layer.borderColor = color.cgColor

                self.leftBorderWidth = self.leftBorderWidth + 0.0
                self.rightBorderWidth = self.rightBorderWidth + 0.0
                self.topBorderWidth = self.topBorderWidth + 0.0
                self.bottomBorderWidth = self.bottomBorderWidth + 0.0
            }
        }

        @IBInspectable
        // Border width of view; also inspectable from Storyboard.
        public var borderWidth: CGFloat {
            get {
                return layer.borderWidth
            }
            set {
                layer.borderWidth = newValue
            }
        }

        @IBInspectable
        var leftBorderWidth: CGFloat {
            get {
                return 0.0 // Just to satisfy property
            }
            set {
                (self.tempObject(key: "bottomBorder") as? UIView)?.removeFromSuperview()

                guard newValue > 0 else {
                    return
                }

                let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: newValue, height: bounds.height))
                self.setTempObject(line, key: "bottomBorder")
                line.translatesAutoresizingMaskIntoConstraints = false
                line.backgroundColor = UIColor(cgColor: layer.borderColor!)
                self.addSubview(line)

                let views = ["line": line]
                let metrics = ["lineWidth": newValue]
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line(==lineWidth)]", options: [], metrics: metrics, views: views))
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|", options: [], metrics: nil, views: views))
            }
        }

        @IBInspectable
        var topBorderWidth: CGFloat {
            get {
                return 0.0 // Just to satisfy property
            }
            set {
                (self.tempObject(key: "bottomBorder") as? UIView)?.removeFromSuperview()

                guard newValue > 0 else {
                    return
                }

                let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: bounds.width, height: newValue))
                self.setTempObject(line, key: "bottomBorder")
                line.translatesAutoresizingMaskIntoConstraints = false
                line.backgroundColor = UIColor(cgColor: layer.borderColor!)
                self.addSubview(line)

                let views = ["line": line]
                let metrics = ["lineWidth": newValue]
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line]|", options: [], metrics: nil, views: views))
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line(==lineWidth)]", options: [], metrics: metrics, views: views))
            }
        }

        @IBInspectable
        var rightBorderWidth: CGFloat {
            get {
                return 0.0 // Just to satisfy property
            }
            set {
                (self.tempObject(key: "bottomBorder") as? UIView)?.removeFromSuperview()

                guard newValue > 0 else {
                    return
                }

                let line = UIView(frame: CGRect(x: bounds.width, y: 0.0, width: newValue, height: bounds.height))
                self.setTempObject(line, key: "bottomBorder")
                line.translatesAutoresizingMaskIntoConstraints = false
                line.backgroundColor = UIColor(cgColor: layer.borderColor!)
                self.addSubview(line)

                let views = ["line": line]
                let metrics = ["lineWidth": newValue]
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|", options: [], metrics: nil, views: views))
            }
        }

        @IBInspectable
        var bottomBorderWidth: CGFloat {
            get {
                return 0.0 // Just to satisfy property
            }
            set {
                (self.tempObject(key: "bottomBorder") as? UIView)?.removeFromSuperview()

                guard newValue > 0 else {
                    return
                }

                let line = UIView(frame: CGRect(x: 0.0, y: bounds.height, width: bounds.width, height: newValue))
                self.setTempObject(line, key: "bottomBorder")
                line.translatesAutoresizingMaskIntoConstraints = false
                line.backgroundColor = UIColor(cgColor: layer.borderColor!)
                self.addSubview(line)

                let views = ["line": line]
                let metrics = ["lineWidth": newValue]
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line]|", options: [], metrics: nil, views: views))
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
            }
        }

        @IBInspectable
        // Shadow color of view; also inspectable from Storyboard.
        public var shadowColor: UIColor? {
            get {
                guard let color = layer.shadowColor else {
                    return nil
                }
                return UIColor(cgColor: color)
            }
            set {
                layer.shadowColor = newValue?.cgColor
            }
        }

        @IBInspectable
        // Shadow offset of view; also inspectable from Storyboard.
        public var shadowOffset: CGSize {
            get {
                return layer.shadowOffset
            }
            set {
                layer.shadowOffset = newValue
            }
        }

        @IBInspectable
        // Shadow opacity of view; also inspectable from Storyboard.
        public var shadowOpacity: Float {
            get {
                return layer.shadowOpacity
            }
            set {
                layer.shadowOpacity = newValue
            }
        }

        @IBInspectable
        // Shadow radius of view; also inspectable from Storyboard.
        public var shadowRadius: CGFloat {
            get {
                return layer.shadowRadius
            }
            set {
                layer.shadowRadius = newValue
            }
        }

        public func applyShadow(outset: UIEdgeInsets = UIEdgeInsetsMake(-4.0, -4.0, -4.0, -4.0), shadowRadius: CGFloat = 20.0, shadowOpacity: Float = 0.2) {
            let insetRect = UIEdgeInsetsInsetRect(self.bounds, outset)

            self.layer.shadowPath = UIBezierPath(roundedRect: insetRect, cornerRadius: 0.0).cgPath
            self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            self.layer.shadowColor = UIColor.lightGray.cgColor
            self.layer.shadowOpacity = shadowOpacity
            self.layer.shadowRadius = shadowRadius
            self.layer.masksToBounds = false
            self.clipsToBounds = false
        }

        public func applyOvalShadow(outset: CGFloat = 10, shadowRadius: CGFloat = 20.0, shadowOpacity: Float = 0.2) {
            let path = UIBezierPath()
            path.addArc(withCenter: CGPoint(x: self.width / 2, y: self.height / 2), radius: self.width / 2 + outset, startAngle: 0, endAngle: 2.0 * CGFloat.pi, clockwise: true)
            self.layer.shadowPath = path.cgPath
            self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            self.layer.shadowColor = UIColor.lightGray.cgColor
            self.layer.shadowOpacity = shadowOpacity
            self.layer.shadowRadius = shadowRadius
            self.layer.masksToBounds = false
            self.clipsToBounds = false
        }


        // Set some or all corners radiuses of view.
        ///
        /// - Parameters:
        ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
        ///   - radius: radius for selected corners.
        public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
            let maskPath = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            let shape = CAShapeLayer()
            shape.path = maskPath.cgPath
            layer.mask = shape
        }

        // Add array of subviews to view.
        ///
        /// - Parameter subViews: array of subviews to add to self.
        public func add(subViews: [UIView]) {
            subViews.forEach({ self.addSubview($0) })
        }

        /// Load view from nib. Note: Nib name must be equal to the class name.
        ///
        /// - parameter view:    The name of the nib file, which need not include the .nib extension
        /// - parameter owner:   The object to assign as the nib’s File's Owner object
        /// - parameter options: options
        ///
        /// - returns: view
        class func loadFromNibAndClass<T: UIView>(_ view: T.Type, owner: Any? = nil, options: [AnyHashable: Any]? = nil) -> T? {

            let name = String(describing: view.self)

            guard let nib = Bundle.main.loadNibNamed(name, owner: owner, options: options) else { return nil }

            return nib.first as? T
        }

        /// SwifterSwift: Load view from nib.
        ///
        /// - Parameters:
        ///   - named: nib name.
        ///   - bundle: bundle of nib (default is nil).
        /// - Returns: optional UIView (if applicable).
        class func loadFromNib(named: String, bundle: Bundle? = nil) -> UIView? {
            return UINib(nibName: named, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
        }

        // Remove all subviews in view.
        public func removeSubViews() {
            self.subviews.forEach({ $0.removeFromSuperview() })
        }

        // Remove all gesture recognizers from view.
        public func removeGestureRecognizers() {
            gestureRecognizers?.forEach(removeGestureRecognizer)
        }

        public func animateConstraints(_ duration: TimeInterval = 0.5, completion: ((Bool) -> Void)? = nil) {
            UIView.animate(withDuration: duration, delay: 0.0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                [weak self] in
                self?.layoutIfNeeded() ?? ()
            }, completion: completion)
        }

        public func animateConstraintsExtended(_ duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, options: UIViewAnimationOptions = [.beginFromCurrentState, .allowUserInteraction], completion: ((Bool) -> Void)? = nil) {
            UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
                [weak self] in
                self?.layoutIfNeeded() ?? ()
            }, completion: completion)
        }

        // Get view's parent view controller
        public var controller: UIViewController? {
            weak var parentResponder: UIResponder? = self
            while parentResponder != nil {
                parentResponder = parentResponder!.next
                if let viewController = parentResponder as? UIViewController {
                    return viewController
                }
            }
            return nil
        }

        /**
         The frame size, not to be confused with the bounds size
         
         For more information on the difference between a view's bounds and frame, see:
         
         - http://www.andrewgertig.com/2013/08/ios-bounds-vs-frame
         - http://ashfurrow.com/blog/you-probably-dont-understand-frames-and-bounds/
         */
        public var size: CGSize {
            set { frame.size = newValue }
            get { return frame.size }
        }
        /**
         The frame height, not to be confused with the bounds height
         
         For more information on the difference between a view's bounds and frame, see:
         
         - http://www.andrewgertig.com/2013/08/ios-bounds-vs-frame
         - http://ashfurrow.com/blog/you-probably-dont-understand-frames-and-bounds/
         */
        public var height: CGFloat {
            set { frame.size.height = newValue }
            get { return frame.height }
        }
        /**
         The frame width, not to be confused with the bounds width
         
         For more information on the difference between a view's bounds and frame, see:
         
         - http://www.andrewgertig.com/2013/08/ios-bounds-vs-frame
         - http://ashfurrow.com/blog/you-probably-dont-understand-frames-and-bounds/
         */
        public var width: CGFloat {
            set { frame.size.width = newValue }
            get { return frame.width }
        }
        /**
         The frame origin, not to be confused with the bounds origin
         
         For more information on the difference between a view's bounds and frame, see:
         
         - http://www.andrewgertig.com/2013/08/ios-bounds-vs-frame
         - http://ashfurrow.com/blog/you-probably-dont-understand-frames-and-bounds/
         */
        public var origin: CGPoint {
            set { frame.origin = newValue }
            get { return frame.origin }
        }
        /**
         The frame origin.x, not to be confused with the bounds origin.x
         
         For more information on the difference between a view's bounds and frame, see:
         
         - http://www.andrewgertig.com/2013/08/ios-bounds-vs-frame
         - http://ashfurrow.com/blog/you-probably-dont-understand-frames-and-bounds/
         */
        public var originX: CGFloat {
            set { frame.origin.x = newValue }
            get { return origin.x }
        }
        /**
         The frame origin.y, not to be confused with the bounds origin.y
         
         For more information on the difference between a view's bounds and frame, see:
         
         - http://www.andrewgertig.com/2013/08/ios-bounds-vs-frame
         - http://ashfurrow.com/blog/you-probably-dont-understand-frames-and-bounds/
         */
        public var originY: CGFloat {
            set { frame.origin.y = newValue }
            get { return origin.y }
        }
        /**
         The frame maxY, not to be confused with the bounds maxY
         
         For more information on the difference between a view's bounds and frame, see:
         
         - http://www.andrewgertig.com/2013/08/ios-bounds-vs-frame
         - http://ashfurrow.com/blog/you-probably-dont-understand-frames-and-bounds/
         */
        public var maxY: CGFloat {
            set { originY = newValue - height }
            get { return frame.maxY }
        }
        /**
         The frame maxX, not to be confused with the bounds maxX
         
         For more information on the difference between a view's bounds and frame, see:
         
         - http://www.andrewgertig.com/2013/08/ios-bounds-vs-frame
         - http://ashfurrow.com/blog/you-probably-dont-understand-frames-and-bounds/
         */
        public var maxX: CGFloat {
            set { originX = newValue - width }
            get { return frame.maxX }
        }
        /**
         The frame minY, not to be confused with the bounds minY
         
         For more information on the difference between a view's bounds and frame, see:
         
         - http://www.andrewgertig.com/2013/08/ios-bounds-vs-frame
         - http://ashfurrow.com/blog/you-probably-dont-understand-frames-and-bounds/
         */
        public var minY: CGFloat {
            set { originY = newValue }
            get { return frame.minY }
        }
        /**
         The frame minX, not to be confused with the bounds minX
         
         For more information on the difference between a view's bounds and frame, see:
         
         - http://www.andrewgertig.com/2013/08/ios-bounds-vs-frame
         - http://ashfurrow.com/blog/you-probably-dont-understand-frames-and-bounds/
         */
        public var minX: CGFloat {
            set { originX = newValue }
            get { return frame.minX }
        }
        /**
         The frame center.x, not to be confused with the bounds center.x
         
         For more information on the difference between a view's bounds and frame, see:
         
         - http://www.andrewgertig.com/2013/08/ios-bounds-vs-frame
         - http://ashfurrow.com/blog/you-probably-dont-understand-frames-and-bounds/
         */
        public var centerX: CGFloat {
            set {
                var center = self.center
                center.x = newValue
                self.center = center
            }
            get { return center.x }
        }
        /**
         The frame center.y, not to be confused with the bounds center.y
         
         For more information on the difference between a view's bounds and frame, see:
         
         - http://www.andrewgertig.com/2013/08/ios-bounds-vs-frame
         - http://ashfurrow.com/blog/you-probably-dont-understand-frames-and-bounds/
         */
        public var centerY: CGFloat {
            set {
                var center = self.center
                center.y = newValue
                self.center = center
            }
            get { return center.y }
        }

        public var right: CGFloat {
            set {
                var frame = self.frame
                frame.origin.x = newValue - frame.size.width
                self.frame = frame
            }
            get { return frame.origin.x + frame.width }
        }

        public var bottom: CGFloat {
            set {
                var frame = self.frame
                frame.origin.y = newValue - frame.size.height
                self.frame = frame
            }
            get { return frame.origin.y + frame.height }
        }

        public var left: CGFloat {
            set {
                var frame = self.frame
                frame.origin.x = newValue
                self.frame = frame
            }
            get { return frame.origin.x }
        }

        public var top: CGFloat {
            set {
                var frame = self.frame
                frame.origin.y = newValue
                self.frame = frame
            }
            get { return frame.origin.y }
        }

        @discardableResult public func centerAtXY(_ offset: CGSize = CGSize.zero, view: UIView? = nil) -> UIView {
            let target = view != nil ? view! : self.superview!
            self.origin = CGPoint(x: (target == self.superview ? 0 : target.left) + (target.width - self.width) / 2 + offset.width, y: (target == superview ? 0 : target.top) + (target.height - self.height) / 2 + offset.height)
            return self
        }

        @discardableResult public func placeAtRight(_ offset: CGSize = CGSize.zero, view: UIView? = nil) -> UIView {
            let target = view != nil ? view! : self.superview!
            self.top = (target == self.superview ? self.superview!.width : target.right) + offset.width
            return self
        }

        @discardableResult public func placeAtLeft(_ offset: CGSize = CGSize.zero, view: UIView? = nil) -> UIView {
            let target = view != nil ? view! : self.superview!
            self.top = (target == self.superview ? 0 : target.left) + offset.width - self.width
            return self
        }

        @discardableResult public func placeAtTop(_ offset: CGSize = CGSize.zero, view: UIView? = nil) -> UIView {
            let target = view != nil ? view! : self.superview!
            self.top = (target == self.superview ? 0 : target.top) + offset.height - self.height
            return self
        }

        @discardableResult public func placeAtBottom(_ offset: CGSize = CGSize.zero, view: UIView? = nil) -> UIView {
            let target = view != nil ? view! : self.superview!
            self.top = (target == self.superview ? self.superview!.height : target.bottom) + offset.height
            return self
        }

        @discardableResult public func centerAtX(_ offset: CGSize = CGSize.zero, view: UIView? = nil) -> UIView {
            let target = view != nil ? view! : self.superview!
            self.left = (target == self.superview ? 0 : target.left) + (target.width - self.width) / 2 + offset.width
            return self
        }

        @discardableResult public func centerAtY(_ offset: CGSize = CGSize.zero, view: UIView? = nil) -> UIView {
            let target = view != nil ? view! : self.superview!
            self.top = (target == self.superview ? 0 : target.top) + (target.height - self.height) / 2 + offset.height
            return self
        }

        @discardableResult
        public func fillSuperView(_ edges: UIEdgeInsets = UIEdgeInsets.zero) -> [NSLayoutConstraint] {

            var constraints: [NSLayoutConstraint] = []

            if let superview = superview {

                let topConstraint = addTopConstraint(toView: superview, constant: edges.top)
                let leadingConstraint = addLeadingConstraint(toView: superview, constant: edges.left)
                let bottomConstraint = addBottomConstraint(toView: superview, constant: -edges.bottom)
                let trailingConstraint = addTrailingConstraint(toView: superview, constant: -edges.right)

                constraints = [topConstraint, leadingConstraint, bottomConstraint, trailingConstraint]
            }

            return constraints
        }

        @discardableResult
        public func addLeadingConstraint(toView view: UIView?, attribute: NSLayoutAttribute = .leading, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {

            let constraint = createConstraint(attribute: .leading, toView: view, attribute: attribute, relation: relation, constant: constant)
            addConstraintToSuperview(constraint)

            return constraint
        }

        @discardableResult
        public func addTopConstraint(toView view: UIView?, attribute: NSLayoutAttribute = .top, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {

            let constraint = createConstraint(attribute: .top, toView: view, attribute: attribute, relation: relation, constant: constant)
            addConstraintToSuperview(constraint)

            return constraint
        }

        @discardableResult
        public func addBottomConstraint(toView view: UIView?, attribute: NSLayoutAttribute = .bottom, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {

            let constraint = createConstraint(attribute: .bottom, toView: view, attribute: attribute, relation: relation, constant: constant)
            addConstraintToSuperview(constraint)

            return constraint
        }

        @discardableResult
        public func addTrailingConstraint(toView view: UIView?, attribute: NSLayoutAttribute = .trailing, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {

            let constraint = createConstraint(attribute: .trailing, toView: view, attribute: attribute, relation: relation, constant: constant)
            addConstraintToSuperview(constraint)

            return constraint
        }

        fileprivate func addConstraintToSuperview(_ constraint: NSLayoutConstraint) {

            translatesAutoresizingMaskIntoConstraints = false
            superview?.addConstraint(constraint)
        }

        fileprivate func createConstraint(attribute attr1: NSLayoutAttribute, toView: UIView?, attribute attr2: NSLayoutAttribute, relation: NSLayoutRelation, constant: CGFloat) -> NSLayoutConstraint {

            let constraint = NSLayoutConstraint(
                item: self,
                attribute: attr1,
                relatedBy: relation,
                toItem: toView,
                attribute: attr2,
                multiplier: 1.0,
                constant: constant
            )

            return constraint
        }

        public func ceilPosition() -> UIView {
            self.origin = CGPoint(x: ceil(self.left), y: ceil(self.top))
            return self
        }

        @discardableResult
        public func sizeToFit(_ width: CGFloat, _ height: CGFloat) -> CGSize {
            return sizeToFit(CGSize(width: width, height: height))
        }

        @discardableResult
        public func sizeToFit(_ constrainedSize: CGSize) -> CGSize {
            var newSize = sizeThatFits(constrainedSize)
            newSize.width = min(newSize.width, constrainedSize.width)
            newSize.height = min(newSize.height, constrainedSize.height)
            size = newSize
            return newSize
        }

        ///
        /// - parameter point:       point
        /// - parameter event:       evet
        /// - parameter invisibleOn: If you want hidden view can not be hit, set `invisibleOn` to true
        ///
        /// - returns: UIView
        public func overlapHitTest(_ point: CGPoint, with event: UIEvent?, invisibleOn: Bool = false) -> UIView? {
            // 1
            let invisible = (isHidden || alpha == 0) && invisibleOn

            if !isUserInteractionEnabled || invisible {
                return nil
            }
            // 2
            var hitView: UIView? = self
            if !self.point(inside: point, with: event) {
                if clipsToBounds {
                    return nil
                } else {
                    hitView = nil
                }
            }
            // 3
            for subview in subviews.reversed() {
                let insideSubview = convert(point, to: subview)
                if let sview = subview.overlapHitTest(insideSubview, with: event) {
                    return sview
                }
            }
            return hitView
        }

        public var snapshot: UIImage? {
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
            drawHierarchy(in: bounds, afterScreenUpdates: true)
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result
        }

        public var snapshotData: Data {
            #if os(iOS)
                UIGraphicsBeginImageContext(frame.size)
                layer.render(in: UIGraphicsGetCurrentContext()!)
                let fullScreenshot = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                UIImageWriteToSavedPhotosAlbum(fullScreenshot!, nil, nil, nil)
                return UIImageJPEGRepresentation(fullScreenshot!, 0.5)!
            #elseif os(OSX)
                let rep: NSBitmapImageRep = self.view.bitmapImageRepForCachingDisplayInRect(self.view.bounds)!
                self.view.cacheDisplayInRect(self.view.bounds, toBitmapImageRep: rep)
                return rep.TIFFRepresentation!
            #endif
        }

        func isEqualToNameOfClass(_ name: String) -> Bool {
            return String(describing: classForCoder) == name
        }

        /// loop subviews and subviews' subviews
        ///
        /// - parameter closure: subview
        public func loopViews(_ closure: ((_ subView: UIView) -> Void)) {
            for v in subviews {
                closure(v)
                v.loopViews(closure)
            }
        }

        /// loop subviews and subviews' subviews
        ///
        /// - parameter nameOfView:   name of subview
        /// - parameter shouldReturn: should return or not when meeting the specific subview
        /// - parameter execute:      subview
        public func loopViews(_ nameOfView: String, shouldReturn: Bool = true, execute: ((_ subView: UIView) -> Void)) {
            for v in subviews {
                if v.isEqualToNameOfClass(nameOfView) {
                    execute(v)
                    if shouldReturn {
                        return
                    }
                }
                v.loopViews(nameOfView, shouldReturn: shouldReturn, execute: execute)
            }
        }

        /// SwifterSwift: Check if view is in RTL format.
        public var isRightToLeft: Bool {
            if #available(iOS 10.0, *, tvOS 10.0, *) {
                return effectiveUserInterfaceLayoutDirection == .rightToLeft
            } else {
                return false
            }
        }

        /// SwifterSwift: Get view's parent view controller
        public var parentViewController: UIViewController? {
            weak var parentResponder: UIResponder? = self
            while parentResponder != nil {
                parentResponder = parentResponder!.next
                if let viewController = parentResponder as? UIViewController {
                    return viewController
                }
            }
            return nil
        }

        func roundCorners(byRoundingCorners corners: UIRectCorner, cornerRadii: CGSize) {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }

    }

    public func resursiveTint(parent: UIView?, color: UIColor) {
        guard let parent = parent else {
            return
        }

        for view in parent.subviews {
            if view is UILabel || view is UITextField || view is UITextView {
                view.tintColor = color
                (view as! UILabel).textColor = color
            } else if view is UIButton {
                let btn = view as! UIButton
                if btn.buttonType == .system {
                    btn.tintColor = color
                } else {
                    btn.setTitleColor(color, for: .normal)
                }

            } else {
                resursiveTint(parent: view, color: color)
            }
        }
    }




#endif
