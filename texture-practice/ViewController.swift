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
        
        button.node.setTitle("Toggle", with: nil, with: .black, for: .normal)
        
        transitionView.easy.layout(Edges())

        button.easy.layout(
            CenterX(),
            Bottom(60)
        )
        
        button.node.addTarget(self, action: #selector(didTapButton), forControlEvents: .touchUpInside)
        
    }
    
    @objc func didTapButton() {
        
        transitionView.node.isOpen.toggle()
        transitionView.node.transitionLayout(withAnimation: true, shouldMeasureAsync: false, measurementCompletion: nil)
    }

}


class TransitionNode: ASDisplayNode {
        
    let node1 = ASDisplayNode()
    let node2 = ASDisplayNode()

    var isOpen: Bool = false
    
    override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
        
        node1.backgroundColor = .blue
        node2.backgroundColor = .red
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

//        node1.style.preferredSize = .init(width: 100, height: 10)
//        node2.style.preferredSize = .init(width: 200, height: 100)
//
//        node1.style.maxSize = .init(width: 100, height: 10)

//        let tmpNode: ASDisplayNode
//        if isOpen {
//            tmpNode = node1
//        } else {
//            tmpNode = node2
//        }

        
        return LayoutSpec {
            VStackLayout {
                VSpacerLayout()
//                tmpNode
                if isOpen {
                    HStackLayout {
                        HSpacerLayout()
                        node1.preferredSize(.init(width: 100, height: 10))
                    }
                } else {
                    node2.preferredSize(.init(width: 200, height: 100))
                }
                VSpacerLayout()
            }
        }
    }

    override func animateLayoutTransition(_ context: ASContextTransitioning) {

        print("hoge:", node1.frame, node2.frame)
        print("hoge:init:", context.initialFrame(for: node1), context.initialFrame(for: node2))
        print("hoge:init:", context.finalFrame(for: node1), context.finalFrame(for: node2))

        if isOpen {
            
//            self.node1.alpha = 0
//            self.node2.alpha = 1
//
//            self.node1.frame = context.initialFrame(for: node2)
//            self.node2.frame = context.initialFrame(for: node2)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {

                self.node1.alpha = 1
                self.node2.alpha = 0

                self.node1.frame = context.finalFrame(for: self.node1)
                self.node2.frame = context.finalFrame(for: self.node1)
                
            }, completion: { finished in
                context.completeTransition(finished)
            })

        } else {

//            self.node1.alpha = 1
//            self.node2.alpha = 0
//
//            self.node1.frame = context.initialFrame(for: node1)
//            self.node2.frame = context.initialFrame(for: node1)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                
                self.node1.alpha = 0
                self.node2.alpha = 1
                
                self.node1.frame = context.finalFrame(for: self.node2)
                self.node2.frame = context.finalFrame(for: self.node2)
                
            }, completion: { finished in
                context.completeTransition(finished)
            })

        }

    }
    
}

class TransitionNode2: ASDisplayNode {
        
    let node1 = ASDisplayNode()
    let node2 = ASDisplayNode()

    var isOpen: Bool = false
    
    override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
        
        node1.backgroundColor = .blue
        node2.backgroundColor = .red
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        return LayoutSpec {
            VStackLayout {
                VSpacerLayout()
                if isOpen {
                    HStackLayout {
                        HSpacerLayout()
                        node1.preferredSize(.init(width: 100, height: 10))
                    }
                } else {
                    node2.preferredSize(.init(width: 200, height: 100))
                }
                VSpacerLayout()
            }
        }
    }
    
}

