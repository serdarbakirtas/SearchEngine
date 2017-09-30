//
//  URL.swift
//  Pods
//
//  Created by away4m on 12/31/16.
//
//

import Foundation

public extension URL {
    /// SwifterSwift: URL with appending query parameters.
    ///
    /// - Parameter parameters: parameters dictionary.
    /// - Returns: URL with appending given query parameters.
    public func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        var items = urlComponents.queryItems ?? []
        items += parameters.map({ URLQueryItem(name: $0, value: $1) })
        urlComponents.queryItems = items
        return urlComponents.url!
    }

    /// SwifterSwift: Append query parameters to URL.
    ///
    /// - Parameter parameters: parameters dictionary.
    public mutating func appendQueryParameters(_ parameters: [String: String]) {
        self = self.appendingQueryParameters(parameters)
    }

    /// Creates a URL initialized to the given string value.
    public init(stringLiteral value: StringLiteralType) {
        guard let url = URL(string: value) else { fatalError("Could not create URL from: \(value)") }
        self = url
    }

    /// Creates a URL initialized to the given value.
    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        guard let url = URL(string: value) else { fatalError("Could not create URL from: \(value)") }
        self = url
    }

    /// Creates a URL initialized to the given value.
    public init(unicodeScalarLiteral value: StringLiteralType) {
        guard let url = URL(string: value) else { fatalError("Could not create URL from: \(value)") }
        self = url
    }

    public func httpsURL() -> URL {

        guard scheme != "https" else {
            return self
        }

        let str = absoluteString.replacingOccurrences(of: "http://", with: "https://")

        return URL(string: str)!
    }
}

/**
 Append a path component to a url. Equivalent to `lhs.appendingPathComponent(rhs)`.

 - parameter lhs: The url.
 - parameter rhs: The path component to append.
 - returns: The original url with the appended path component.
 */
public func +(lhs: URL, rhs: String) -> URL {
    return lhs.appendingPathComponent(rhs)
}
