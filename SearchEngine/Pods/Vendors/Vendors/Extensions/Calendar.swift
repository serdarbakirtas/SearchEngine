//
//  Calendar.swift
//  Pods
//
//  Created by away4m on 12/30/16.
//
//

import Foundation

public extension Calendar {

    public static var gregorian: Calendar { return Calendar(identifier: Calendar.Identifier.gregorian) }
    public static var buddhist: Calendar { return Calendar(identifier: Calendar.Identifier.buddhist) }
    public static var chinese: Calendar { return Calendar(identifier: Calendar.Identifier.chinese) }
    public static var coptic: Calendar { return Calendar(identifier: Calendar.Identifier.coptic) }
    public static var ethiopicAmeteMihret: Calendar { return Calendar(identifier: Calendar.Identifier.ethiopicAmeteMihret) }
    public static var ethiopicAmeteAlem: Calendar { return Calendar(identifier: Calendar.Identifier.ethiopicAmeteAlem) }
    public static var hebrew: Calendar { return Calendar(identifier: Calendar.Identifier.hebrew) }
    public static var iso8601: Calendar { return Calendar(identifier: Calendar.Identifier.iso8601) }
    public static var indian: Calendar { return Calendar(identifier: Calendar.Identifier.indian) }
    public static var islamic: Calendar { return Calendar(identifier: Calendar.Identifier.islamic) }
    public static var islamicCivil: Calendar { return Calendar(identifier: Calendar.Identifier.islamicCivil) }
    public static var japanese: Calendar { return Calendar(identifier: Calendar.Identifier.japanese) }
    public static var persian: Calendar { return Calendar(identifier: Calendar.Identifier.persian) }
    public static var republicOfChina: Calendar { return Calendar(identifier: Calendar.Identifier.republicOfChina) }
}
