//
//  NavTabApp.swift
//  NavTab
//
//  Created by Roman Baev on 02.04.2024.
//

import SwiftUI

@main
struct NavTabApp: App {
  var body: some Scene {
    WindowGroup {
      CRNavigationController()
        .ignoresSafeArea()
        .tint(.black)
    }
  }
}
