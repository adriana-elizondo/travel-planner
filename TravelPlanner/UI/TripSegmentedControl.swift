//
//  TripSegmentedControl.swift
//  TravelPlanner
//
//  Created by Adriana Elizondo on 10/25/16.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import UIKit

class TripSegmentedControl: UISegmentedControl {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        self.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white], for: .normal)
    }
}
