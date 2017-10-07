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
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    var pacMan = SCNNode()
    var badGuy = SCNNode()
    var badGuyMovementTimer = Timer()
    
    var counter: Int = 0 {
        didSet {
            MusicHelper.shared.playEatingNoise()
            DispatchQueue.main.async {
                
                self.counterLabel.text = "Score: \(self.counter)"
                
                
                if self.counter > self.getHighScore() {
                    self.saveHighScore(value: self.counter)
                    self.updateHighScoreLabel()
                }
            }
        }
    }
    
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
        
        updateHighScoreLabel()
        self.counterLabel.isHidden = true
        
        
    }
    
    func startGame() {
        
        for i in -10..<10 {
            for j in -10..<10{
                
                if i % 2 == 0 && j % 2 == 0 {
                    
                    addBox(xaxis: Float(i), yaxis: Float(j))
                    // addIronCurtain(xaxis: Float(i + 1), yaxis: Float(j - 6))
                }
            }
        }
        
        pacMan.geometry = SCNSphere(radius:0.25)
        pacMan.geometry?.firstMaterial?.specular.contents = UIColor.orange
        pacMan.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
        pacMan.position = SCNVector3(-1, -1, -1)
        self.sceneView.scene.rootNode.addChildNode(pacMan)
        
        badGuy.geometry = SCNBox(width: 0.5, height: 1.5, length: 0.5, chamferRadius: 0.0)
        badGuy.geometry?.firstMaterial?.specular.contents = UIColor.purple
        badGuy.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
        badGuy.position = SCNVector3(randomNumbers(firstNum: -10, secondNum: 10), -1, randomNumbers(firstNum: -10, secondNum: 10))
        badGuy.name = "Khrushchev"
        self.sceneView.scene.rootNode.addChildNode(badGuy)
        
        sceneView.debugOptions = [.showCameras, ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        MusicHelper.shared.playBackgroundMusic()
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
        node.geometry = SCNBox(width:0.2, height: 0.2, length:0.2, chamferRadius:0.1)
        node.geometry?.firstMaterial?.specular.contents = UIColor.orange
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        node.name = "box"
        
        node.position = SCNVector3(xaxis,-1,yaxis)
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    func addIronCurtain(xaxis:Float, yaxis:Float) {
        
        let node = SCNNode()
        node.geometry = SCNBox(width:0.2, height: 7.0, length:2.0, chamferRadius:0.0)
        node.geometry?.firstMaterial?.specular.contents = UIColor.orange
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.brown
        node.name = "ironCurtain"
        
        node.position = SCNVector3(xaxis,-1,yaxis)
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if let camera = sceneView.pointOfView {
            updateUserPosition(xAxis: camera.position.x, yAxis: camera.position.y, zAxis: camera.position.z)
            checkCollisions()
        }
    }
    
    func updateUserPosition(xAxis: Float, yAxis: Float, zAxis: Float){
        
        let moveToTarget = SCNAction.move(to: SCNVector3(xAxis, yAxis - 1, zAxis), duration: 0.01)
        pacMan.runAction(moveToTarget)
    }
    
    func updateKruschevPosition() {
        badGuy.removeAllActions()
        if let camera = sceneView.pointOfView {
            let moveToTarget = SCNAction.move(to: SCNVector3(camera.position.x, camera.position.y, camera.position.z), duration: 10)
            badGuy.runAction(moveToTarget)
        }
    }
    
    func checkCollisions() {
        let nodes = sceneView.scene.rootNode.childNodes
        
        if let camera = sceneView.pointOfView {
            
            if(isCollision(firstNode: camera, secondNode: badGuy)) {
                DispatchQueue.main.async {
                    self.startButton.isHidden = false
                }
            }
            
            for node in nodes {
                if (node != camera) {
                    if (isCollision(firstNode: node, secondNode: camera) && node.name == "box") {
                        node.removeFromParentNode()
                        counter += 1
                    }
                }
            }
        }
    }
    
    func isCollision(firstNode: SCNNode, secondNode: SCNNode) -> Bool {
        
        let position: Float = 0.5
        
        if firstNode.position.x - secondNode.position.x > -position && firstNode.position.x - secondNode.position.x < position {
            if firstNode.position.z - secondNode.position.z > -position && firstNode.position.z - secondNode.position.z < position {
                return true
            }
        }
        return false
    }
    
    func updateHighScoreLabel() {
        
        let highScore = self.getHighScore()
        
        if highScore > 0 {
            self.highScoreLabel.isHidden = false
            self.highScoreLabel.text = "High Score: \(highScore)"
        } else {
            
            self.highScoreLabel.isHidden = true
        }
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
    
    func saveHighScore(value: Int) {
        
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: "highScore")
        defaults.synchronize()
    }
    
    func getHighScore() -> Int {
        
        let defaults = UserDefaults.standard
        if let value = defaults.value(forKey: "highScore") as? Int {
            
            return value
        }
        
        return 0
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
    
    @IBAction func startButtonPressed(_ sender: Any) {
        startGame()
        self.startButton.isHidden = true
        self.counterLabel.isHidden = false
        
//        badGuyMovementTimer = Timer(fire: Date(), interval: 2, repeats: true, block: { (timer) in
//            self.updateKruschevPosition()
//        })
        badGuyMovementTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (timer) in
            self.updateKruschevPosition()
        })
        
        badGuyMovementTimer.fire()
    }
    
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
