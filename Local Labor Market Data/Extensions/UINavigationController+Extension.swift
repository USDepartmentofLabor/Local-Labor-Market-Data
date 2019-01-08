//
//  UINavigationController+Extension.swift
//  Local Labor Market Data
//
//  Created by Nidhi Chawla on 1/8/19.
//  Copyright © 2019 Department of Labor. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    func replaceTopViewController(with viewController: UIViewController, animated: Bool) {
        var vcs = viewControllers
        vcs[vcs.count - 1] = viewController
        setViewControllers(vcs, animated: animated)
    }
    
}
