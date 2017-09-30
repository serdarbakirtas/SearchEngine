//
//  BandService.swift
//  BlacklaneChallenge
//
//  Created by Hasan Bakirtas on 30/09/2017.
//  Copyright © 2017 Hasan Serdar Bakirtas. All rights reserved.
//

import Foundation
import Moya

enum BandService {
    case band(band_id: Int)
}

extension BandService: TargetType {
    var method: Moya.Method {
        switch self {

        case .band:
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String: String]? {
        return nil
    }

    var path: String {
        switch self {

        case let .band(band_id):
            return "/band/\(band_id)?api_key=1a151db1-f4ca-4677-8433-567b4414d74e"
        }
    }
}
