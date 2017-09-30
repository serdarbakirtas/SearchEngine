import Foundation
import Moya
import Vendors
import SwiftyJSON

//We don't like repeating code and declare baseURL again and again.Shared global domain idea make possible of one definition to rule them all.
//If one of service need different domain, service should adopt DomainMappable protocol and override global one.
public var moyaSharedDomain = GlobalServiceDomain()

public struct GlobalServiceDomain {
    public var baseURL: URL = URL(string: "http://localhost/api")!
    
    public func specializedBaseURL(target: TargetType) -> URL {
        guard let specializedTarget = target as? DomainMappable else {
            return baseURL
        }
        
        return specializedTarget.specializedURL
    }
}

extension TargetType {
    public var baseURL: URL {
        return
            moyaSharedDomain.specializedBaseURL(target: self)
    }
}

public protocol DomainMappable {
    var specializedURL: URL { get }
}
