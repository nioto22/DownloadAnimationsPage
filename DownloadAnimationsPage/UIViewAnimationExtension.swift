//
//  UIViewAnimationExtension.swift
//  DownloadAnimationsPage
//
//  Created by Antoine Proux on 18/11/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func scaleWithFactorOfSize(duration: Double, delay: Double, factor: CGFloat){
        UIView.animate(withDuration: duration, delay: delay, animations: {
            self.transform = CGAffineTransform(scaleX: 1 * factor, y: 1 * factor)
        })
    }
}
