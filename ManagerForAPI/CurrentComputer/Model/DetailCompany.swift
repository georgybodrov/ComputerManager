//
//  DetailCompany.swift
//  ManagerForAPI
//
//  Created by Гоша Бодров on 22.10.2018.
//  Copyright © 2018 Гоша Бодров. All rights reserved.
//

import Foundation

struct DetailCompany: Decodable {
    var id: Int
    var name: String
}

extension DetailCompany{
    init?(company: [String: Any]){
        guard let id = company["id"] as? Int else { return nil }
        guard let name = company["name"] as? String else {return nil }
        
        self.id = id
        self.name = name
    }
}
