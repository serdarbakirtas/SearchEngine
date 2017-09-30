//
//  DataRequest.swift
//  Pods
//
//  Created by away4m on 12/31/16.
//
//

//
//  Alamofire-SwiftyJSON.swift
//
//  Created by away4m on 1/2/17.
//
import Alamofire
import Foundation
import SwiftyJSON

enum VendorsServiceError: Error {
    case inputDataNil(data: JSON)
    case inputDataNilOrZeroLength(data: JSON)
    case inputFileNil(data: JSON)
    case inputFileReadFailed(data: JSON)
    case InvalidCall(data: JSON)
}

extension Request {
    /// Returns a JSON object contained in a result type constructed from the response data using `JSONSerialization`
    /// with the specified reading options.
    ///
    /// - parameter options:  The JSON serialization reading options. Defaults to `.allowFragments`.
    /// - parameter response: The response from the server.
    /// - parameter data:     The data returned from the server.
    /// - parameter error:    The error already encountered if it exists.
    ///
    /// - returns: The result data type.
    public static func swiftyJSON(
        options: JSONSerialization.ReadingOptions,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?
    )
        -> Result<Any> {
        guard error == nil else { return .failure(error!) }

        // empty status codes
        if let response = response, [204, 205].contains(response.statusCode) { return .success(JSON(["statusCode": response.statusCode])) }

        guard let validData = data, validData.count > 0 else {
            return .failure(VendorsServiceError.InvalidCall(data: JSON([:])))
        }

        var json = JSON(data: validData, options: options)

        if json.dictionaryValue.count == 0 {
            if json.arrayValue.count > 0 {
                json = JSON([
                    "_": json.arrayObject!
                ])

            } else {
                var convertedEncoding = String.Encoding.isoLatin1

                if let encodingName = response?.textEncodingName as CFString! {
                    convertedEncoding = String.Encoding(
                        rawValue: CFStringConvertEncodingToNSStringEncoding(
                            CFStringConvertIANACharSetNameToEncoding(encodingName)
                        )
                    )
                }

                let actualEncoding = convertedEncoding

                if let string = String(data: validData, encoding: actualEncoding) {
                    return .failure(VendorsServiceError.InvalidCall(data: JSON(["_": string])))
                } else {
                    return .failure(VendorsServiceError.InvalidCall(data: JSON([:])))
                }
            }
        }

        json["statusCode"].int = response != nil ? response!.statusCode : -1

        trace("************************* SERVICE RESULT ****************************")
        trace(json)
        trace()

        return .success(json)
    }
}

extension DataRequest {
    /// Creates a response serializer that returns a JSON object result type constructed from the response data using
    /// `JSONSerialization` with the specified reading options.
    ///
    /// - parameter options: The JSON serialization reading options. Defaults to `.allowFragments`.
    ///
    /// - returns: A JSON object response serializer.
    public static func swiftyJSONResponseSerializer(
        options: JSONSerialization.ReadingOptions = .allowFragments
    )
        -> DataResponseSerializer<Any> {
        return DataResponseSerializer { _, response, data, error in
            Request.swiftyJSON(options: options, response: response, data: data, error: error)
        }
    }

    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter options:           The JSON serialization reading options. Defaults to `.allowFragments`.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseJSON(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DataResponse<Any>) -> Void
    )
        -> Self {
        return response(
            queue: queue,
            responseSerializer: DataRequest.swiftyJSONResponseSerializer(options: options),
            completionHandler: completionHandler
        )
    }
}

extension DownloadRequest {
    /// Creates a response serializer that returns a JSON object result type constructed from the response data using
    /// `JSONSerialization` with the specified reading options.
    ///
    /// - parameter options: The JSON serialization reading options. Defaults to `.allowFragments`.
    ///
    /// - returns: A JSON object response serializer.
    public static func swiftyJSONResponseSerializer(
        options: JSONSerialization.ReadingOptions = .allowFragments
    )
        -> DownloadResponseSerializer<Any> {
        return DownloadResponseSerializer { _, response, fileURL, error in
            guard error == nil else { return .failure(error!) }
            guard let fileURL = fileURL else {
                return .failure(VendorsServiceError.inputFileNil(data: JSON(["statusCode": response != nil ? response!.statusCode : -1])))
            }

            do {
                let data = try Data(contentsOf: fileURL)
                return Request.swiftyJSON(options: options, response: response, data: data, error: error)
            } catch {
                return .failure(VendorsServiceError.inputFileReadFailed(data: JSON(["fileURL": fileURL, "statusCode": response != nil ? response!.statusCode : -1])))
            }
        }
    }

    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter options:           The JSON serialization reading options. Defaults to `.allowFragments`.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseJSON(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DownloadResponse<Any>) -> Void
    )
        -> Self {
        return response(
            queue: queue,
            responseSerializer: DownloadRequest.swiftyJSONResponseSerializer(options: options),
            completionHandler: completionHandler
        )
    }
}
