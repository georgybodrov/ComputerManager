//
//  DataAboutComputers.swift
//  ManagerForAPI
//
//  Created by Гоша Бодров on 04.10.2018.
//  Copyright © 2018 Гоша Бодров. All rights reserved.
//

import Foundation

struct DataAboutComputers: Decodable {
    var items: [Computer]
    var page: Int
    var offset: Int
    var total: Int
}

extension DataAboutComputers: JSONDecodable {
    init?(JSON: [String: Any]){
        guard let page = JSON["page"] as? Int else { return nil }
        guard let offset = JSON["offset"] as? Int else { return nil }
        guard let total = JSON["total"] as? Int else { return nil }
        guard let items = JSON["items"] as? [[String: Any]] else { return nil }
        
        var computersForParsing: [Computer] = []
        for item in items {
            if let currentComputer = Computer.init(items: item) {
                computersForParsing.append(currentComputer)
            }
        }
        self.page = page
        self.offset = offset
        self.total = total
        self.items = computersForParsing
    }
}






