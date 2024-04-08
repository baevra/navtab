//
//  Appearance.swift
//  NavTab
//
//  Created by Roman Baev on 08.04.2024.
//

import UIKit

func updateAppearance() {
  let backButtonBackgroundImage = backButtonBackgroundImage(with: .white)
  let backButtonIndicatorImage = backButtonIndicatorImage(with: .black)

  let appearance = UINavigationBarAppearance()
  appearance.configureWithDefaultBackground()
  appearance.backButtonAppearance.normal.backgroundImage = backButtonBackgroundImage
  appearance.setBackIndicatorImage(backButtonIndicatorImage, transitionMaskImage: backButtonIndicatorImage)

  appearance.shadowColor = .clear
  appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)

  UINavigationBar.appearance().standardAppearance = appearance
  UINavigationBar.appearance().compactAppearance = appearance
}

private func backButtonBackgroundImage(with color: UIColor) -> UIImage? {
  let size = CGSize(width: 59, height: 44)
  UIGraphicsBeginImageContextWithOptions(size, false, 0)
  defer { UIGraphicsEndImageContext() }
  guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
  ctx.saveGState()

  let bezierPath = UIBezierPath(ovalIn: CGRect(x: 15, y: 2, width: 42, height: 42))
  color.setFill()
  bezierPath.fill()

  ctx.restoreGState()
  let image = UIGraphicsGetImageFromCurrentImageContext()
  return image
}

private func backButtonIndicatorImage(with color: UIColor) -> UIImage? {
  let size = CGSize(width: 38, height: 20)
  UIGraphicsBeginImageContextWithOptions(size, false, 0)
  defer { UIGraphicsEndImageContext() }
  guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
  ctx.saveGState()

  let bezierPath = UIBezierPath()
  bezierPath.move(to: CGPoint(x: 34, y: 14.67))
  bezierPath.addLine(to: CGPoint(x: 29.67, y: 9.61))
  bezierPath.addCurve(to: CGPoint(x: 29.67, y: 8.05), controlPoint1: CGPoint(x: 29.28, y: 9.16), controlPoint2: CGPoint(x: 29.28, y: 8.5))
  bezierPath.addLine(to: CGPoint(x: 34, y: 3))
  color.setStroke()
  bezierPath.lineWidth = 1.75
  bezierPath.miterLimit = 4
  bezierPath.lineCapStyle = .square
  bezierPath.stroke()

  ctx.restoreGState()
  let image = UIGraphicsGetImageFromCurrentImageContext()
  return image
}
