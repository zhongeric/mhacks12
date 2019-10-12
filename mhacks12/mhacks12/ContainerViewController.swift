//
//  ContainerViewController.swift
//  mhacks12
//
//  Created by Eric Zhong on 10/12/19.
//  Copyright © 2019 ericzhong. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class ContainerViewController: UIViewController {
    enum SlideOutState {
      case bothCollapsed
      case leftPanelExpanded
      case rightPanelExpanded
    }
    
    let centerPanelExpandedOffset: CGFloat = 90
    var NavigationController: UINavigationController!
    var ViewController: ViewController! // ViewController = viewcontroller
    
    var currentState: SlideOutState = .bothCollapsed
    var leftViewController: SidePanelViewController?
    var rightViewController: SidePanelViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1
        ViewController = UIStoryboard.ViewController()
        // 2
        ViewController.delegate = self
        
        print("Hi")

        // 3
        NavigationController = UINavigationController(rootViewController: ViewController)
        view.addSubview(NavigationController.view)
        addChild(NavigationController)

        // 4
        NavigationController.didMove(toParent: self)
    
    }
}

private extension UIStoryboard {
  static func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
  
  static func leftViewController() -> SidePanelViewController? {
    return mainStoryboard().instantiateViewController(withIdentifier: "LeftViewController") as? SidePanelViewController
  }
  
  static func rightViewController() -> SidePanelViewController? {
    return mainStoryboard().instantiateViewController(withIdentifier: "RightViewController") as? SidePanelViewController
  }
  
  static func ViewController() -> ViewController? {
    return mainStoryboard().instantiateViewController(withIdentifier: "ViewController") as? ViewController
  }
}

extension ContainerViewController: ViewControllerDelegate {
    func toggleLeftPanel() {
        print("In toggleLeftPanel")
          let notAlreadyExpanded = (currentState != .leftPanelExpanded)

          if notAlreadyExpanded {
            addLeftPanelViewController()
          }

          animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func addLeftPanelViewController() {
        print("in addLeftPanelViewController")
      guard leftViewController == nil else { return }

      if let vc = UIStoryboard.leftViewController() {
//        vc.animals = Animal.allCats()
        addChildSidePanelController(vc)
        leftViewController = vc
      }
    }
    
    func animateLeftPanel(shouldExpand: Bool) {
      if shouldExpand {
        currentState = .leftPanelExpanded
        animateCenterPanelXPosition(
          targetPosition: NavigationController.view.frame.width - centerPanelExpandedOffset)
      } else {
        animateCenterPanelXPosition(targetPosition: 0) { _ in
          self.currentState = .bothCollapsed
          self.leftViewController?.view.removeFromSuperview()
          self.leftViewController = nil
        }
      }
    }
    
    func animateCenterPanelXPosition(
        targetPosition: CGFloat,
        completion: ((Bool) -> Void)? = nil) {
      UIView.animate(
        withDuration: 0.5,
        delay: 0,
        usingSpringWithDamping: 0.8,
        initialSpringVelocity: 0,
        options: .curveEaseInOut,
        animations: {
          self.NavigationController.view.frame.origin.x = targetPosition
        },
        completion: completion)
    }
    
    func addChildSidePanelController(_ sidePanelController: SidePanelViewController) {
      view.insertSubview(sidePanelController.view, at: 0)

      addChild(sidePanelController)
      sidePanelController.didMove(toParent: self)
    }
    

    func toggleRightPanel() {
    }

    func collapseSidePanels() {
    }
}
