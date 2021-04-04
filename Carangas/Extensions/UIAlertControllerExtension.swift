//
//  UIAlertControllerExtension.swift
//  Carangas
//
//  Created by Robson Nunes de Souza on 02/04/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import UIKit


extension UIAlertController {
    
    @discardableResult
    static func showAlert(title: String, message: String, cancelButtonTitle: String, confirmationButtonTitle: String? = nil, dissmissBlock: (()-> Void)? = nil , cancelBlock: (()-> Void)? = nil) -> UIAlertController {
    
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        // Cancel Button
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
            cancelBlock?()
        }))
        // Confirmation button
        if let title = confirmationButtonTitle {
            alert.addAction(UIAlertAction(title: title, style: UIAlertAction.Style.default, handler: { (action) -> Void in
                dissmissBlock?()
            }))
        }
        
        alert.show()
        
        return alert
    }
    
    @discardableResult
    static func showAlert(withTitle title: String, withMessage message:String) -> UIAlertController  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
        })
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            alert.show()
        })
        return alert
    }
    
    func show() {
        if let topViewController = UIApplication.shared.keyWindow?.topViewController() {
            topViewController.present(self, animated: true, completion: nil)
        }
    }
}
