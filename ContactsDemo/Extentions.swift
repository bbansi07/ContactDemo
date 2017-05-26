//
//  Extentions.swift
//  ContactsDemo
//
//  Created by Zeitech Solutions on 26/05/17.
//
//

import Foundation
import UIKit

extension UIViewController {
    /**
     * Shows a default alert/info message with an OK button.
     */
    func showAlertMessage(_ message: String, okButtonTitle: String = "OK") -> Void {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okButtonTitle, style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension String {
    
    func isEmail() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]+$", options: NSRegularExpression.Options.caseInsensitive)
            return regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.characters.count)) != nil
        } catch { return false }
    }
    
}
