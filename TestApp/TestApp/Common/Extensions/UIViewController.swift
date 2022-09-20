//
//  UIViewController.swift
//  TestApp
//
//  Created by Kate on 20.09.2022.
//

import UIKit

extension UIViewController {
    func createAlert(title: String, message: String, buttonTitle: String, buttonHandler: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertButton = UIAlertAction(title: buttonTitle, style: .default, handler: buttonHandler)
        alert.addAction(alertButton)

        return alert
    }
}
