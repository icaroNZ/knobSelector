//
//  UIViewExtension.swift
//  RotaryWheel
//
//  Created by Icaro Lavrador on 3/06/19.
//  Copyright © 2019 Icaro Lavrador. All rights reserved.
//

import UIKit

extension UIView {
        var allSubViews : [UIView] {
            
            var array = [self.subviews].flatMap {$0}
            
            array.forEach { array.append(contentsOf: $0.allSubViews) }
            
            return array
        }
}
