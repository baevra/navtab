//
//  UINavigationController+Figma+Swizzling.swift
//  NavTab
//
//  Created by Roman Baev on 08.04.2024.
//

import UIKit
import InterposeKit

func setupUINavigationControllerFigmaSwizzling() {
  _ = try? Interpose(UIViewController.self) {
    _ = try? $0.prepareHook(
      #selector(UIViewController.viewDidLoad),
      methodSignature: (@convention(c) (AnyObject, Selector) -> Void).self,
      hookSignature: (@convention(block) (UIViewController) -> Void).self
    ) { store in
      { vc in
        store.original(vc, store.selector)

        guard let nc = vc as? UINavigationController else { return }

        let figmaStatusBar = UIView()
        let figmaNavBar = UIView()
        let figmaTopPadding = UIView()
        let figmaBottomPadding = UIView()
        let figmaLeadingPadding = UIView()
        let figmaTrailingPadding = UIView()

        nc.figmaSubviews["figmaStatusBar"] = figmaStatusBar
        nc.figmaSubviews["figmaNavBar"] = figmaNavBar
        nc.figmaSubviews["figmaTopPadding"] = figmaTopPadding
        nc.figmaSubviews["figmaBottomPadding"] = figmaBottomPadding
        nc.figmaSubviews["figmaLeadingPadding"] = figmaLeadingPadding
        nc.figmaSubviews["figmaTrailingPadding"] = figmaTrailingPadding

        figmaStatusBar.backgroundColor = .yellow
        figmaTopPadding.backgroundColor = .red
        figmaNavBar.backgroundColor = .green
        figmaBottomPadding.backgroundColor = .red

        figmaLeadingPadding.backgroundColor = .blue
        figmaLeadingPadding.alpha = 0.5

        figmaTrailingPadding.backgroundColor = .blue
        figmaTrailingPadding.alpha = 0.5

        nc.view.insertSubview(figmaStatusBar, belowSubview: nc.navigationBar)
        nc.view.insertSubview(figmaTopPadding, belowSubview: nc.navigationBar)
        nc.view.insertSubview(figmaNavBar, belowSubview: nc.navigationBar)
        nc.view.insertSubview(figmaBottomPadding, belowSubview: nc.navigationBar)
        nc.view.insertSubview(figmaLeadingPadding, belowSubview: nc.navigationBar)
        nc.view.insertSubview(figmaTrailingPadding, belowSubview: nc.navigationBar)
      }
    }
  }
  _ = try? Interpose(UINavigationController.self) {
    _ = try? $0.prepareHook(
      #selector(UINavigationController.viewDidLayoutSubviews),
      methodSignature: (@convention(c) (AnyObject, Selector) -> Void).self,
      hookSignature: (@convention(block) (UINavigationController) -> Void).self
    ) { store in
      { nc in
        store.original(nc, store.selector)

        let figmaStatusBar = nc.figmaSubviews["figmaStatusBar"]!
        let figmaNavBar = nc.figmaSubviews["figmaNavBar"]!
        let figmaTopPadding = nc.figmaSubviews["figmaTopPadding"]!
        let figmaBottomPadding = nc.figmaSubviews["figmaBottomPadding"]!
        let figmaLeadingPadding = nc.figmaSubviews["figmaLeadingPadding"]!
        let figmaTrailingPadding = nc.figmaSubviews["figmaTrailingPadding"]!

        let statusBarHeight = nc.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0

    //    // figma status bar height = 47, actual = 59
    //    // figma top padding = 16, actual top padding = 16 - 54-47
        let width = nc.view.frame.width

        figmaStatusBar.frame = CGRect(x: 0, y: 0, width: width, height: 47)
        figmaTopPadding.frame = CGRect(x: 0, y: figmaStatusBar.frame.maxY, width: width, height: 16)
        figmaNavBar.frame = CGRect(x: 0, y: figmaTopPadding.frame.maxY, width: width, height: 44)
        figmaBottomPadding.frame = CGRect(x: 0, y: figmaNavBar.frame.maxY, width: width, height: 16)
        figmaLeadingPadding.frame = CGRect(x: 0, y: 0, width: 20, height: figmaBottomPadding.frame.maxY)
        figmaTrailingPadding.frame = CGRect(x: width - 20, y: 0, width: 20, height: figmaBottomPadding.frame.maxY)
      }
    }
  }
}

private var uiNavigationControllerFigmaSubviewsKey: Void?
extension UINavigationController {
  var figmaSubviews: [String: UIView] {
    get { getAssociatedObject(self, forKey: &uiNavigationControllerFigmaSubviewsKey) ?? [:] }
    set {
      setRetainedAssociatedObject(self, value: newValue, forKey: &uiNavigationControllerFigmaSubviewsKey)
    }
  }
}
