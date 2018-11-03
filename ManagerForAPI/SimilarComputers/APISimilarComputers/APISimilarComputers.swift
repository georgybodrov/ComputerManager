//
//  APISimilarComputers.swift
//  ManagerForAPI
//
//  Created by Гоша Бодров on 11.10.2018.
//  Copyright © 2018 Гоша Бодров. All rights reserved.
//

import Foundation
/*
struct SimilarForIdComputer {
    let id: Int
}

enum ForecastTypeForSimilarComputer: FinalURLPoint {
    case Current(SimilarForIdComputer: SimilarForIdComputer)
    
    var baseURL: URL {
        return URL(string: "http://testwork.nsd.naumen.ru")!
    }
    
    var path: String {
        switch self {
        case .Current(let SimilarForIdComputer):
            return "/rest/computers/\(SimilarForIdComputer.id)/similar"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)
        return URLRequest(url: url!)
    }
}



final class APISimilarComputers: APIManagerForSimilarComputer {
    var sessionConfiguration: URLSessionConfiguration
    
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    } ()
    
    init(sessionConfiguration: URLSessionConfiguration) {
        self.sessionConfiguration = sessionConfiguration
    }
    
    convenience init() {
        self.init(sessionConfiguration: URLSessionConfiguration.default)
    }
    
    func fetchAPISimilarComputersWith(SimilarForIdComputer: SimilarForIdComputer, completionHandler: @escaping (APIResult<SimilarComputer>) -> Void) {
        let request = ForecastTypeForSimilarComputer.Current(SimilarForIdComputer: SimilarForIdComputer).request
        
        print("request for ComputersList = \(request)")
        fetch(request: request, parse: { (json) -> SimilarComputer? in
            return SimilarComputer.init(JSON: json)
        }, completionHandler: completionHandler)
    }
}
*/
