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
  
  let bodyView = NodeView.init(node: BodyNode())
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    view.addSubview(bodyView)
    
    bodyView.easy.layout(Edges())
  }
}


class BodyNode: ASDisplayNode {
  
  let transitionNode = TransitionNode()
  
  let button = ASButtonNode()
  
  override init() {
    super.init()
    
    automaticallyManagesSubnodes = true
    
    button.setTitle("Toggle", with: nil, with: .black, for: .normal)
    
    button.addTarget(self, action: #selector(didTapButton), forControlEvents: .touchUpInside)
    
  }
  
  @objc func didTapButton() {
    
    transitionNode.isOpen.toggle()

    transitionNode.transitionLayout(withAnimation: true, shouldMeasureAsync: false, measurementCompletion: nil)
  }
  
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    LayoutSpec {
      ZStackLayout {
        
        transitionNode
        
        VStackLayout {
          VSpacerLayout()
          button
          VSpacerLayout()
        }
      }
    }
  }
}


class TransitionNode: ASDisplayNode {
  
  let contentNode = ContentNode()
  let bottomSpacer = ASDisplayNode()
  
  let backgoundNode = ASDisplayNode()
  
  let scrollNode = ASScrollNode()
  
  private var bottomHeight: CGFloat = 200 {
    didSet {
      bottomSpacer.style.height = .init(unit: .points, value: bottomHeight)
    }
  }
  
  var isOpen: Bool = false {
    didSet {
      contentNode.isOpen = isOpen
      bottomHeight = isOpen ? 400 : 200
    }
  }
  
  override init() {
    super.init()
    
    automaticallyManagesSubnodes = true
    scrollNode.automaticallyManagesSubnodes = true
    scrollNode.automaticallyManagesContentSize = true
    
    scrollNode.view.alwaysBounceVertical = true
    
    scrollNode.layoutSpecBlock = { _, _ in
      LayoutSpec {
        self.backgoundNode
      }
    }
    
    backgoundNode.automaticallyManagesSubnodes = true
    backgoundNode.backgroundColor = .lightGray
    backgoundNode.layoutSpecBlock = { _, _ in
      LayoutSpec {
        VStackLayout {
          VSpacerLayout()
          self.contentNode
          self.bottomSpacer
        }
      }
    }
    
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    LayoutSpec {
      scrollNode
    }
  }
  
//  func updateLayout() {
//        print("hoge:", contentNode.node1.supernode, contentNode.node2.supernode)
//        print("hoge:", contentNode.node1.frame, contentNode.node2.frame)
//
//    self.contentNode.setNeedsLayout()
//    self.contentNode.layoutIfNeeded()
//    self.contentNode.setLayout()
////    self.contentNode.setNeedsLayout()
////    self.scrollNode.setNeedsLayout()
//
//        UIView.animate(withDuration: 0.3, animations: {
//          self.layoutIfNeeded()
//        }, completion: { finished in
//
//        })
//
//  }
  
  override func animateLayoutTransition(_ context: ASContextTransitioning) {
            
//    print("hoge:", contentNode.node1.supernode, contentNode.node2.supernode)
//    print("hoge:", contentNode.node1.frame, contentNode.node2.frame)

    self.bottomSpacer.setNeedsLayout()
    
//    self.backgoundNode.setNeedsLayout()
//    self.scrollNode.setNeedsLayout()
    
    contentNode.transitionLayout(withAnimation: true, shouldMeasureAsync: false, measurementCompletion: nil)

    UIView.animate(withDuration: 0.3, animations: {
//      self.contentNode.setLayout()
//      self.layoutIfNeeded()
      self.backgoundNode.layoutIfNeeded()
    }, completion: { finished in
      context.completeTransition(finished)
    })
    
  }
  
}


class ContentNode: ASDisplayNode {
  
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
  
//  func setLayout() {
//
//    let frame1 = self.node1.frame
//    let frame2 = self.node2.frame
//
//    if isOpen {
//
//      self.node1.alpha = 1
//      self.node2.alpha = 0
//
//      self.node1.frame = frame1
//      self.node2.frame = frame1
//
//    } else {
//
//      self.node1.alpha = 0
//      self.node2.alpha = 1
//
//      self.node1.frame = frame2
//      self.node2.frame = frame2
//    }
//  }
  
  override func animateLayoutTransition(_ context: ASContextTransitioning) {
    
    print("hoge:", node1.frame, node2.frame)
    print("hoge:init:", context.initialFrame(for: node1), context.initialFrame(for: node2))
    print("hoge:init:", context.finalFrame(for: node1), context.finalFrame(for: node2))
    
    if isOpen {
      
      self.node1.alpha = 0
      self.node2.alpha = 1
      
      self.node1.frame = context.initialFrame(for: node2)
      self.node2.frame = context.initialFrame(for: node2)
      
      UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
        
        self.node1.alpha = 1
        self.node2.alpha = 0
        
        self.node1.frame = context.finalFrame(for: self.node1)
        self.node2.frame = context.finalFrame(for: self.node1)
        
      }, completion: { finished in
        context.completeTransition(finished)
      })
      
    } else {
      
      self.node1.alpha = 1
      self.node2.alpha = 0
      
      self.node1.frame = context.initialFrame(for: node1)
      self.node2.frame = context.initialFrame(for: node1)
      
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

//class TransitionNode2: ASDisplayNode {
//
//    let node1 = ASDisplayNode()
//    let node2 = ASDisplayNode()
//
//    var isOpen: Bool = false
//
//    override init() {
//        super.init()
//
//        automaticallyManagesSubnodes = true
//
//        node1.backgroundColor = .blue
//        node2.backgroundColor = .red
//
//    }
//
//    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
//
//        return LayoutSpec {
//            VStackLayout {
//                VSpacerLayout()
//                if isOpen {
//                    HStackLayout {
//                        HSpacerLayout()
//                        node1.preferredSize(.init(width: 100, height: 10))
//                    }
//                } else {
//                    node2.preferredSize(.init(width: 200, height: 100))
//                }
//                VSpacerLayout()
//            }
//        }
//    }
//
//}

