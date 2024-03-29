//
//  RectangleBox.swift
//  Assignment
//
//  Created by Venugopal S A on 20/07/19.
//  Copyright © 2019 Venugopal S A. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

extension ARPlaneAnchor {
    // Inches
    var width: Float { return self.extent.x * 39.3701}
    var length: Float { return self.extent.z * 39.3701}
}

class RectangleBox : SCNNode {
    
    var anchor: ARPlaneAnchor
    var planeGeometry: SCNPlane!
    var textGeometry: SCNText!
    var tag: Int?
    
    init(anchor: ARPlaneAnchor) {
        self.anchor = anchor
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(anchor: ARPlaneAnchor) {
        planeGeometry.width = CGFloat(anchor.extent.x);
        planeGeometry.height = CGFloat(anchor.extent.z);
        position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
        
        let planeNode = self.childNodes.first!
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: self.planeGeometry, options: nil))
        
        if let textGeometry = self.childNode(withName: "textNode", recursively: true)?.geometry as? SCNText {
            // Update text to new size
            textGeometry.string = String(format: "%.1f\"", anchor.width) + " x " + String(format: "%.1f\"", anchor.length)
        }
    }
    
    private func setup() {
        planeGeometry = SCNPlane(width: CGFloat(anchor.width), height: CGFloat(anchor.length))
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named:"Rectangle.png")?.imageWithAlpha(alpha: 0.5)
        planeGeometry.materials = [material]
        let planeNode = SCNNode(geometry: self.planeGeometry)
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: planeGeometry, options: nil))
        planeNode.physicsBody?.categoryBitMask = 2
        
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
        planeNode.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2.0), 1.0, 0.0, 0.0);
        
        // 1.
        let textNodeMaterial = SCNMaterial()
        textNodeMaterial.diffuse.contents = UIColor.black
        
        // Set up text geometry
        textGeometry = SCNText(string: String(format: "%.1f\"", anchor.width) + " x " + String(format: "%.1f\"", anchor.length), extrusionDepth: 1)
        textGeometry.font = UIFont.systemFont(ofSize: 10)
        textGeometry.materials = [textNodeMaterial]
        
        // Integrate text node with text geometry
        // 2.
        let textNode = SCNNode(geometry: textGeometry)
        textNode.name = "textNode"
        textNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
        textNode.scale = SCNVector3Make(0.005, 0.005, 0.005)
        
        planeNode.addChildNode(textNode)
        addChildNode(planeNode)
    }
}
