//
//  UIWindowExtension.swift
//  Carangas
//
//  Created by Robson Nunes de Souza on 02/04/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import UIKit

public extension UIWindow {
    
    func topViewController() -> UIViewController? {
        
        var topController = self.rootViewController
        
        while let viewController = topController?.presentedViewController {
            topController = viewController
        }
        return topController;
    }
}
