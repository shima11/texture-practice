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


// TODO: ボタンのテキストとサイズが変更するときのなめらかなアニメーションの実装
// GlossButtonNodeみたいにいくつかのレイヤーに分かれているNodeのアニメーション


class ViewController1: UIViewController {
  
  let bodyView = NodeView.init(node: BodyNode())

  var flag = false
  var flag2 = false

  let button = UIButton()
  let buttonNode = NodeView.init(node: AnimationButton())
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    button.backgroundColor = .white
    button.layer.cornerRadius = 8
    button.clipsToBounds = true
    button.setTitleColor(.black, for: .normal)
    
    buttonNode.node.backgroundColor = .white
    buttonNode.node.cornerRadius = 8
    buttonNode.node.clipsToBounds = true
    
    view.addSubview(bodyView)
    view.addSubview(button)
    view.addSubview(buttonNode)
        
    bodyView.easy.layout(Edges())
    button.easy.layout(
      CenterX(),
      Bottom(60)
    )
    buttonNode.easy.layout(
      CenterX(),
      Bottom(120)
    )

    button.setTitle("uibutton", for: .normal)

    button.rx.tap.bind { _ in

      self.flag.toggle()
            
      UIView.animate(withDuration: 0.3, delay: 0, options: [.transitionFlipFromBottom], animations: {
        self.button.setTitle(self.flag ? "uibutton uibutton" : "uibutton", for: .normal)
        self.button.layoutIfNeeded()
      })
    }
    
    buttonNode.node.setTitle(text: "node", animated: true)
    buttonNode.node.addTarget(self, action: #selector(didTapButton), forControlEvents: .touchUpInside)
    
  }
  
  @objc func didTapButton() {
    
    self.flag2.toggle()
    
    self.buttonNode.node.setTitle(text: self.flag2 ? "node node" : "node", animated: true)
    
//    UIView.animate(withDuration: 1, animations: {
////      self.buttonNode.node.setTitle(self.flag2 ? "node node" : "node", with: nil, with: .black, for: .normal)
//      self.buttonNode.layoutIfNeeded()
//    })

  }

}


class AnimationButton: ASControlNode {
    
  let titleNode = ASTextNode()
  let backgroundNode = ASDisplayNode()
  
  override init() {
    super.init()
    
    backgroundNode.backgroundColor = .white
    backgroundNode.cornerRadius = 8
    backgroundNode.clipsToBounds = true
        
    automaticallyManagesSubnodes = true
  }
  
  func setTitle(text: String, animated: Bool) {
        
    print("hoge:pre:", frame, titleNode.frame, backgroundNode.frame)
    
//    let fadeTransition = CATransition()
//    fadeTransition.duration = 1
//    fadeTransition.type = .reveal
//
//    CATransaction.begin()
//    CATransaction.setAnimationDuration(1)
//    self.titleNode.attributedText = NSAttributedString(string: text)
////    self.layoutIfNeeded()
////    self.layer.add(.init(), forKey: kCATransition)
//    CATransaction.commit()


//    let cornerAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius))
//    cornerAnimation.fromValue = oldValue
//    cornerAnimation.toValue = newValue
//    cornerAnimation.duration = 1.0
//
//    styledButton.layer.cornerRadius = newValue
//    styledButton.layer.add(cornerAnimation, forKey: #keyPath(CALayer.cornerRadius))
    
    self.titleNode.attributedText = NSAttributedString(string: text)


    UIView.animate(withDuration: 1, delay: 0, options: [.transitionCrossDissolve], animations: {
//      self.titleNode.attributedText = NSAttributedString(string: text)
      self.layoutIfNeeded()
    }, completion: { completed in
      print("hoge:comp:", self.frame, self.titleNode.frame, self.backgroundNode.frame)
    })
        
  }
  
  override func didEnterDisplayState() {
    super.didEnterDisplayState()
    
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    LayoutSpec {
      CenterLayout {
        titleNode.padding(.init(16)).background(backgroundNode)

      }
    }
  }
}

class BodyNode: ASDisplayNode {
  
  let transitionNode = TransitionNode()
  
  let button = AnimationButton()
  
  override init() {
    super.init()
    
    automaticallyManagesSubnodes = true
    
    button.setTitle(text: "Toggle", animated: true)
    
    button.addTarget(self, action: #selector(didTapButton), forControlEvents: .touchUpInside)
    
  }
  
  @objc func didTapButton() {
    
    transitionNode.isOpen.toggle()

    button.setTitle(text: transitionNode.isOpen ? "Toggle" : "Toggle (let's open)", animated: true)
    transitionNode.transitionLayout(withAnimation: true, shouldMeasureAsync: false, measurementCompletion: nil)
  }
  
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    LayoutSpec {
      ZStackLayout {
        
        transitionNode
        
        VStackLayout {
          VSpacerLayout()
          HStackLayout {
            HSpacerLayout()
            button.padding(.init(16))
            HSpacerLayout()
          }
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

