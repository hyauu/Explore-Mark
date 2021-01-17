//
//  UIViewController+Extension.swift
//  Explore&Mark
//
//  Created by 邱浩庭 on 16/1/2021.
//

import Foundation
import UIKit

// Extend UIViewControoler to check if the viewController is presented modally
extension UIViewController {

    var isModal: Bool {
        return self.presentingViewController?.presentedViewController == self
            || (self.navigationController != nil && self.navigationController?.presentingViewController?.presentedViewController == self.navigationController)
            || self.tabBarController?.presentingViewController is UITabBarController
    }
}
