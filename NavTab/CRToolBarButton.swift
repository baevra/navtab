//
//  CRToolBarButton.swift
//  NavTab
//
//  Created by Roman Baev on 08.04.2024.
//

import SwiftUI

struct CRToolBarButton: View {
  private let title: String
  private let action: () -> Void

  init(_ title: String, action: @escaping () -> Void) {
    self.title = title
    self.action = action
  }

  var body: some View {
    Button(title, action: action)
    .tint(.black)
    .padding(.horizontal, 20)
    .frame(height: 44)
    .background(
      Capsule()
        .fill(.white)
    )
    .padding(.trailing, 4)
  }
}
