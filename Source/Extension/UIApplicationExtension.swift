//
//  UIApplicationExtension.swift
//  Billiyo Clinical
//
//  Created by Billiyo Health on 09/08/21.
//

import Foundation
import UIKit


extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.last?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }

    
}
