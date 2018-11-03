//
//  AlertManager.swift
//  ManagerForAPI
//
//  Created by Гоша Бодров on 27.10.2018.
//  Copyright © 2018 Гоша Бодров. All rights reserved.
//

import Foundation
import UIKit

class AlertManager {
    func creatAlert(title: String, error: NSError) -> UIAlertController {


        let alertController = UIAlertController(title: title, message: "\(error.localizedDescription)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        return alertController
    }
}
