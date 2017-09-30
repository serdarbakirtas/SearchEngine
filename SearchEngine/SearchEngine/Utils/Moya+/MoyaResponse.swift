import Foundation
import Moya
import SwiftyJSON


public extension Notification.Name {
    static let API_RESPONSE = Notification.Name("API_RESPONSE")
}


public extension Moya.Response {
    public func asJSONValue() -> JSON {
        return JSON(data: data)
    }

    @discardableResult
    public func asJSON(alertOnError: Bool = true) -> JSON {
        var json = JSON(data: data)
        if json == JSON.null {
            json = [:]
        }

        guard self.statusCode == 200 else {
            json = json.guestServerError(alertOnError: alertOnError, statusCode: self.statusCode)
            return json
        }

        NotificationCenter.default.post(name: NSNotification.Name.API_RESPONSE, object: self, userInfo: ["json": json, "statusCode": self.statusCode])
        return json
    }

    /*public func mapBridgeJSON() -> JSONBridge {
        return JSONBridge(asJSONValue())
    }*/

    @discardableResult
    public func guestServerError(alertOnError: Bool = false) -> JSON {
        var json = JSON(data: data)
        if json == JSON.null {
            json = [:]
        }

        return json.guestServerError(alertOnError: alertOnError, statusCode: self.statusCode)
    }
}

extension JSON {
    public func guestServerError(alertOnError: Bool, statusCode: Int, messageFriendlyKey: String = "messageFriendly", messageKey: String = "message") -> JSON {
        var json = self
        if(json["code"].int == nil) {
            json = ["code": -1, "data": json, messageKey: "Server.Error.\(statusCode)", messageFriendlyKey: "Sunucu hata kodu: \(statusCode)"]
        }
        json["statusCode"].int = statusCode

        if alertOnError {
            UIAlertController.alert(message: json[messageFriendlyKey].string ?? "Geçersiz işlem.", handler: { (action) in

            }).present()
        }

        NotificationCenter.default.post(name: NSNotification.Name.API_RESPONSE, object: self, userInfo: ["json": json, "statusCode": statusCode])

        return json
    }
}
