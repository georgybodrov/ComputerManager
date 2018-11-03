//
//  APIComputerManager.swift
//  ManagerForAPI
//
//  Created by Гоша Бодров on 25.09.2018.
//  Copyright © 2018 Гоша Бодров. All rights reserved.
//

import Foundation
import UIKit

struct ComputerID {
    let id: Int
}

enum ForecastType: FinalURLPoint {
    case Current(computerID: ComputerID)
    
    var baseURL: URL {
        return URL(string: "http://testwork.nsd.naumen.ru")!
    }
    
    var path: String {
        switch self {
        case .Current(let computerID):
            return "/rest/computers/\(computerID.id)"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)
        return URLRequest(url: url!)
    }
}



final class APIComputerManager: APIManager {
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
    
    func fetchCurrentComputerWith(computerID: ComputerID, completionHandler: @escaping (APIResult<CurrentComputer>) -> Void) {
        let request = ForecastType.Current(computerID: computerID).request
        
        print("request for CurrentComputer = \(request)")
        
        fetch(request: request, parse: { (json) -> CurrentComputer? in            
            return CurrentComputer.init(JSON: json)
        }, completionHandler: completionHandler)
    }
}
 
