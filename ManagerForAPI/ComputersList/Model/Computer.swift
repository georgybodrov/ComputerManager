//
//  Computer.swift
//  ManagerForAPI
//
//  Created by Гоша Бодров on 22.10.2018.
//  Copyright © 2018 Гоша Бодров. All rights reserved.
//

import Foundation


struct Computer: Decodable{
    var id: Int
    var name: String
    var company: Company?
}

extension Computer {
    init?(items: [String: Any]){
        guard let id = items["id"] as? Int else { return nil }
        guard let name = items["name"] as? String else {return nil }
        
        if let company = items["company"] as? [String: Any]{
            self.company = Company.init(company: company)
        }
        self.id = id
        self.name = name
    }
    
}
