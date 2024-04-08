//
//  UINavigationBar+Swizzling.swift
//  NavTab
//
//  Created by Roman Baev on 08.04.2024.
//

import UIKit
import InterposeKit

func setupUINavigationBarSwizzling(isEnabled: Bool) {
  _ = try? Interpose(UINavigationBar.self) {
    _ = try? $0.prepareHook(
      #selector(UINavigationBar.layoutSubviews),
      methodSignature: (@convention(c) (AnyObject, Selector) -> Void).self,
      hookSignature: (@convention(block) (UINavigationBar) -> Void).self
    ) { store in
      { navigationBar in
        store.original(navigationBar, store.selector)
        guard isEnabled else { return }
        let contentView = navigationBar.firstSubview(name: "_UINavigationBarContentView")
        contentView?.frame.origin.y = navigationBar.yOffset
      }
    }
  }
}

private var uiNavigationBarYOffsetKey: Void?
extension UINavigationBar {
  var yOffset: CGFloat {
    get { getAssociatedObject(self, forKey: &uiNavigationBarYOffsetKey) ?? 0.0 }
    set {
      setRetainedAssociatedObject(self, value: newValue, forKey: &uiNavigationBarYOffsetKey)
    }
  }
}
