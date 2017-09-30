//
//  UIColor.swift
//  Pods
//
//  Created by Admin on 11/24/16.
//
//

import Foundation
#if !os(macOS)
    import UIKit

    public func UIColorFromRGB(_ colorCode: String, alpha: Float = 1.0) -> UIColor {
        let scanner = Scanner(string: colorCode)
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)

        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask) / 255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask) / 255.0)
        let b = CGFloat(Float(Int(color) & mask) / 255.0)

        return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }

    // MARK: - Properties
    public extension UIColor {
        /**
         The six-digit hexadecimal representation of color of the form #RRGGBB.

         - parameter hex: Six-digit hexadecimal value.
         */
        public convenience init(hex: UInt32, alpha: CGFloat = 1) {
            let divisor = CGFloat(255)
            let red = CGFloat((hex & 0xFF0000) >> 16) / divisor
            let green = CGFloat((hex & 0x00FF00) >> 8) / divisor
            let blue = CGFloat(hex & 0x0000FF) / divisor
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }

        /**
         The shorthand three-digit hexadecimal representation of color.
         #RGB defines to the color #RRGGBB.

         - parameter hex3: Three-digit hexadecimal value.
         - parameter alpha: 0.0 - 1.0. The default is 1.0.
         */
        public convenience init(hex3: UInt16, alpha: CGFloat = 1) {
            let divisor = CGFloat(15)
            let red = CGFloat((hex3 & 0xF00) >> 8) / divisor
            let green = CGFloat((hex3 & 0x0F0) >> 4) / divisor
            let blue = CGFloat(hex3 & 0x00F) / divisor
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }

        /**
         The shorthand four-digit hexadecimal representation of color with alpha.
         #RGBA defines to the color #RRGGBBAA.

         - parameter hex4: Four-digit hexadecimal value.
         */
        public convenience init(hex4: UInt16) {
            let divisor = CGFloat(15)
            let red = CGFloat((hex4 & 0xF000) >> 12) / divisor
            let green = CGFloat((hex4 & 0x0F00) >> 8) / divisor
            let blue = CGFloat((hex4 & 0x00F0) >> 4) / divisor
            let alpha = CGFloat(hex4 & 0x000F) / divisor
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }

        /**
         The six-digit hexadecimal representation of color of the form #RRGGBB.

         - parameter hex6: Six-digit hexadecimal value.
         */
        public convenience init(hex6: UInt32, alpha: CGFloat = 1) {
            let divisor = CGFloat(255)
            let red = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
            let green = CGFloat((hex6 & 0x00FF00) >> 8) / divisor
            let blue = CGFloat(hex6 & 0x0000FF) / divisor
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }

        /**
         The six-digit hexadecimal representation of color with alpha of the form #RRGGBBAA.

         - parameter hex8: Eight-digit hexadecimal value.
         */
        public convenience init(hex8: UInt32) {
            let divisor = CGFloat(255)
            let red = CGFloat((hex8 & 0xFF000000) >> 24) / divisor
            let green = CGFloat((hex8 & 0x00FF0000) >> 16) / divisor
            let blue = CGFloat((hex8 & 0x0000FF00) >> 8) / divisor
            let alpha = CGFloat(hex8 & 0x000000FF) / divisor
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }

        /**
         Returns a UIColor initialized with color components divided by 255.0.
         - parameter red: Integer representation of the red component in range of 0-255.
         - parameter green: Integer representation of the green component in range of 0-255.
         - parameter blue: Integer representation of the blue component in range of 0-255.
         */
        public convenience init(red: UInt8, green: UInt8, blue: UInt8) {
            self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
        }

        /**
         Returns a UIColor from the given RGB components.
         - parameter red: The red component in range of 0-255.
         - parameter green: The green component in range of 0-255.
         - parameter blue: The blue component in range of 0-255.
         - parameter alpha: The alpha component.
         - returns: A UIColor initialized with the given RGB components.
         */
        public static func rgb(_ red: UInt8, _ green: UInt8, _ blue: UInt8, alpha: CGFloat = 1) -> UIColor {
            return UIColor(red: red, green: green, blue: blue).alpha(alpha)
        }

        /**
         Returns an alpha-adjusted UIColor.
         - returns: A UIColor with an adjust alpha component (shorthand for `colorWithAlphaComponent`).
         */
        public final func alpha(_ alpha: CGFloat) -> UIColor {
            return withAlphaComponent(alpha)
        }

        /**
         Returns a UIColor from a hue-saturation-lightness (HSL) set.
         - parameter hue: The hue component of the color object, specified as a value from 0.0 to 1.0.
         - parameter saturation: The saturation component of the color object, specified as a value from 0.0 to 1.0.
         - parameter lightness: The lightness component of the color object, specified as a value from 0.0 to 1.0.
         - parameter alpha: The opacity component of the color object, specified as a value from 0.0 to 1.0 (optional).
         - returns: A UIColor initialized with the given color value.
         */
        public convenience init(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat = 1) {
            assert((0 ... 1).contains(hue), "hue value must be a value between 0.0 and 1.0")
            assert((0 ... 1).contains(saturation), "saturation must be a value between 0.0 and 1.0")
            assert((0 ... 1).contains(lightness), "lightness must be a value between 0.0 and 1.0")
            assert((0 ... 1).contains(alpha), "alpha must be a value between 0.0 and 1.0")

            let (r, g, b) = Model.hsl(hue, saturation, lightness).rgb
            self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: alpha)
        }

        /**
         Returns a UIColor from a cyan-magenta-yellow-key (CMYK) set.
         - parameter cyan: The cyan component of the color object, specified as a value from 0.0 to 1.0.
         - parameter magenta: The magenta component of the color object, specified as a value from 0.0 to 1.0.
         - parameter yellow: The yellow component of the color object, specified as a value from 0.0 to 1.0.
         - parameter key: The key (black) component of the color object, specified as a value from 0.0 to 1.0.
         - parameter alpha: The opacity component of the color object, specified as a value from 0.0 to 1.0 (optional).
         - returns: A UIColor initialized with the given color value.
         */
        public convenience init(cyan: CGFloat, magenta: CGFloat, yellow: CGFloat, key: CGFloat, alpha: CGFloat = 1) {
            assert((0 ... 1).contains(cyan), "cyan value must be a value between 0.0 and 1.0")
            assert((0 ... 1).contains(magenta), "magenta must be a value between 0.0 and 1.0")
            assert((0 ... 1).contains(yellow), "yellow must be a value between 0.0 and 1.0")
            assert((0 ... 1).contains(key), "key must be a value between 0.0 and 1.0")
            assert((0 ... 1).contains(alpha), "alpha must be a value between 0.0 and 1.0")

            let (r, g, b) = Model.cmyk(cyan, magenta, yellow, key).rgb
            self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: alpha)
        }

        public convenience init(hexString: String) {
            self.init(hexString: hexString, alpha: 1)
        }

        /**
         Returns a UIColor from a given hex color string.
         - parameter hexString: The hex color string, e.g.: "#9443FB" or "9443FB".
         - returns: A UIColor initialized with the color specified by the hexString.
         */
        public convenience init(hexString: String, alpha: CGFloat = 1) {
            var hexString = hexString
            if hexString.hasPrefix("#") {
                hexString = hexString.substring(from: hexString.index(after: hexString.startIndex))
            }
            let scanner = Scanner(string: hexString)
            var hexEquivalent: UInt32 = 0

            if !scanner.scanHexInt32(&hexEquivalent) {
                assertionFailure("hexString did not contain a valid hex value")
            }

            self.init(hex6: hexEquivalent, alpha: alpha)
        }

        // Red component of UIColor (read-only).
        public var redComponent: Int {
            var red: CGFloat = 0
            getRed(&red, green: nil, blue: nil, alpha: nil)
            return Int(red * 255)
        }

        // Green component of UIColor (read-only).
        public var greenComponent: Int {
            var green: CGFloat = 0
            getRed(nil, green: &green, blue: nil, alpha: nil)
            return Int(green * 255)
        }

        // blue component of UIColor (read-only).
        public var blueComponent: Int {
            var blue: CGFloat = 0
            getRed(nil, green: nil, blue: &blue, alpha: nil)
            return Int(blue * 255)
        }

        // Alpha of UIColor (read-only).
        public var alpha: CGFloat {
            var a: CGFloat = 0
            getRed(nil, green: nil, blue: nil, alpha: &a)
            return a
        }

        /// RGB properties: luminance.
        public var luminance: CGFloat {
            if self.canProvideRGBComponents() {
                var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0

                if !self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
                    return 0.0
                }
                return red * 0.2126 + green * 0.7152 + blue * 0.0722
            }
            return 0.0
        }

        /// Check if the color is in RGB format.
        ///
        /// - Returns: Returns if the color is in RGB format.
        public func canProvideRGBComponents() -> Bool {
            guard let colorSpace = self.cgColor.colorSpace else {
                return false
            }
            switch colorSpace.model {
            case CGColorSpaceModel.rgb, CGColorSpaceModel.monochrome:
                return true
            default:
                return false
            }
        }

        /// A complementary color that should look good.
        ///
        /// - Returns: Returns the color.
        public func complementary() -> UIColor? {
            var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0

            if !self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
                return nil
            }

            hue += 180
            if hue > 360 {
                hue -= 360
            }

            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        }

        /// A good contrasting color, it will be either black or white.
        ///
        /// - Returns: Returns the color.
        public func contrasting() -> UIColor {
            return self.luminance > 0.5 ? UIColor.black : UIColor.white
        }

        /**
         Returns the color represenation as a hexadecimal string, prefixed with '#'.
         - returns: The hexadecimal string representation of the color.
         */
        public final var hexString: String {
            return String(format: "#%06x", hex)
        }

        /**
         Returns the color representation as a 32-bit integer.
         - returns: A UInt32 that represents the hexadecimal color.
         */
        public final var hex: UInt32 {
            let (r, g, b, _) = self.rgba
            return Model.rgb(r * 255, g * 255, b * 255).hex
        }

        /**
         Returns the RGBA (red, green, blue, alpha) components, specified as values from 0.0 to 1.0.
         - returns: The RGBA components as a tuple (r, g, b, a).
         */
        public final var rgba: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
            var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            getRed(&r, green: &g, blue: &b, alpha: &a)

            return (r, g, b, a)
        }

        /**
         Returns the HSL (hue, saturation, lightness) components, specified as values from 0.0 to 1.0.
         - returns: The HSL components as a tuple (h, s, l).
         */
        public final var hsl: (h: CGFloat, s: CGFloat, l: CGFloat) {
            let (r, g, b, _) = rgba
            return Model.rgb(r * 255, g * 255, b * 255).hsl
        }

        /**
         Returns the HSB (hue, saturation, brightness) components, specified as values from 0.0 to 1.0.
         - returns: The HSB components as a tuple (h, s, b).
         */
        public final var hsb: (h: CGFloat, s: CGFloat, b: CGFloat) {
            let (r, g, b, _) = rgba
            return Model.rgb(r * 255, g * 255, b * 255).hsb
        }

        /**
         Returns the CMYK (cyan, magenta, yellow, key) components, specified as values from 0.0 to 1.0.
         - returns: The CMYK components as a tuple (c, m, y, k).
         */
        public final var cmyk: (c: CGFloat, m: CGFloat, y: CGFloat, k: CGFloat) {
            let (r, g, b, _) = rgba
            return Model.rgb(r * 255, g * 255, b * 255).cmyk
        }

        // Short hexadecimal value string (read-only, if applicable).
        public var shortHexString: String? {
            let string = hexString.replace("#", withString: "")
            guard string[0] == string[1]
                && string[2] == string[3]
                && string[4] == string[5] else {
                return nil
            }
            guard let first = string[0], let second = string[2], let third = string[5] else {
                return nil
            }
            return "#" + first + second + third
        }

        // Short hexadecimal value string, or full hexadecimal string if not possible (read-only).
        public var shortHexOrHexString: String {
            return shortHexString ?? hexString
        }

        /// Returns a random UIColor with hue, saturation, and brightness ranging from 0.5 to 1.0.
        public static var random: UIColor {
            let component = { CGFloat(arc4random() % 128) / 256.0 + 0.5 }
            return UIColor(hue: component(), saturation: component(), brightness: component(), alpha: 1)
        }

        open override var description: String {
            return self.hexString
        }

        open override var debugDescription: String {
            return self.hexString
        }

        /// Mixes the color with another color
        ///
        /// - parameter color: The color to mix with
        /// - parameter amount: The amount (0-1) to mix the new color in.
        /// - returns: A new UIColor instance representing the resulting color
        public func mixWithColor(color: UIColor, amount: Float) -> UIColor {
            var comp1: [CGFloat] = Array(repeating: 0, count: 4)
            self.getRed(&comp1[0], green: &comp1[1], blue: &comp1[2], alpha: &comp1[3])

            var comp2: [CGFloat] = Array(repeating: 0, count: 4)
            color.getRed(&comp2[0], green: &comp2[1], blue: &comp2[2], alpha: &comp2[3])

            var comp: [CGFloat] = Array(repeating: 0, count: 4)
            for i in 0 ... 3 {
                comp[i] = comp1[i] + (comp2[i] - comp1[i]) * CGFloat(amount)
            }

            return UIColor(red: comp[0], green: comp[1], blue: comp[2], alpha: comp[3])
        }

        /**
         Lightens the given color by the given percentage.
         - parameter amount: The percentage by which to lighten the color. Valid values are from `0.0` to `1.0`, or for a more readable format `0%` to `100%`.
         - returns: The lightened color.
         */
        public final func lightened(by amount: CGFloat) -> UIColor {
            assert((0 ... 1).contains(amount), "amount must be in range 0-100%")

            let (h, s, l) = hsl
            return UIColor(hue: h, saturation: s, lightness: l * (1 + amount), alpha: rgba.a)
        }

        /**
         Darkens the given color by the given percentage.
         - parameter amount: The percentage by which to darken the color. Valid values are from `0.0` to `1.0`, or for a more readable format `0%` to `100%`.
         - returns: The darkened color.
         */
        public final func darkened(by amount: CGFloat) -> UIColor {
            assert((0 ... 1).contains(amount), "amount must be in range 0-100%")

            let (h, s, l) = hsl
            return UIColor(hue: h, saturation: s, lightness: l * (1 - amount), alpha: rgba.a)
        }

    }

    // MARK: - Model

    extension UIColor {

        /**
         Model is an enum for describing and converting color models.

         - `rgb`: Red, Green, Blue color representation
         - `hsl`: Hue, Saturation, Lightness color representation
         - `hsb`: Hue, Saturation, Brightness color representation
         - `cmyk`: Cyan, Magenta, Yellow, Key (Black) color representation
         - `hex`: UInt32 (hex) color representation
         */
        public enum Model {
            /// Red, Green, Blue
            case rgb(CGFloat, CGFloat, CGFloat)
            /// Hue, Saturation, Lightness
            case hsl(CGFloat, CGFloat, CGFloat)
            /// Hue, Saturation, Brightness
            case hsb(CGFloat, CGFloat, CGFloat)
            /// Cyan, Magenta, Yellow, Key (Black)
            case cmyk(CGFloat, CGFloat, CGFloat, CGFloat)
            /// UInt32 (hex)
            case hex(UInt32)

            /// Returns the model as an RGB tuple
            public var rgb: (r: CGFloat, g: CGFloat, b: CGFloat) {
                switch self {
                case let .rgb(rgb):
                    return rgb
                case let .hsl(h, s, l):
                    return convert(hsl: h, s, l)
                case let .hsb(h, s, b):
                    return convert(hsb: h, s, b)
                case let .cmyk(c, m, y, k):
                    return convert(cmyk: c, m, y, k)
                case let .hex(hex):
                    return convert(hex: hex)
                }
            }

            /// Returns the model as an HSL tuple
            public var hsl: (h: CGFloat, s: CGFloat, l: CGFloat) {
                switch self {
                case let .rgb(r, g, b):
                    return convert(rgb: r, g, b)
                case let .hsl(hsl):
                    return hsl
                case .hsb, .cmyk, .hex:
                    let (r, g, b) = self.rgb
                    return convert(rgb: r, g, b)
                }
            }

            /// Returns the model as an HSB tuple
            public var hsb: (h: CGFloat, s: CGFloat, b: CGFloat) {
                switch self {
                case let .rgb(r, g, b):
                    return convert(rgb: r, g, b)
                case .hsl, .cmyk, .hex:
                    let (r, g, b) = self.rgb
                    return convert(rgb: r, g, b)
                case let .hsb(hsb):
                    return hsb
                }
            }

            /// Returns the model as a CMYK tuple
            public var cmyk: (c: CGFloat, m: CGFloat, y: CGFloat, k: CGFloat) {
                switch self {
                case let .rgb(r, g, b):
                    return convert(rgb: r, g, b)
                case .hsl, .hsb, .hex:
                    let (r, g, b) = self.rgb
                    return convert(rgb: r, g, b)
                case let .cmyk(cmyk):
                    return cmyk
                }
            }

            /// Returns the model as a UInt32 (hex) value
            public var hex: UInt32 {
                switch self {
                case let .rgb(r, g, b):
                    return convert(rgb: r, g, b)
                case .hsl, .hsb, .cmyk:
                    let (r, g, b) = self.rgb
                    return convert(rgb: r, g, b)
                case let .hex(hex):
                    return hex
                }
            }
        }
    }

    // MARK: - Private color model conversions

    /// Converts RGB to HSL (https://en.wikipedia.org/wiki/HSL_and_HSV)
    private func convert(rgb r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> (h: CGFloat, s: CGFloat, l: CGFloat) {

        let r = r / 255
        let g = g / 255
        let b = b / 255

        let max = Swift.max(r, g, b)
        let min = Swift.min(r, g, b)

        var h, s: CGFloat
        let l = (max + min) / 2

        if max == min {
            h = 0
            s = 0
        } else {
            let d = max - min
            s = (l > 0.5) ? d / (2 - max - min) : d / (max + min)

            switch max {
            case r: h = (g - b) / d + (g < b ? 6 : 0)
            case g: h = (b - r) / d + 2
            case b: h = (r - g) / d + 4
            default: h = 0
            }

            h /= 6
        }

        return (h, s, l)
    }

    /// Converts HSL to RGB (https://en.wikipedia.org/wiki/HSL_and_HSV)
    private func convert(hsl h: CGFloat, _ s: CGFloat, _ l: CGFloat) -> (r: CGFloat, g: CGFloat, b: CGFloat) {

        let r, g, b: CGFloat

        if s == 0 {
            r = l
            g = l
            b = l
        } else {
            let c = (1 - abs(2 * l - 1)) * s
            let x = c * (1 - abs((h * 6).truncatingRemainder(dividingBy: 2) - 1))
            let m = l - c / 2

            switch h * 6 {
            case 0 ..< 1: (r, g, b) = (c, x, 0) + m
            case 1 ..< 2: (r, g, b) = (x, c, 0) + m
            case 2 ..< 3: (r, g, b) = (0, c, x) + m
            case 3 ..< 4: (r, g, b) = (0, x, c) + m
            case 4 ..< 5: (r, g, b) = (x, 0, c) + m
            case 5 ..< 6: (r, g, b) = (c, 0, x) + m
            default: (r, g, b) = (0, 0, 0) + m
            }
        }

        return (round(r * 255), round(g * 255), round(b * 255))
    }

    /// Converts RGB to HSB (https://en.wikipedia.org/wiki/HSL_and_HSV)
    private func convert(rgb r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> (h: CGFloat, s: CGFloat, b: CGFloat) {
        var h, s, v: CGFloat

        let r = r / 255
        let g = g / 255
        let b = b / 255

        let max = Swift.max(r, g, b)
        let min = Swift.min(r, g, b)
        let d = max - min

        if d == 0 {
            h = 0
            s = 0
        } else {
            s = (max == 0) ? 0 : d / max

            switch max {
            case r: h = ((g - b) / d) + (g < b ? 6 : 0)
            case g: h = ((b - r) / d) + 2
            case b: h = ((r - g) / d) + 4
            default: h = 0
            }

            h /= 6
        }

        v = max

        return (h, s, v)
    }

    /// Converts HSB to RGB (https://en.wikipedia.org/wiki/HSL_and_HSV)
    private func convert(hsb h: CGFloat, _ s: CGFloat, _ b: CGFloat) -> (r: CGFloat, g: CGFloat, b: CGFloat) {

        let c = b * s
        let x = c * (1 - abs((h * 6).truncatingRemainder(dividingBy: 2) - 1))
        let m = b - c

        var r, g, b: CGFloat

        switch h * 6 {
        case 0 ..< 1: (r, g, b) = (c, x, 0) + m
        case 1 ..< 2: (r, g, b) = (x, c, 0) + m
        case 2 ..< 3: (r, g, b) = (0, c, x) + m
        case 3 ..< 4: (r, g, b) = (0, x, c) + m
        case 4 ..< 5: (r, g, b) = (x, 0, c) + m
        case 5 ..< 6: (r, g, b) = (c, 0, x) + m
        default: (r, g, b) = (0, 0, 0) + m
        }

        return (round(r * 255), round(g * 255), round(b * 255))
    }

    /// Converts UInt32 to RGB
    private func convert(hex: UInt32) -> (r: CGFloat, g: CGFloat, b: CGFloat) {
        let r = CGFloat((hex >> 16) & 0xFF)
        let g = CGFloat((hex >> 8) & 0xFF)
        let b = CGFloat(hex & 0xFF)

        return (r, g, b)
    }

    /// Converts RGB to UInt32
    private func convert(rgb r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UInt32 {
        return (UInt32(r) << 16) | (UInt32(g) << 8) | UInt32(b)
    }

    /// Converts RGB to CMYK (http://www.rapidtables.com/convert/color/rgb-to-cmyk.htm)
    private func convert(rgb r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> (c: CGFloat, m: CGFloat, y: CGFloat, k: CGFloat) {
        let r = r / 255
        let g = g / 255
        let b = b / 255

        let k = 1 - max(r, g, b)
        let c = (k == 1) ? 0 : (1 - r - k) / (1 - k)
        let m = (k == 1) ? 0 : (1 - g - k) / (1 - k)
        let y = (k == 1) ? 0 : (1 - b - k) / (1 - k)

        return (c, m, y, k)
    }

    /// Converts CMYK to RGB (http://www.rapidtables.com/convert/color/cmyk-to-rgb.htm)
    private func convert(cmyk c: CGFloat, _ m: CGFloat, _ y: CGFloat, _ k: CGFloat) -> (r: CGFloat, g: CGFloat, b: CGFloat) {
        let r = 255 * (1 - c) * (1 - k)
        let g = 255 * (1 - m) * (1 - k)
        let b = 255 * (1 - y) * (1 - k)

        return (round(r), round(g), round(b))
    }

    /// Private operator for HSL and HSB conversion
    private func +(lhs: (CGFloat, CGFloat, CGFloat), rhs: CGFloat) -> (CGFloat, CGFloat, CGFloat) {
        return (lhs.0 + rhs, lhs.1 + rhs, lhs.2 + rhs)
    }

    // MARK: - Social Colors
    public extension UIColor {

        /// SwifterSwift: Brand identity color of popular social media platform.
        public struct social {
            // https://www.lockedowndesign.com/social-media-colors/
            public static let facebook = UIColor(red: 59, green: 89, blue: 152)
            public static let twitter = UIColor(red: 0, green: 182, blue: 241)
            public static let googlePlus = UIColor(red: 223, green: 74, blue: 50)
            public static let linkedIn = UIColor(red: 0, green: 123, blue: 182)
            public static let vimeo = UIColor(red: 69, green: 187, blue: 255)
            public static let youtube = UIColor(red: 179, green: 18, blue: 23)
            public static let instagram = UIColor(red: 195, green: 42, blue: 163)
            public static let pinterest = UIColor(red: 203, green: 32, blue: 39)
            public static let flickr = UIColor(red: 244, green: 0, blue: 131)
            public static let yahoo = UIColor(red: 67, green: 2, blue: 151)
            public static let soundCloud = UIColor(red: 255, green: 85, blue: 0)
            public static let tumblr = UIColor(red: 44, green: 71, blue: 98)
            public static let foursquare = UIColor(red: 252, green: 69, blue: 117)
            public static let swarm = UIColor(red: 255, green: 176, blue: 0)
            public static let dribbble = UIColor(red: 234, green: 76, blue: 137)
            public static let reddit = UIColor(red: 255, green: 87, blue: 0)
            public static let devianArt = UIColor(red: 74, green: 93, blue: 78)
            public static let pocket = UIColor(red: 238, green: 64, blue: 86)
            public static let quora = UIColor(red: 170, green: 34, blue: 182)
            public static let slideShare = UIColor(red: 247, green: 146, blue: 30)
            public static let px500 = UIColor(red: 0, green: 153, blue: 229)
            public static let listly = UIColor(red: 223, green: 109, blue: 70)
            public static let vine = UIColor(red: 0, green: 180, blue: 137)
            public static let skype = UIColor(red: 0, green: 175, blue: 240)
            public static let stumbleUpon = UIColor(red: 235, green: 73, blue: 36)
            public static let snapchat = UIColor(red: 255, green: 252, blue: 0)
        }
    }

    // MARK: - Material colors
    public extension UIColor {

        /// SwifterSwift: Google Material design colors palette.
        public struct material {
            // https://material.google.com/style/color.html

            public static let red = red500
            public static let red50 = UIColor(hex: 0xFFEBEE)
            public static let red100 = UIColor(hex: 0xFFCDD2)
            public static let red200 = UIColor(hex: 0xEF9A9A)
            public static let red300 = UIColor(hex: 0xE57373)
            public static let red400 = UIColor(hex: 0xEF5350)
            public static let red500 = UIColor(hex: 0xF44336)
            public static let red600 = UIColor(hex: 0xE53935)
            public static let red700 = UIColor(hex: 0xD32F2F)
            public static let red800 = UIColor(hex: 0xC62828)
            public static let red900 = UIColor(hex: 0xB71C1C)
            public static let redA100 = UIColor(hex: 0xFF8A80)
            public static let redA200 = UIColor(hex: 0xFF5252)
            public static let redA400 = UIColor(hex: 0xFF1744)
            public static let redA700 = UIColor(hex: 0xD50000)

            public static let pink = pink500
            public static let pink50 = UIColor(hex: 0xFCE4EC)
            public static let pink100 = UIColor(hex: 0xF8BBD0)
            public static let pink200 = UIColor(hex: 0xF48FB1)
            public static let pink300 = UIColor(hex: 0xF06292)
            public static let pink400 = UIColor(hex: 0xEC407A)
            public static let pink500 = UIColor(hex: 0xE91E63)
            public static let pink600 = UIColor(hex: 0xD81B60)
            public static let pink700 = UIColor(hex: 0xC2185B)
            public static let pink800 = UIColor(hex: 0xAD1457)
            public static let pink900 = UIColor(hex: 0x880E4F)
            public static let pinkA100 = UIColor(hex: 0xFF80AB)
            public static let pinkA200 = UIColor(hex: 0xFF4081)
            public static let pinkA400 = UIColor(hex: 0xF50057)
            public static let pinkA700 = UIColor(hex: 0xC51162)

            public static let purple = purple500
            public static let purple50 = UIColor(hex: 0xF3E5F5)
            public static let purple100 = UIColor(hex: 0xE1BEE7)
            public static let purple200 = UIColor(hex: 0xCE93D8)
            public static let purple300 = UIColor(hex: 0xBA68C8)
            public static let purple400 = UIColor(hex: 0xAB47BC)
            public static let purple500 = UIColor(hex: 0x9C27B0)
            public static let purple600 = UIColor(hex: 0x8E24AA)
            public static let purple700 = UIColor(hex: 0x7B1FA2)
            public static let purple800 = UIColor(hex: 0x6A1B9A)
            public static let purple900 = UIColor(hex: 0x4A148C)
            public static let purpleA100 = UIColor(hex: 0xEA80FC)
            public static let purpleA200 = UIColor(hex: 0xE040FB)
            public static let purpleA400 = UIColor(hex: 0xD500F9)
            public static let purpleA700 = UIColor(hex: 0xAA00FF)

            public static let deepPurple = deepPurple500
            public static let deepPurple50 = UIColor(hex: 0xEDE7F6)
            public static let deepPurple100 = UIColor(hex: 0xD1C4E9)
            public static let deepPurple200 = UIColor(hex: 0xB39DDB)
            public static let deepPurple300 = UIColor(hex: 0x9575CD)
            public static let deepPurple400 = UIColor(hex: 0x7E57C2)
            public static let deepPurple500 = UIColor(hex: 0x673AB7)
            public static let deepPurple600 = UIColor(hex: 0x5E35B1)
            public static let deepPurple700 = UIColor(hex: 0x512DA8)
            public static let deepPurple800 = UIColor(hex: 0x4527A0)
            public static let deepPurple900 = UIColor(hex: 0x311B92)
            public static let deepPurpleA100 = UIColor(hex: 0xB388FF)
            public static let deepPurpleA200 = UIColor(hex: 0x7C4DFF)
            public static let deepPurpleA400 = UIColor(hex: 0x651FFF)
            public static let deepPurpleA700 = UIColor(hex: 0x6200EA)

            public static let indigo = indigo500
            public static let indigo50 = UIColor(hex: 0xE8EAF6)
            public static let indigo100 = UIColor(hex: 0xC5CAE9)
            public static let indigo200 = UIColor(hex: 0x9FA8DA)
            public static let indigo300 = UIColor(hex: 0x7986CB)
            public static let indigo400 = UIColor(hex: 0x5C6BC0)
            public static let indigo500 = UIColor(hex: 0x3F51B5)
            public static let indigo600 = UIColor(hex: 0x3949AB)
            public static let indigo700 = UIColor(hex: 0x303F9F)
            public static let indigo800 = UIColor(hex: 0x283593)
            public static let indigo900 = UIColor(hex: 0x1A237E)
            public static let indigoA100 = UIColor(hex: 0x8C9EFF)
            public static let indigoA200 = UIColor(hex: 0x536DFE)
            public static let indigoA400 = UIColor(hex: 0x3D5AFE)
            public static let indigoA700 = UIColor(hex: 0x304FFE)

            public static let blue = blue500
            public static let blue50 = UIColor(hex: 0xE3F2FD)
            public static let blue100 = UIColor(hex: 0xBBDEFB)
            public static let blue200 = UIColor(hex: 0x90CAF9)
            public static let blue300 = UIColor(hex: 0x64B5F6)
            public static let blue400 = UIColor(hex: 0x42A5F5)
            public static let blue500 = UIColor(hex: 0x2196F3)
            public static let blue600 = UIColor(hex: 0x1E88E5)
            public static let blue700 = UIColor(hex: 0x1976D2)
            public static let blue800 = UIColor(hex: 0x1565C0)
            public static let blue900 = UIColor(hex: 0x0D47A1)
            public static let blueA100 = UIColor(hex: 0x82B1FF)
            public static let blueA200 = UIColor(hex: 0x448AFF)
            public static let blueA400 = UIColor(hex: 0x2979FF)
            public static let blueA700 = UIColor(hex: 0x2962FF)

            public static let lightBlue = lightBlue500
            public static let lightBlue50 = UIColor(hex: 0xE1F5FE)
            public static let lightBlue100 = UIColor(hex: 0xB3E5FC)
            public static let lightBlue200 = UIColor(hex: 0x81D4FA)
            public static let lightBlue300 = UIColor(hex: 0x4FC3F7)
            public static let lightBlue400 = UIColor(hex: 0x29B6F6)
            public static let lightBlue500 = UIColor(hex: 0x03A9F4)
            public static let lightBlue600 = UIColor(hex: 0x039BE5)
            public static let lightBlue700 = UIColor(hex: 0x0288D1)
            public static let lightBlue800 = UIColor(hex: 0x0277BD)
            public static let lightBlue900 = UIColor(hex: 0x01579B)
            public static let lightBlueA100 = UIColor(hex: 0x80D8FF)
            public static let lightBlueA200 = UIColor(hex: 0x40C4FF)
            public static let lightBlueA400 = UIColor(hex: 0x00B0FF)
            public static let lightBlueA700 = UIColor(hex: 0x0091EA)

            public static let cyan = cyan500
            public static let cyan50 = UIColor(hex: 0xE0F7FA)
            public static let cyan100 = UIColor(hex: 0xB2EBF2)
            public static let cyan200 = UIColor(hex: 0x80DEEA)
            public static let cyan300 = UIColor(hex: 0x4DD0E1)
            public static let cyan400 = UIColor(hex: 0x26C6DA)
            public static let cyan500 = UIColor(hex: 0x00BCD4)
            public static let cyan600 = UIColor(hex: 0x00ACC1)
            public static let cyan700 = UIColor(hex: 0x0097A7)
            public static let cyan800 = UIColor(hex: 0x00838F)
            public static let cyan900 = UIColor(hex: 0x006064)
            public static let cyanA100 = UIColor(hex: 0x84FFFF)
            public static let cyanA200 = UIColor(hex: 0x18FFFF)
            public static let cyanA400 = UIColor(hex: 0x00E5FF)
            public static let cyanA700 = UIColor(hex: 0x00B8D4)

            public static let teal = teal500
            public static let teal50 = UIColor(hex: 0xE0F2F1)
            public static let teal100 = UIColor(hex: 0xB2DFDB)
            public static let teal200 = UIColor(hex: 0x80CBC4)
            public static let teal300 = UIColor(hex: 0x4DB6AC)
            public static let teal400 = UIColor(hex: 0x26A69A)
            public static let teal500 = UIColor(hex: 0x009688)
            public static let teal600 = UIColor(hex: 0x00897B)
            public static let teal700 = UIColor(hex: 0x00796B)
            public static let teal800 = UIColor(hex: 0x00695C)
            public static let teal900 = UIColor(hex: 0x004D40)
            public static let tealA100 = UIColor(hex: 0xA7FFEB)
            public static let tealA200 = UIColor(hex: 0x64FFDA)
            public static let tealA400 = UIColor(hex: 0x1DE9B6)
            public static let tealA700 = UIColor(hex: 0x00BFA5)

            public static let green = green500
            public static let green50 = UIColor(hex: 0xE8F5E9)
            public static let green100 = UIColor(hex: 0xC8E6C9)
            public static let green200 = UIColor(hex: 0xA5D6A7)
            public static let green300 = UIColor(hex: 0x81C784)
            public static let green400 = UIColor(hex: 0x66BB6A)
            public static let green500 = UIColor(hex: 0x4CAF50)
            public static let green600 = UIColor(hex: 0x43A047)
            public static let green700 = UIColor(hex: 0x388E3C)
            public static let green800 = UIColor(hex: 0x2E7D32)
            public static let green900 = UIColor(hex: 0x1B5E20)
            public static let greenA100 = UIColor(hex: 0xB9F6CA)
            public static let greenA200 = UIColor(hex: 0x69F0AE)
            public static let greenA400 = UIColor(hex: 0x00E676)
            public static let greenA700 = UIColor(hex: 0x00C853)

            public static let lightGreen = lightGreen500
            public static let lightGreen50 = UIColor(hex: 0xF1F8E9)
            public static let lightGreen100 = UIColor(hex: 0xDCEDC8)
            public static let lightGreen200 = UIColor(hex: 0xC5E1A5)
            public static let lightGreen300 = UIColor(hex: 0xAED581)
            public static let lightGreen400 = UIColor(hex: 0x9CCC65)
            public static let lightGreen500 = UIColor(hex: 0x8BC34A)
            public static let lightGreen600 = UIColor(hex: 0x7CB342)
            public static let lightGreen700 = UIColor(hex: 0x689F38)
            public static let lightGreen800 = UIColor(hex: 0x558B2F)
            public static let lightGreen900 = UIColor(hex: 0x33691E)
            public static let lightGreenA100 = UIColor(hex: 0xCCFF90)
            public static let lightGreenA200 = UIColor(hex: 0xB2FF59)
            public static let lightGreenA400 = UIColor(hex: 0x76FF03)
            public static let lightGreenA700 = UIColor(hex: 0x64DD17)

            public static let lime = lime500
            public static let lime50 = UIColor(hex: 0xF9FBE7)
            public static let lime100 = UIColor(hex: 0xF0F4C3)
            public static let lime200 = UIColor(hex: 0xE6EE9C)
            public static let lime300 = UIColor(hex: 0xDCE775)
            public static let lime400 = UIColor(hex: 0xD4E157)
            public static let lime500 = UIColor(hex: 0xCDDC39)
            public static let lime600 = UIColor(hex: 0xC0CA33)
            public static let lime700 = UIColor(hex: 0xAFB42B)
            public static let lime800 = UIColor(hex: 0x9E9D24)
            public static let lime900 = UIColor(hex: 0x827717)
            public static let limeA100 = UIColor(hex: 0xF4FF81)
            public static let limeA200 = UIColor(hex: 0xEEFF41)
            public static let limeA400 = UIColor(hex: 0xC6FF00)
            public static let limeA700 = UIColor(hex: 0xAEEA00)

            public static let yellow = yellow500
            public static let yellow50 = UIColor(hex: 0xFFFDE7)
            public static let yellow100 = UIColor(hex: 0xFFF9C4)
            public static let yellow200 = UIColor(hex: 0xFFF59D)
            public static let yellow300 = UIColor(hex: 0xFFF176)
            public static let yellow400 = UIColor(hex: 0xFFEE58)
            public static let yellow500 = UIColor(hex: 0xFFEB3B)
            public static let yellow600 = UIColor(hex: 0xFDD835)
            public static let yellow700 = UIColor(hex: 0xFBC02D)
            public static let yellow800 = UIColor(hex: 0xF9A825)
            public static let yellow900 = UIColor(hex: 0xF57F17)
            public static let yellowA100 = UIColor(hex: 0xFFFF8D)
            public static let yellowA200 = UIColor(hex: 0xFFFF00)
            public static let yellowA400 = UIColor(hex: 0xFFEA00)
            public static let yellowA700 = UIColor(hex: 0xFFD600)

            public static let amber = amber500
            public static let amber50 = UIColor(hex: 0xFFF8E1)
            public static let amber100 = UIColor(hex: 0xFFECB3)
            public static let amber200 = UIColor(hex: 0xFFE082)
            public static let amber300 = UIColor(hex: 0xFFD54F)
            public static let amber400 = UIColor(hex: 0xFFCA28)
            public static let amber500 = UIColor(hex: 0xFFC107)
            public static let amber600 = UIColor(hex: 0xFFB300)
            public static let amber700 = UIColor(hex: 0xFFA000)
            public static let amber800 = UIColor(hex: 0xFF8F00)
            public static let amber900 = UIColor(hex: 0xFF6F00)
            public static let amberA100 = UIColor(hex: 0xFFE57F)
            public static let amberA200 = UIColor(hex: 0xFFD740)
            public static let amberA400 = UIColor(hex: 0xFFC400)
            public static let amberA700 = UIColor(hex: 0xFFAB00)

            public static let orange = orange500
            public static let orange50 = UIColor(hex: 0xFFF3E0)
            public static let orange100 = UIColor(hex: 0xFFE0B2)
            public static let orange200 = UIColor(hex: 0xFFCC80)
            public static let orange300 = UIColor(hex: 0xFFB74D)
            public static let orange400 = UIColor(hex: 0xFFA726)
            public static let orange500 = UIColor(hex: 0xFF9800)
            public static let orange600 = UIColor(hex: 0xFB8C00)
            public static let orange700 = UIColor(hex: 0xF57C00)
            public static let orange800 = UIColor(hex: 0xEF6C00)
            public static let orange900 = UIColor(hex: 0xE65100)
            public static let orangeA100 = UIColor(hex: 0xFFD180)
            public static let orangeA200 = UIColor(hex: 0xFFAB40)
            public static let orangeA400 = UIColor(hex: 0xFF9100)
            public static let orangeA700 = UIColor(hex: 0xFF6D00)

            public static let deepOrange = deepOrange500
            public static let deepOrange50 = UIColor(hex: 0xFBE9E7)
            public static let deepOrange100 = UIColor(hex: 0xFFCCBC)
            public static let deepOrange200 = UIColor(hex: 0xFFAB91)
            public static let deepOrange300 = UIColor(hex: 0xFF8A65)
            public static let deepOrange400 = UIColor(hex: 0xFF7043)
            public static let deepOrange500 = UIColor(hex: 0xFF5722)
            public static let deepOrange600 = UIColor(hex: 0xF4511E)
            public static let deepOrange700 = UIColor(hex: 0xE64A19)
            public static let deepOrange800 = UIColor(hex: 0xD84315)
            public static let deepOrange900 = UIColor(hex: 0xBF360C)
            public static let deepOrangeA100 = UIColor(hex: 0xFF9E80)
            public static let deepOrangeA200 = UIColor(hex: 0xFF6E40)
            public static let deepOrangeA400 = UIColor(hex: 0xFF3D00)
            public static let deepOrangeA700 = UIColor(hex: 0xDD2C00)

            public static let brown = brown500
            public static let brown50 = UIColor(hex: 0xEFEBE9)
            public static let brown100 = UIColor(hex: 0xD7CCC8)
            public static let brown200 = UIColor(hex: 0xBCAAA4)
            public static let brown300 = UIColor(hex: 0xA1887F)
            public static let brown400 = UIColor(hex: 0x8D6E63)
            public static let brown500 = UIColor(hex: 0x795548)
            public static let brown600 = UIColor(hex: 0x6D4C41)
            public static let brown700 = UIColor(hex: 0x5D4037)
            public static let brown800 = UIColor(hex: 0x4E342E)
            public static let brown900 = UIColor(hex: 0x3E2723)

            public static let grey = grey500
            public static let grey50 = UIColor(hex: 0xFAFAFA)
            public static let grey100 = UIColor(hex: 0xF5F5F5)
            public static let grey200 = UIColor(hex: 0xEEEEEE)
            public static let grey300 = UIColor(hex: 0xE0E0E0)
            public static let grey400 = UIColor(hex: 0xBDBDBD)
            public static let grey500 = UIColor(hex: 0x9E9E9E)
            public static let grey600 = UIColor(hex: 0x757575)
            public static let grey700 = UIColor(hex: 0x616161)
            public static let grey800 = UIColor(hex: 0x424242)
            public static let grey900 = UIColor(hex: 0x212121)

            public static let blueGrey = blueGrey500
            public static let blueGrey50 = UIColor(hex: 0xECEFF1)
            public static let blueGrey100 = UIColor(hex: 0xCFD8DC)
            public static let blueGrey200 = UIColor(hex: 0xB0BEC5)
            public static let blueGrey300 = UIColor(hex: 0x90A4AE)
            public static let blueGrey400 = UIColor(hex: 0x78909C)
            public static let blueGrey500 = UIColor(hex: 0x607D8B)
            public static let blueGrey600 = UIColor(hex: 0x546E7A)
            public static let blueGrey700 = UIColor(hex: 0x455A64)
            public static let blueGrey800 = UIColor(hex: 0x37474F)
            public static let blueGrey900 = UIColor(hex: 0x263238)

            public static let black = UIColor(hex: 0x000000)
            public static let white = UIColor(hex: 0xFFFFFF)
        }

    }

    public extension UIColor {

        /// SwifterSwift: CSS colors.
        public struct css {
            // http://www.w3schools.com/colors/colors_names.asp
            public static let aliceBlue = UIColor(hex: 0xF0F8FF)
            public static let antiqueWhite = UIColor(hex: 0xFAEBD7)
            public static let aqua = UIColor(hex: 0x00FFFF)
            public static let aquamarine = UIColor(hex: 0x7FFFD4)
            public static let azure = UIColor(hex: 0xF0FFFF)
            public static let beige = UIColor(hex: 0xF5F5DC)
            public static let bisque = UIColor(hex: 0xFFE4C4)
            public static let black = UIColor(hex: 0x000000)
            public static let blanchedAlmond = UIColor(hex: 0xFFEBCD)
            public static let blue = UIColor(hex: 0x0000FF)
            public static let blueViolet = UIColor(hex: 0x8A2BE2)
            public static let brown = UIColor(hex: 0xA52A2A)
            public static let burlyWood = UIColor(hex: 0xDEB887)
            public static let cadetBlue = UIColor(hex: 0x5F9EA0)
            public static let chartreuse = UIColor(hex: 0x7FFF00)
            public static let chocolate = UIColor(hex: 0xD2691E)
            public static let coral = UIColor(hex: 0xFF7F50)
            public static let cornflowerBlue = UIColor(hex: 0x6495ED)
            public static let cornsilk = UIColor(hex: 0xFFF8DC)
            public static let crimson = UIColor(hex: 0xDC143C)
            public static let cyan = UIColor(hex: 0x00FFFF)
            public static let darkBlue = UIColor(hex: 0x00008B)
            public static let darkCyan = UIColor(hex: 0x008B8B)
            public static let darkGoldenRod = UIColor(hex: 0xB8860B)
            public static let darkGray = UIColor(hex: 0xA9A9A9)
            public static let darkGrey = UIColor(hex: 0xA9A9A9)
            public static let darkGreen = UIColor(hex: 0x006400)
            public static let darkKhaki = UIColor(hex: 0xBDB76B)
            public static let darkMagenta = UIColor(hex: 0x8B008B)
            public static let darkOliveGreen = UIColor(hex: 0x556B2F)
            public static let darkOrange = UIColor(hex: 0xFF8C00)
            public static let darkOrchid = UIColor(hex: 0x9932CC)
            public static let darkRed = UIColor(hex: 0x8B0000)
            public static let darkSalmon = UIColor(hex: 0xE9967A)
            public static let darkSeaGreen = UIColor(hex: 0x8FBC8F)
            public static let darkSlateBlue = UIColor(hex: 0x483D8B)
            public static let darkSlateGray = UIColor(hex: 0x2F4F4F)
            public static let darkSlateGrey = UIColor(hex: 0x2F4F4F)
            public static let darkTurquoise = UIColor(hex: 0x00CED1)
            public static let darkViolet = UIColor(hex: 0x9400D3)
            public static let deepPink = UIColor(hex: 0xFF1493)
            public static let deepSkyBlue = UIColor(hex: 0x00BFFF)
            public static let dimGray = UIColor(hex: 0x696969)
            public static let dimGrey = UIColor(hex: 0x696969)
            public static let dodgerBlue = UIColor(hex: 0x1E90FF)
            public static let fireBrick = UIColor(hex: 0xB22222)
            public static let floralWhite = UIColor(hex: 0xFFFAF0)
            public static let forestGreen = UIColor(hex: 0x228B22)
            public static let fuchsia = UIColor(hex: 0xFF00FF)
            public static let gainsboro = UIColor(hex: 0xDCDCDC)
            public static let ghostWhite = UIColor(hex: 0xF8F8FF)
            public static let gold = UIColor(hex: 0xFFD700)
            public static let goldenRod = UIColor(hex: 0xDAA520)
            public static let gray = UIColor(hex: 0x808080)
            public static let grey = UIColor(hex: 0x808080)
            public static let green = UIColor(hex: 0x008000)
            public static let greenYellow = UIColor(hex: 0xADFF2F)
            public static let honeyDew = UIColor(hex: 0xF0FFF0)
            public static let hotPink = UIColor(hex: 0xFF69B4)
            public static let indianRed = UIColor(hex: 0xCD5C5C)
            public static let indigo = UIColor(hex: 0x4B0082)
            public static let ivory = UIColor(hex: 0xFFFFF0)
            public static let khaki = UIColor(hex: 0xF0E68C)
            public static let lavender = UIColor(hex: 0xE6E6FA)
            public static let lavenderBlush = UIColor(hex: 0xFFF0F5)
            public static let lawnGreen = UIColor(hex: 0x7CFC00)
            public static let lemonChiffon = UIColor(hex: 0xFFFACD)
            public static let lightBlue = UIColor(hex: 0xADD8E6)
            public static let lightCoral = UIColor(hex: 0xF08080)
            public static let lightCyan = UIColor(hex: 0xE0FFFF)
            public static let lightGoldenRodYellow = UIColor(hex: 0xFAFAD2)
            public static let lightGray = UIColor(hex: 0xD3D3D3)
            public static let lightGrey = UIColor(hex: 0xD3D3D3)
            public static let lightGreen = UIColor(hex: 0x90EE90)
            public static let lightPink = UIColor(hex: 0xFFB6C1)
            public static let lightSalmon = UIColor(hex: 0xFFA07A)
            public static let lightSeaGreen = UIColor(hex: 0x20B2AA)
            public static let lightSkyBlue = UIColor(hex: 0x87CEFA)
            public static let lightSlateGray = UIColor(hex: 0x778899)
            public static let lightSlateGrey = UIColor(hex: 0x778899)
            public static let lightSteelBlue = UIColor(hex: 0xB0C4DE)
            public static let lightYellow = UIColor(hex: 0xFFFFE0)
            public static let lime = UIColor(hex: 0x00FF00)
            public static let limeGreen = UIColor(hex: 0x32CD32)
            public static let linen = UIColor(hex: 0xFAF0E6)
            public static let magenta = UIColor(hex: 0xFF00FF)
            public static let maroon = UIColor(hex: 0x800000)
            public static let mediumAquaMarine = UIColor(hex: 0x66CDAA)
            public static let mediumBlue = UIColor(hex: 0x0000CD)
            public static let mediumOrchid = UIColor(hex: 0xBA55D3)
            public static let mediumPurple = UIColor(hex: 0x9370DB)
            public static let mediumSeaGreen = UIColor(hex: 0x3CB371)
            public static let mediumSlateBlue = UIColor(hex: 0x7B68EE)
            public static let mediumSpringGreen = UIColor(hex: 0x00FA9A)
            public static let mediumTurquoise = UIColor(hex: 0x48D1CC)
            public static let mediumVioletRed = UIColor(hex: 0xC71585)
            public static let midnightBlue = UIColor(hex: 0x191970)
            public static let mintCream = UIColor(hex: 0xF5FFFA)
            public static let mistyRose = UIColor(hex: 0xFFE4E1)
            public static let moccasin = UIColor(hex: 0xFFE4B5)
            public static let navajoWhite = UIColor(hex: 0xFFDEAD)
            public static let navy = UIColor(hex: 0x000080)
            public static let oldLace = UIColor(hex: 0xFDF5E6)
            public static let olive = UIColor(hex: 0x808000)
            public static let oliveDrab = UIColor(hex: 0x6B8E23)
            public static let orange = UIColor(hex: 0xFFA500)
            public static let orangeRed = UIColor(hex: 0xFF4500)
            public static let orchid = UIColor(hex: 0xDA70D6)
            public static let paleGoldenRod = UIColor(hex: 0xEEE8AA)
            public static let paleGreen = UIColor(hex: 0x98FB98)
            public static let paleTurquoise = UIColor(hex: 0xAFEEEE)
            public static let paleVioletRed = UIColor(hex: 0xDB7093)
            public static let papayaWhip = UIColor(hex: 0xFFEFD5)
            public static let peachPuff = UIColor(hex: 0xFFDAB9)
            public static let peru = UIColor(hex: 0xCD853F)
            public static let pink = UIColor(hex: 0xFFC0CB)
            public static let plum = UIColor(hex: 0xDDA0DD)
            public static let powderBlue = UIColor(hex: 0xB0E0E6)
            public static let purple = UIColor(hex: 0x800080)
            public static let rebeccaPurple = UIColor(hex: 0x663399)
            public static let red = UIColor(hex: 0xFF0000)
            public static let rosyBrown = UIColor(hex: 0xBC8F8F)
            public static let royalBlue = UIColor(hex: 0x4169E1)
            public static let saddleBrown = UIColor(hex: 0x8B4513)
            public static let salmon = UIColor(hex: 0xFA8072)
            public static let sandyBrown = UIColor(hex: 0xF4A460)
            public static let seaGreen = UIColor(hex: 0x2E8B57)
            public static let seaShell = UIColor(hex: 0xFFF5EE)
            public static let sienna = UIColor(hex: 0xA0522D)
            public static let silver = UIColor(hex: 0xC0C0C0)
            public static let skyBlue = UIColor(hex: 0x87CEEB)
            public static let slateBlue = UIColor(hex: 0x6A5ACD)
            public static let slateGray = UIColor(hex: 0x708090)
            public static let slateGrey = UIColor(hex: 0x708090)
            public static let snow = UIColor(hex: 0xFFFAFA)
            public static let springGreen = UIColor(hex: 0x00FF7F)
            public static let steelBlue = UIColor(hex: 0x4682B4)
            public static let tan = UIColor(hex: 0xD2B48C)
            public static let teal = UIColor(hex: 0x008080)
            public static let thistle = UIColor(hex: 0xD8BFD8)
            public static let tomato = UIColor(hex: 0xFF6347)
            public static let turquoise = UIColor(hex: 0x40E0D0)
            public static let violet = UIColor(hex: 0xEE82EE)
            public static let wheat = UIColor(hex: 0xF5DEB3)
            public static let white = UIColor(hex: 0xFFFFFF)
            public static let whiteSmoke = UIColor(hex: 0xF5F5F5)
            public static let yellow = UIColor(hex: 0xFFFF00)
            public static let yellowGreen = UIColor(hex: 0x9ACD32)

        }

    }
#endif
