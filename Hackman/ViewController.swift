//
//  ViewController.swift
//  Hackman
//
//  Created by Alex Cevallos on 10/6/17.
//  Copyright © 2017 Alex Cevallos. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    // Create a session configuration
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        for i in -10..<10 {
            for j in -10..<10{
                addBox(xaxis: Float(i), yaxis: Float(j))
            }
            
        }
        sceneView.debugOptions = [.showBoundingBoxes, .showCameras]
    }
    func resetSession(){
        self.sceneView.session.pause()
        self.sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
            node.removeFromParentNode()
        }
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func addBox(xaxis:Float, yaxis:Float){
        let node = SCNNode()
        node.geometry = SCNBox(width:0.1, height: 0.1, length:0.1, chamferRadius:0)
        node.geometry?.firstMaterial?.specular.contents = UIColor.orange
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        
        
        node.position = SCNVector3(xaxis,-1,yaxis)
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    func addSphere(){
        let node = SCNNode()
        node.geometry = SCNSphere(radius:0.1)
        node.geometry?.firstMaterial?.specular.contents = UIColor.orange
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        
        
        node.position = SCNVector3(0,0,-1)
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    func randomNumbers(firstNum: CGFloat, secondNum: CGFloat)-> CGFloat{
        return CGFloat(arc4random())/CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let cameraPosition = sceneView.pointOfView{
            cameraPosition.geometry = SCNSphere(radius:0.1)
            
            cameraPosition.geometry?.firstMaterial?.specular.contents = UIColor.orange
            cameraPosition.geometry?.firstMaterial?.diffuse.contents = UIColor.brown
            cameraPosition.position = SCNVector3(0, 0, -2)
            
            sceneView.scene.rootNode.addChildNode(cameraPosition)
        }
        
        
        
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    // MARK: Helper Methods
    func randomPosition(lowerBound lower:Float, upperBound upper:Float) -> Float {
        
        return Float(arc4random()) / Float(UInt32.max) * (lower - upper) + upper
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
