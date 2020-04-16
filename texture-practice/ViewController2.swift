//
//  ViewController2.swift
//  texture-practice
//
//  Created by jinsei_shima on 2020/04/16.
//  Copyright © 2020 jinsei shima. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class RootNode: ASDisplayNode {
    
    let boxes = [
    { ()->ASDisplayNode in
        let node = ASDisplayNode()
        node.backgroundColor = .lightGray
        return node
        }(),
    { ()->ASDisplayNode in
        let node = ASDisplayNode()
        node.backgroundColor = .darkGray
        return node
        }()
    ]
    
    override init() {
        
        super.init()
        
        backgroundColor = .init(white: 0.95, alpha: 1)
        boxes.forEach {
            $0.style.height = .init(unit: .points, value: 40)
            $0.style.flexBasis = .init(unit: .fraction, value: 0.5)
        }
        
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        return ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 0,
            justifyContent: .start,
            alignItems: .start,
            flexWrap: .wrap,
            alignContent: .start,
            lineSpacing: 0,
            children: boxes
        )
    }
    
}

class ViewController2: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let node = RootNode()
        node.frame.size = .init(width: view.bounds.width, height: 100)
        node.view.center = view.center
        view.addSubnode(node)
    }
}


class RootNode: ASDisplayNode {

    let boxes = [
    { ()->ASDisplayNode in
        let node = ASDisplayNode()
        node.backgroundColor = .lightGray
        return node
        }(),
    { ()->ASDisplayNode in
        let node = ASDisplayNode()
        node.backgroundColor = .darkGray
        return node
        }()
    ]

    override init() {

        super.init()

        backgroundColor = .init(white: 0.95, alpha: 1)
        boxes.forEach {
            $0.style.height = .init(unit: .points, value: 40)
            $0.style.flexBasis = .init(unit: .fraction, value: 0.5)
        }

        automaticallyManagesSubnodes = true
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        return ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 0,
            justifyContent: .start,
            alignItems: .start,
            flexWrap: .wrap,
            alignContent: .start,
            lineSpacing: 0,
            children: boxes
        )
    }

}

class ViewController2: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()

        view.backgroundColor = .white

        let node = RootNode()
        node.frame.size = .init(width: view.bounds.width, height: 100)
        node.view.center = view.center
        view.addSubnode(node)
    }
}

