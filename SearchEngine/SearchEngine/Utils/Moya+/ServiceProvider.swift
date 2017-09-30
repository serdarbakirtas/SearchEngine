import Foundation
import Moya
import Vendors
import SwiftyJSON

// we overriding Moya default logger whic is not good for printing formatted json data
private func reversedPrint(seperator _: String, terminator _: String, items: Any...) {
    for item in items {
        print("")
        print(item)
        print("")
    }
}

// json plugin should print properly formatted network data.We using SwiftyJSON abilities for this purpose
public let jsonLogger = NetworkLoggerPlugin(verbose: true, cURL: false, output: reversedPrint) {
    data in
    let json = JSON(data: data)
    return json.debugDescription.data(using: .utf8) ?? data
}

// Helper function aimed to reduce bloating of Moya service declerations, also ease shared plugin and header code duplications.
public func newProvider<ServiceType>(headers: @escaping () -> [String: String], plugins: [PluginType] = [jsonLogger], requestClosure: MoyaProvider<ServiceType>.RequestClosure? = nil) -> MoyaProvider<ServiceType> {
    let authenticatedEndpointClosure = { (target: ServiceType) -> Endpoint<ServiceType> in
        
        let path:String = "\(target.baseURL.absoluteString)\(target.path)"
        let defaultEndpoint: Endpoint<ServiceType> = Endpoint(
            // workaround to Moya weird behaviour of escaping question mark in path
            url: path,
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers ?? headers()
        )
        
        return defaultEndpoint.adding(newHTTPHeaderFields: headers())
    }
    
    return MoyaProvider<ServiceType>(
        endpointClosure: authenticatedEndpointClosure,
        requestClosure: requestClosure ?? MoyaProvider.defaultRequestMapping,
        stubClosure: MoyaProvider.neverStub,
        manager: MoyaProvider<ServiceType>.defaultAlamofireManager(),
        plugins: plugins
    )
}
