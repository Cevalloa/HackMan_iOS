//
//  Ball.swift
//  Hackman
//
//  Created by Alex Cevallos on 10/6/17.
//  Copyright © 2017 Alex Cevallos. All rights reserved.
//

import Foundation
import ARKit

class Ball: SCNNode {
    
    func loadModal() {
        /*
        // Object is technically a scene
        guard let virtualObjectScene = SCNScene(named: "art.scnassets/Ball.scn") else {return}
        
        let wrapperNode = SCNNode()
        
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        
        self.addChildNode(wrapperNode)*/
        
        let node = SCNNode()
        node.geometry = SCNSphere(radius: 0.1)
        node.geometry?.firstMaterial?.specular.contents = UIColor.orange
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        
        //node.position = SCNVector3(0, 0, 0.03)
        self.addChildNode(node)
    }
}
