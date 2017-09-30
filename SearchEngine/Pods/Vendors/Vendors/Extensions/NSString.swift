//
// Created by SERDAR YILLAR on 08/03/2017.
//

import Foundation

extension NSString {
    public func labelHeightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        return (self as String).labelHeightWithConstrainedWidth(width, font: font)
    }
    
    public func labelWidthWithConstrainedHeight(_ width: CGFloat, font: UIFont) -> CGFloat {
        return (self as String).labelHeightWithConstrainedWidth(width, font: font)
    }
    
    public var date:Date{
      return  Date(fromString: self as String, format: DateFormat.iso8601(ISO8601Format.dateTimeMilliSec))
    }
}
