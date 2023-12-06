//
//  Coordinator.swift
//  AR-MeasurementApp
//
//  Created by Juan Villa on 12/5/23.
//

import Foundation
import RealityKit
import SwiftUI

class Coordinator {
    
    
    
    var arView: ARView?
    var startAnchor: AnchorEntity?
    var endAnchor: AnchorEntity?
    
    
    lazy var measurementButton: UIButton = {
        
        let button = UIButton(configuration: .filled())
        button.setTitle("0.00", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        return button
        
    }()
    
    lazy var resetButton: UIButton = {
        
        let button = UIButton(configuration: .gray(), primaryAction: UIAction(handler: { [weak self] action in
                
            guard let arView = self?.arView else { return }
            self?.startAnchor = nil
            self?.endAnchor = nil
            
            arView.scene.anchors.removeAll()
            self?.measurementButton.setTitle("0.00", for: .normal)
            
            
        }))
                              
        button.setTitle("Reset", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
        
    }()
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        
        guard let arView = arView else { return }
        let tapLocation = recognizer.location(in: arView)
        
        let results = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
        if let result = results.first {
            
            if startAnchor == nil {
                
                startAnchor = AnchorEntity(raycastResult: result)
                let box = ModelEntity(mesh: MeshResource.generateBox(size: 0.1), materials: [SimpleMaterial(color: .black, isMetallic: true)])
                
                startAnchor?.addChild(box)
                
                guard let startAnchor = startAnchor else { return }
                
                arView.scene.addAnchor(startAnchor)
                
            } else if endAnchor == nil {
                
                endAnchor = AnchorEntity(raycastResult: result)
                let box = ModelEntity(mesh: MeshResource.generateBox(size: 0.1), materials: [SimpleMaterial(color: .black, isMetallic: true)])
                
                endAnchor?.addChild(box)
                
                guard let endAnchor = endAnchor,
                      let startAnchor = startAnchor
                else { return }
                
                arView.scene.addAnchor(endAnchor)
                
                //Calculate the distance
                let distance = simd_distance(startAnchor.position(relativeTo: nil), endAnchor.position(relativeTo: nil))
                measurementButton.setTitle(String(format: "%.2f meters", distance), for: .normal)
                
                
                
            }
            
        }
        
        
        
    }
    
    func setupUI() {
        
        guard let arView = arView else { return}
        
        let stackView = UIStackView(arrangedSubviews: [measurementButton, resetButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        arView.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: arView.centerXAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: arView.bottomAnchor, constant: -60).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
    
}
