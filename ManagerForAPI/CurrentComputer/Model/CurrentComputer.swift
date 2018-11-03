//
//  CurrentComputer.swift
//  ManagerForAPI
//
//  Created by Гоша Бодров on 25.09.2018.
//  Copyright © 2018 Гоша Бодров. All rights reserved.
//

/*
 Какие данные мы хотим получить
 */

import Foundation
import UIKit.UIImage //В данном случаем импортируем только для UIImage

struct CurrentComputer {
    var id: Int
    var name: String
    var introduced: String?
    var discounted: String?
    var imageUrl: String?
    var company: DetailCompany?
    var description: String?
}

extension CurrentComputer: JSONDecodable {
    init?(JSON: [String : Any]) {
        guard let id = JSON["id"] as? Int else { return nil }
        guard let name = JSON["name"] as? String else { return nil }
        self.introduced = JSON["introduced"] as? String
        self.discounted = JSON["discounted"] as? String
        self.imageUrl = JSON["imageUrl"] as? String
        self.description = JSON["description"] as? String
        if let company = JSON["company"] as? [String: Any]{
            self.company = DetailCompany.init(company: company)
        }
        
        self.id = id
        self.name = name
    }
}


