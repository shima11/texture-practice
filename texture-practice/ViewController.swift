//
//  ViewController.swift
//  texture-practice
//
//  Created by jinsei shima on 2018/06/24.
//  Copyright © 2018 jinsei shima. All rights reserved.
//

import UIKit

import EasyPeasy
import RxCocoa

import AsyncDisplayKit
import TextureBridging
import TextureSwiftSupport

class ViewController1: UIViewController {

    let transitionView = NodeView(node: TransitionNode())
    
    let button = NodeView(node: ASButtonNode())
    
    override func viewDidLoad() {

        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(transitionView)
        view.addSubview(button)
        
        transitionView.easy.layout(Edges())
            
        
    }
}


class TransitionNode: ASDisplayNode {
        
    let node1 = ASDisplayNode()
    let node2 = ASDisplayNode()

    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        LayoutSpec {
            VStackLayout {
                node1
                node2
            }
        }
    }
    
}

