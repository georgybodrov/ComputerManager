//
//  DataAboutSimilarComputer.swift
//  ManagerForAPI
//
//  Created by Гоша Бодров on 11.10.2018.
//  Copyright © 2018 Гоша Бодров. All rights reserved.
//

import Foundation



struct SimilarComputer: Decodable {
    var id: Int
    var name: String
}

//extension SimilarComputer {
//    init?(JSON: [String : Any]) {
//        print("start parsing SimilarComputer")
//        guard let id = JSON["id"] as? Int else { return nil }
//        guard let name = JSON["name"] as? String else { return nil }
//        print("---------")
//        print(id)
//        print(name)
//        print("---------")
//        self.id = id
//        self.name = name
//    }
//}

