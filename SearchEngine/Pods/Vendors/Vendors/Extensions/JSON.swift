//
//  JSON.swift
//  Pods
//
//  Created by ALI KIRAN on 3/3/17.
//
//

//  MAHALLEMKULLANICI
//
//  Created by ALI KIRAN on 3/3/17.
//  Copyright © 2017 Ali KIRAN. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

extension JSON {
    public var date: Date? {
        if let str = self.string {
            return DateFormatter.date(from: str)
        }
        
        return nil
    }
}
