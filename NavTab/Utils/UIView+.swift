//
//  UIView+.swift
//  NavTab
//
//  Created by Roman Baev on 03.04.2024.
//

import UIKit

private struct Queue<T> {
  var array: [T] = []

  var isEmpty: Bool {
    return array.isEmpty
  }

  var count: Int {
    return array.count
  }

  mutating func enqueue(_ element: T) {
    array.append(element)
  }

  mutating func dequeue() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.removeFirst()
    }
  }

  var front: T? {
    return array.first
  }
}

extension UIView {
  func firstSubview(name: String) -> UIView? {
      var queue = Queue<[UIView]>()
      queue.enqueue(subviews)

      while let subviews = queue.dequeue() {
        for subview in subviews {
          if subview.description.contains(name) {
            return subview
          } else {
            queue.enqueue(subview.subviews)
          }
        }
      }

      return nil
    }
}
