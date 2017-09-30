//
//  SignedInteger.swift
//  Pods
//
//  Created by away4m on 1/2/17.
//
//

import Foundation

extension SignedInteger{

    /**
     Returns a random number between min..<max.

     - parameters:
     - min: lower bound
     - max: upper bound. Must be > 0

     - Returns:
     Will return 'min' if:
     - 'min' == 'max', since there is no intermediate values
     - 'max - min' > Int32.max, since this value cannot be stored in a SignedInteger
     - 'max - min' <= 1, since arc4random_uniform will return 0 given this input

     Else returns a random number between min..<max.
     */
    static func random(min: Self = 0, max: Self = numericCast(Int32.max)) -> Self {
        guard min != max else {
            return min
        }

        // In the case where 'min' is negative we need to make sure that the 'upperBound'
        // variable below won't contain a value larger than a SignedInteger can hold
        guard (max.toIntMax() - min.toIntMax()) <= Int.max.toIntMax() else {
            return min
        }

        let upperBound = (max - min)
        guard upperBound > 0 else {
            // ar4random_uniform is only callable with UInt and only up to UInt32.max
            return min
        }

        // numericCast converts generically between different integer types.
        return numericCast(Darwin.arc4random_uniform(numericCast(upperBound))) + min
    }


}
