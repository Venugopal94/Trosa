//
//  ViewController.swift
//  Assignment
//
//  Created by Venugopal S A on 20/07/19.
//  Copyright © 2019 Venugopal S A. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class PlaneDetectionViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var rectangles = [RectangleBox]()
    var selectedNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSceneView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureARTracking()
    }
    
    func setUpSceneView()  {
        
        // Set the view's delegate
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        
        // Create a new scene
        let scene = SCNScene()
        // Set the scene to the view
        sceneView.scene = scene
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nodeTapped))
        self.sceneView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func nodeTapped(recognizer: UILongPressGestureRecognizer) {
        
        let touch = recognizer.location(in: sceneView)
        let hitTestResult = self.sceneView.hitTest(touch, options: nil)
        
        guard let hitNode = hitTestResult.first?.node else { return }
        
        
        hitNode.enumerateChildNodes { (child, success) in
            child.removeFromParentNode()
        }
        hitNode.removeFromParentNode()
        
        
    }
    
    func configureARTracking()  {
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal,.vertical]
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
}

// MARK: - ARSCNViewDelegate

/*
 // Override to create and configure nodes for anchors added to the view's session.
 func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
 let node = SCNNode()
 
 return node
 }
 */

extension PlaneDetectionViewController: ARSCNViewDelegate {
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        let rectangle = RectangleBox(anchor: anchor as! ARPlaneAnchor)
        rectangle.name = "\(rectangles.count)"
        self.rectangles.append(rectangle)
        node.addChildNode(rectangle)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        let rectangle = self.rectangles.filter { rectangle in
            return rectangle.anchor.identifier == anchor.identifier
            }.first
        
        guard let foundGrid = rectangle else {
            return
        }
        if foundGrid.childNodes.first == nil {
            rectangles.remove(at: Int(rectangle?.name ?? "0") ?? 0)
            return
        }
        
        foundGrid.update(anchor: anchor as! ARPlaneAnchor)
    }
    
    
}

