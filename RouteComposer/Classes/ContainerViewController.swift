//
//  ContainerViewController.swift
//  RouteComposer
//
//  Created by Alexandra Mikhailouskaya on 23/01/2018.
//

import Foundation
import UIKit

/// All container view controllers should extend this protocol so if `Router` will ask them to make visible
/// one of the view controllers that they contain as each container can have custom implementations of this
/// functionality.
@objc public protocol ContainerViewController: RoutingInterceptable { // @objc is mandatory otherwise crashes in runtime everywhere where Self: UIViewController

    /// `UIViewController` instances that `ContainerViewController` currently has in the stack
    var containingViewControllers: [UIViewController] { get }

    /// `UIViewController` instances out of the `containingViewControllers` that are currently visible on the screen
    var visibleViewControllers: [UIViewController] { get }

    /// Each container view controller should conform to this protocol for the `Router` to know how to make
    /// the particular child view controller visible.
    ///
    /// - parameters:
    ///   - viewController: The `UIViewController` to make active (visible).
    ///   - animated: If `ContainerViewController` is able to do so - make container active animated or not.
    func makeVisible(_ viewController: UIViewController, animated: Bool)

}
