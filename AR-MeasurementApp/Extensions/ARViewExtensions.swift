//
//  ARViewExtensions.swift
//  AR-MeasurementApp
//
//  Created by Juan Villa on 12/5/23.
//

import Foundation
import ARKit
import RealityKit

extension ARView {
    
    func addCoachingOverlay() {
        
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = self.session
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.setActive(true, animated: true)
        self.addSubview(coachingOverlay)
        
    }
    
}
