//
//  Utilities.swift
//  SwiftyGit
//
//  Created by Tushar on 28/05/24.
//


import Foundation
import UIKit

func showErrorAlert(on viewController: UIViewController, message: String) {
    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    viewController.present(alert, animated: true, completion: nil)
}
