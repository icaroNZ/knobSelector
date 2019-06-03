//
//  CGFloat_Extension.swift
//  RotaryWheel
//
//  Created by Icaro Lavrador on 2/06/19.
//  Copyright © 2019 Icaro Lavrador. All rights reserved.
//

import UIKit


extension CGFloat {
    
    var degrees:CGFloat {
        return self * 180 / .pi;
    }
    var radians:CGFloat {
        return self * .pi / 180;
    }
    var rad2deg:CGFloat {
        return self.degrees
    }
    var deg2rad:CGFloat {
        return self.radians
    }
    
}
