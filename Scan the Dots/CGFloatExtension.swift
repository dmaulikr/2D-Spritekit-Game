//
//  CGFloatExtension.swift
//  Scan the Dots
//
//  Created by Tassilo Lechner von Leheneck on 31/10/15.
//  Copyright © 2015 Tassilo Lechner von Leheneck. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat{
    
    public static func random() -> CGFloat {
        
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        
    }
    
    public static func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        
        return CGFloat.random() * (max-min) + min
    }
}
