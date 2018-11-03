//
//  APIComputersListManager.swift
//  ManagerForAPI
//
//  Created by Гоша Бодров on 01.10.2018.
//  Copyright © 2018 Гоша Бодров. All rights reserved.
//

import Foundation

struct ComputerListID {
    let id: Int
}

enum ForecastTypeForComputersList: FinalURLPoint {
    case Current(ComputerListID: ComputerListID)
    
    var baseURL: URL {
        return URL(string: "http://testwork.nsd.naumen.ru")!
    }
    
    var path: String {
        switch self {
        case .Current(let ComputerListID):
            return "/rest/computers?p=\(ComputerListID.id)"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)
        return URLRequest(url: url!)
    }
}



final class APIComputersListManager: APIManager {
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
    
    func fetchAPIComputersListManagerWith(ComputerListID: ComputerListID, completionHandler: @escaping (APIResult<DataAboutComputers>) -> Void) {
        let request = ForecastTypeForComputersList.Current(ComputerListID: ComputerListID).request
        
        print("request for ComputersList = \(request)")
        
        fetch(request: request, parse: { (json) -> DataAboutComputers? in
                return DataAboutComputers.init(JSON: json)
        }, completionHandler: completionHandler)
    }
}
