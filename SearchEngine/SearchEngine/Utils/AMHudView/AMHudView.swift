import Foundation
import UIKit

public class AMHudView: UIView {
    public var offset: Int = 10 {
        didSet {
            self.setNeedsLayout()
        }
    }

    private var mainLabel: UILabel!
    private var cancelButton: UIButton?
    private var blockingView: UIView!
    private var activityIndicator: UIActivityIndicatorView!
    private var progressBar: UIProgressView!
    private var widthConstraint: NSLayoutConstraint!


    private var cancelColor: UIColor = UIColor.white
    public var mainLabelText: String = ""
    public var progressValue: Float = 0.0
    public var progressDeterminate: Bool = false

    public var cancelBlock: ((AMHudView) -> ())?


    @discardableResult
    public static func hud(withLabel text: String, inView: UIView?) -> AMHudView {

        let hud = AMHudView(text: text)
        if let inView = inView {
            hud.showOverView(view: inView)
        }

        return hud
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.mainLabel = UILabel(frame: CGRect.zero)
        self.mainLabel.translatesAutoresizingMaskIntoConstraints = false
        self.mainLabel.textColor = UIColor.white
        self.mainLabel.textAlignment = .center
        self.addSubview(self.mainLabel)
        self.alpha = 0
        self.backgroundColor = UIColor.black
        self.layer.cornerRadius = 10.0
    }

    public convenience init(text: String) {
        self.init(frame: CGRect(0, 0, 400, 300))
        self.mainLabelText = text
    }

    public convenience init() {
        self.init(frame: CGRect(0, 0, 400, 300))
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }


    override public class var requiresConstraintBasedLayout: Bool {
        get {
            return true
        }

    }

    @IBAction func cancelOperation(sender: AnyObject!) {
        if let cancelBlock = self.cancelBlock {
            cancelBlock(self)
        }
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(200, UIViewNoIntrinsicMetric)
    }

    override public func updateConstraints() {
        self.removeConstraints(self.constraints)
        var viewsDict: [String: Any] = [:]
        let theProgView: UIView! = self.progressDeterminate ? self.progressBar : self.activityIndicator
        theProgView.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(theProgView)

        self.mainLabel.sizeToFit()

        if self.cancelBlock != nil {
            let cancelButton = UIButton(type: .system)
            cancelButton.translatesAutoresizingMaskIntoConstraints = false
            cancelButton.setTitle("Cancel", for: .normal)
            cancelButton.tintColor = self.cancelColor
            cancelButton.frame = CGRect(0, 0, 100, UIFont.buttonFontSize)
            addSubview(cancelButton)
            cancelButton.sizeToFit()
            cancelButton.addTarget(self, action: #selector(cancelOperation(sender:)), for: .touchUpInside)
            self.cancelButton = cancelButton

            viewsDict = ["mainLabel": self.mainLabel, "cancelButton": self.cancelButton, "progress": theProgView]

            self.addConstraint(NSLayoutConstraint(item: self.cancelButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[progress]-[cancelButton]-|", options: [], metrics: nil, views: viewsDict))
        } else {
            viewsDict = ["mainLabel": self.mainLabel, "progress": theProgView]
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[progress]-12-|", options: [], metrics: nil, views: viewsDict))
        }

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[mainLabel]", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[mainLabel]-|", options: [], metrics: nil, views: viewsDict))
        //    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.mainLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        self.addConstraint(NSLayoutConstraint(item: theProgView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[mainLabel]-[progress]", options: [], metrics: nil, views: viewsDict))

        if self.progressDeterminate {
            self.addConstraint(NSLayoutConstraint(item: theProgView, attribute: .width, relatedBy: .equal, toItem: self.mainLabel, attribute: .width, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: theProgView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        }

        //was clipping mainlabel on 7.1, but fine on 8.0. adding this worked on both
        let width: CGFloat = min(20 + max(self.mainLabel.intrinsicContentSize.width, 120), 300)
        self.widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: width)
        self.addConstraint(self.widthConstraint)
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: self.superview, attribute: .centerX, multiplier: 1, constant: 0))
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: self.superview, attribute: .centerY, multiplier: 1, constant: 0))

        super.updateConstraints()
    }

    public func showOverView(view: UIView!) {
        if self.progressDeterminate {
            self.progressBar = UIProgressView(progressViewStyle: .default)
            self.progressBar.progressTintColor = UIColor.white
            self.progressBar.trackTintColor = UIColor.white.alpha(0.4)
        } else {
            self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            self.activityIndicator.startAnimating()
        }
        self.blockingView = AMHudBlockingView(frame: view.bounds)
        self.mainLabel.text = self.mainLabelText
        self.mainLabel.sizeToFit()

        self.cancelButton?.isEnabled = self.cancelBlock != nil

        UIView.animate(withDuration: 0.3) {
            self.alpha = 1.0
        }

        view.addSubview(self.blockingView)
        view.addSubview(self)
    }

    public func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }, completion: { (finished: Bool) in
            self.removeFromSuperview()
        })
        self.blockingView.removeFromSuperview()
    }



    public func setProgressValue(progressValue: Float) {
        let progress = min(max(0.0, progressValue), 1.0)

        let updateGUI: Bool = fabs(progress - self.progressBar.progress) > 0.01
        self.progressValue = progress

        if updateGUI { self.progressBar.progress = progressValue }
    }
}

class AMHudBlockingView: UIView {

    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }

    }


    override init(frame: CGRect) {
        super.init(frame: frame)

        var darkBlur: UIBlurEffect = UIBlurEffect()

        if #available(iOS 10.0, *) { //iOS 10.0 and above
            darkBlur = UIBlurEffect(style: UIBlurEffectStyle.regular)//prominent,regular,extraLight, light, dark
        } else { //iOS 8.0 and above
            darkBlur = UIBlurEffect(style: UIBlurEffectStyle.dark) //extraLight, light, dark
        }

        let blurEffectView = UIVisualEffectView(effect: darkBlur)
        blurEffectView.alpha = 0.5
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

public extension UIView {
    public var visibleHud: AMHudView? {
        var theView: AMHudView!

        let subviews: NSArray = self.subviews as NSArray
        subviews.enumerateObjects ({ (obj, idx, stop) in

        })
        subviews.enumerateObjects(_:) { (obj, idx, stop) in
            if (obj is AMHudView) {
                theView = obj as! AMHudView
                stop.pointee = true
            }
        }
        return theView
    }
}

