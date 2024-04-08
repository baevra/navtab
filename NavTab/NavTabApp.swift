//
//  NavTabApp.swift
//  NavTab
//
//  Created by Roman Baev on 02.04.2024.
//

import SwiftUI
import NavigationBackport

@main
struct NavTabApp: App {
  init() {
    updateAppearance()
    setupSwizzling()
  }

  @State private var path: [String] = []
  @Environment(\.colorScheme) var colorScheme

  var body: some Scene {
    WindowGroup {
      NBNavigationStack(path: $path) {
        screen1()
          .onChange(of: colorScheme) { _ in
            updateAppearance()
          }
          .nbNavigationDestination(for: String.self) { path in
            switch path {
            case "A": screen2()
            case "B": screen3()
            default: fatalError()
            }
          }
      }
      .tint(.black)
    }
  }

  func screen1() -> some View {
    ContentView()
      .toolbar {
        ToolbarItem(placement: .principal) {
          Text("Screen 1")
        }
        ToolbarItem(placement: .topBarTrailing) {
          CRToolBarButton("next") {
            path += ["A"]
          }
        }
      }
  }

  func screen2() -> some View {
    ContentView()
      .toolbar {
        ToolbarItem(placement: .principal) {
          Text("Screen 2")
        }
        ToolbarItem(placement: .topBarTrailing) {
          CRToolBarButton("next") {
            path += ["B"]
          }
        }
      }
  }

  func screen3() -> some View {
    ContentView()
      .toolbar {
        ToolbarItem(placement: .principal) {
          Text("Screen 3")
        }
        ToolbarItem(placement: .topBarTrailing) {
          CRToolBarButton("done") {
            path = []
          }
        }
      }
  }
}

struct ContentView: View {
  var body: some View {
    List(0..<20) {
      Text("Item \($0)")
    }
  }
}
