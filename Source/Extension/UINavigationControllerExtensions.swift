//
//
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2021 Billiyo Mac. All rights reserved.
//


import Foundation
import UIKit

// MARK: Push Or Pop Completion Handler Methods -

extension UINavigationController {
    
    /**
      - Author: Sandip Prajapati
     Method Modify Version
     - Version: 2.1
     Method Modify date
     - Date: March 03, 2023
     - Description : Push and Pop Completion Handler Extension
     */
    
    
    public func pushViewController(
        _ viewController: UIViewController,
        animated: Bool,
        completion: @escaping () -> Void)
    {
        pushViewController(viewController, animated: animated)

        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }

        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }

    func popViewController(
        animated: Bool,
        completion: @escaping () -> Void)
    {
        popViewController(animated: animated)

        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }

        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
}

// MARK :-Methods
public extension UINavigationController {
    
    func popToViewControllerWithHandler(viewController: UIViewController, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popToViewController(viewController, animated: true)
        CATransaction.commit()
    }
    
    func popViewControllerWithHandler(completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: true)
        CATransaction.commit()
    }
    
    func pushViewController(viewController: UIViewController, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.pushViewController(viewController, animated: true)
        CATransaction.commit()
    }
    
//    /// Pop ViewController with completion handler.
//    ///
//    /// - Parameter completion: optional completion handler (default is nil).
//    public func popViewController(_ completion: (() -> Void)? = nil) {
//        // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
//        CATransaction.begin()
//        CATransaction.setCompletionBlock(completion)
//        popViewController(animated: true)
//        CATransaction.commit()
//    }
//
//    /// Push ViewController with completion handler.
//    ///
//    /// - Parameters:
//    ///   - viewController: viewController to push.
//    ///   - completion: optional completion handler (default is nil).
//    public func pushViewController(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
//        // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
//        CATransaction.begin()
//        CATransaction.setCompletionBlock(completion)
//        pushViewController(viewController, animated: true)
//        CATransaction.commit()
//    }
    
    /// Make navigation controller's navigation bar transparent.
    ///
    /// - Parameter tint: tint color (default is .white).
    func makeTransparent(withTint tint: UIColor = .white) {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.tintColor = tint
        navigationBar.titleTextAttributes = [.foregroundColor: tint]
    }
    
    // Push View Controller from Bottom like present view controller
    func pushViewControllerFromBottom(_ viewController: UIViewController, animation: Bool) {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(viewController, animated: animation)
    }
    
    // Push View Controller from Top like present view controller
    func pushViewControllerFromTop(_ viewController: UIViewController, animation: Bool) {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(viewController, animated: animation)
    }
}
extension UINavigationController {
    /**
     It removes all view controllers from navigation controller then set the new root view controller and it pops.
     
     - parameter vc: root view controller to set a new
     */
    func initRootViewController(vc: UIViewController, transitionType type: CATransitionType = CATransitionType.fade, duration: CFTimeInterval = 0.3) {
        self.addTransition(transitionType: type, duration: duration)
        self.viewControllers.removeAll()
        self.pushViewController(vc, animated: false)
        self.popToRootViewController(animated: false)
    }
    
    /**
     It adds the animation of navigation flow.
     
     - parameter type: kCATransitionType, it means style of animation
     - parameter duration: CFTimeInterval, duration of animation
     */
    private func addTransition(transitionType type: CATransitionType = CATransitionType.fade, duration: CFTimeInterval = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = type
        self.view.layer.add(transition, forKey: nil)
    }
}

public extension UINavigationController {

    /**
     Pop current view controller to previous view controller.

     - parameter type:     transition animation type.
     - parameter duration: transition animation duration.
     */
    func popWithAnimation(transitionType type: String = CATransitionType.fade.rawValue, duration: CFTimeInterval = 1.0) {
        self.addTransition(transitionType: type, duration: duration)
        self.popViewController(animated: false)
    }
    
    /**
     Pop current view controller to previous view controller.

     - parameter type:     transition animation type.
     - parameter duration: transition animation duration.
     */
    func popToRootWithAnimation(transitionType type: String = CATransitionType.fade.rawValue, duration: CFTimeInterval = 1.0) {
        self.addTransition(transitionType: type, duration: duration)
        self.popToRootViewController(animated: false)
    }

    /**
     Push a new view controller on the view controllers's stack.

     - parameter vc:       view controller to push.
     - parameter type:     transition animation type.
     - parameter duration: transition animation duration.
     */
    func pushWithAnimation(viewController vc: UIViewController, transitionType type: String = CATransitionType.fade.rawValue, duration: CFTimeInterval = 1.0) {
        self.addTransition(transitionType: type, duration: duration)
        self.pushViewController(vc, animated: false)
    }
    
    private func addTransition(transitionType type: String = CATransitionType.fade.rawValue, duration: CFTimeInterval = 1.0) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType(rawValue: type)
        self.view.layer.add(transition, forKey: nil)
    }
}
