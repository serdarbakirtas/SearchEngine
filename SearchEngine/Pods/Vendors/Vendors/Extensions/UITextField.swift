//
//  UITextField.swift
//  Pods
//
//  Ali Kiran on 11/24/16.
//
//

#if os(iOS) || os(tvOS)
    import UIKit

    @discardableResult public func formatCurrency(string: String, textField: UITextField) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.locale = Locale(identifier: "en_US")
        let numberFromField = (NSString(string: string).doubleValue) / 100
        textField.text = formatter.string(from: NSNumber(value: numberFromField))
        return numberFromField
    }

    public func willFormatCurrency(textField: UITextField, shouldChangeCharactersInRange _: NSRange, replacementString string: String) -> Bool {
        if textField.tempObject(key: "currentString") == nil {
            textField.setTempObject("", key: "currentString")
        }

        var currentString = textField.tempObject(key: "currentString") as! String

        switch string {
        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
            currentString += string
        default:

            if string.length == 0 && currentString.length != 0 {
                currentString = String(currentString.characters.dropLast())
            }
        }

        formatCurrency(string: currentString, textField: textField)
        textField.setTempObject(currentString, key: "currentString")

        return false
    }

    public func willFormatNumeric(textField: UITextField, shouldChangeCharactersInRange _: NSRange, replacementString string: String) -> Bool {
        if textField.tempObject(key: "currentString") == nil {
            textField.setTempObject("", key: "currentString")
        }

        var currentString = textField.tempObject(key: "currentString") as! String

        switch string {
        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
            currentString += string
        default:

            if string.length == 0 && currentString.length != 0 {
                currentString = String(currentString.characters.dropLast())
            }
        }

        textField.text = currentString
        textField.setTempObject(currentString, key: "currentString")

        return false
    }

    public extension UITextField {

        /// SwifterSwift: Check if text field is empty.
        public var isEmpty: Bool {
            if let text = self.text {
                return text.isEmpty
            }
            return true
        }

        // Return text with no spaces or new lines in beginning and end.
        public var trimmedText: String? {
            return text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }

        @IBInspectable
        // Left view tint color.
        public var leftViewTintColor: UIColor? {
            get {
                guard let iconView = self.leftView as? UIImageView else {
                    return nil
                }
                return iconView.tintColor
            }
            set {
                guard let iconView = self.leftView as? UIImageView else {
                    return
                }
                iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
                iconView.tintColor = newValue
            }
        }

        @IBInspectable
        // Right view tint color.
        public var rightViewTintColor: UIColor? {
            get {
                guard let iconView = self.rightView as? UIImageView else {
                    return nil
                }
                return iconView.tintColor
            }
            set {
                guard let iconView = self.rightView as? UIImageView else {
                    return
                }
                iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
                iconView.tintColor = newValue
            }
        }

        // SwifterSwift: Clear text.
        public func clear() {
            text = ""
            attributedText = NSAttributedString(string: "")
        }

        @IBInspectable var placeHolderColor: UIColor? {
            get {
                return self.placeHolderColor
            }
            set {
                self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSForegroundColorAttributeName: newValue ?? UIColor.gray])
            }
        }
    }
#endif
