//
//  Alert.swift
//  Passioneurs
//
//  Created by Sherif Darwish on 1/18/20.
//  Copyright © 2020 Sherif Darwish. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift

extension UIViewController {
    func showAlert(title : String , message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    func showToast(_ msg: String){
        self.view.makeToast(msg, duration: 2, position: .bottom)
    }
}
