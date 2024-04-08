//
//  UINavigationController+Swizzling.swift
//  NavTab
//
//  Created by Roman Baev on 08.04.2024.
//

import UIKit
import InterposeKit

func setupUINavigationControllerSwizzling() {
  _ = try? Interpose(UINavigationController.self) {
    _ = try? $0.prepareHook(
      #selector(UINavigationController.viewDidLayoutSubviews),
      methodSignature: (@convention(c) (AnyObject, Selector) -> Void).self,
      hookSignature: (@convention(block) (UINavigationController) -> Void).self
    ) { store in
      { nc in
        store.original(nc, store.selector)

        let navigationBar = nc.navigationBar
        let statusBarHeight = nc.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0

        let figmaStatusBarHeight: CGFloat = statusBarHeight > 0 ? 47 : 0
        let topPadding: CGFloat = 16 - (statusBarHeight - figmaStatusBarHeight)
        let bottomPadding: CGFloat = 16

        navigationBar.frame.origin.y = figmaStatusBarHeight + topPadding + bottomPadding
        navigationBar.yOffset = -bottomPadding
        nc.additionalSafeAreaInsets.top = topPadding + bottomPadding
      }
    }
  }
}
