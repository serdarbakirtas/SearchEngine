//
//  SearchService.swift
//  SearchEngine
//
//  Created by Hasan Bakirtas on 30/09/2017.
//  Copyright © 2017 Hasan Serdar Bakirtas. All rights reserved.
//

import Foundation
import Moya

enum SearchType: String {
    case band = "album_title"
}

enum SearchService {
    case band(type: SearchType, word: String)
}


extension SearchService: TargetType {
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

    //var baseURL: URL { return URL(string: AppConfig.backend)! }

    var path: String {
        switch self {

        case let .band(type, word):
            return "/search/\(type.rawValue)/\(word)?api_key=1a151db1-f4ca-4677-8433-567b4414d74e"
        }
    }
}
