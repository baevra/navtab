//
//  CRNavigationController.swift
//  NavTab
//
//  Created by Roman Baev on 02.04.2024.
//

import SwiftUI

struct ViewConroller: View {
  var body: some View {
    List(0..<20) {
      Text("Item \($0)")
    }
  }
}

class TitleView: UIView {
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    backgroundColor = .red
    return CGSize(width: 20, height: 90)
  }
}

struct CRNavigationController: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> some UIViewController {
    let nc = CRUNavigationController()

    let vc1 = UIHostingController(rootView: ViewConroller())
    let vc2 = UIHostingController(rootView: ViewConroller())
    let vc3 = UIHostingController(rootView: ViewConroller())
    let vc4 = UIHostingController(rootView: ViewConroller())

    vc1.navigationItem.rightBarButtonItem = CRUBarButtonItem(title: "далее", primaryAction: .init { _ in
      nc.pushViewController(vc2, animated: true)
    })

    vc2.navigationItem.rightBarButtonItem = CRUBarButtonItem(title: "далее", primaryAction: .init { _ in
      nc.pushViewController(vc3, animated: true)
    })
    let titleView = TitleView()

    vc2.navigationItem.titleView = titleView

    vc3.navigationItem.rightBarButtonItem = CRUBarButtonItem(title: "далее", primaryAction: .init { _ in
      nc.pushViewController(vc4, animated: true)
    })

    vc4.navigationItem.rightBarButtonItem = CRUBarButtonItem(title: "готово", primaryAction: .init { _ in
      nc.popToRootViewController(animated: true)
    })

    nc.viewControllers = [vc1]

    return nc
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
  }
}

class CRUNavigationBar: UINavigationBar {
  var yOffset: CGFloat = 0.0

  override func layoutSubviews() {
    super.layoutSubviews()
    let contentView = firstSubview(name: "_UINavigationBarContentView")
    contentView?.frame.origin.y = yOffset
  }
}

open class CRUNavigationController: UINavigationController {
  public init() {
    super.init(navigationBarClass: CRUNavigationBar.self, toolbarClass: nil)
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override open func viewDidLoad() {
    super.viewDidLoad()
    updateAppearance()
//    setupUI()
  }

  let figmaStatusBar = UIView()
  let figmaNavBar = UIView()
  let figmaTopPadding = UIView()
  let figmaBottomPadding = UIView()
  let figmaLeadingPadding = UIView()
  let figmaTrailingPadding = UIView()

  func setupUI() {
    figmaStatusBar.backgroundColor = .yellow
    figmaTopPadding.backgroundColor = .red
    figmaNavBar.backgroundColor = .green
    figmaBottomPadding.backgroundColor = .red

    figmaLeadingPadding.backgroundColor = .blue
    figmaLeadingPadding.alpha = 0.5

    figmaTrailingPadding.backgroundColor = .blue
    figmaTrailingPadding.alpha = 0.5

    view.insertSubview(figmaStatusBar, belowSubview: navigationBar)
    view.insertSubview(figmaTopPadding, belowSubview: navigationBar)
    view.insertSubview(figmaNavBar, belowSubview: navigationBar)
    view.insertSubview(figmaBottomPadding, belowSubview: navigationBar)
    view.insertSubview(figmaLeadingPadding, belowSubview: navigationBar)
    view.insertSubview(figmaTrailingPadding, belowSubview: navigationBar)
  }

  open override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let navigationBar = navigationBar as! CRUNavigationBar
    let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0

//    // figma status bar height = 47, actual = 59
//    // figma top padding = 16, actual top padding = 16 - 54-47
    let topPadding: CGFloat = 16 - (statusBarHeight - 47)
    let bottomPadding: CGFloat = 16
//
    let width = view.frame.width

    figmaStatusBar.frame = CGRect(x: 0, y: 0, width: width, height: 47)
    figmaTopPadding.frame = CGRect(x: 0, y: figmaStatusBar.frame.maxY, width: width, height: 16)
    figmaNavBar.frame = CGRect(x: 0, y: figmaTopPadding.frame.maxY, width: width, height: 44)
    figmaBottomPadding.frame = CGRect(x: 0, y: figmaNavBar.frame.maxY, width: width, height: 16)
    figmaLeadingPadding.frame = CGRect(x: 0, y: 0, width: 20, height: figmaBottomPadding.frame.maxY)
    figmaTrailingPadding.frame = CGRect(x: width - 20, y: 0, width: 20, height: figmaBottomPadding.frame.maxY)

    navigationBar.frame.origin.y = figmaNavBar.frame.minY + bottomPadding
    navigationBar.yOffset = -bottomPadding
    additionalSafeAreaInsets.top = topPadding + bottomPadding
  }

  private func updateAppearance() {
    let backButtonBackgroundImage = self.backButtonBackgroundImage(with: .white)
    let backButtonIndicatorImage = self.backButtonIndicatorImage(with: .black)
    navigationBar.standardAppearance.backButtonAppearance.normal.backgroundImage = backButtonBackgroundImage
    navigationBar.standardAppearance.setBackIndicatorImage(backButtonIndicatorImage, transitionMaskImage: backButtonIndicatorImage)

    let appearance = UINavigationBarAppearance()
    appearance.configureWithDefaultBackground()
    appearance.backButtonAppearance.normal.backgroundImage = backButtonBackgroundImage
    appearance.setBackIndicatorImage(backButtonIndicatorImage, transitionMaskImage: backButtonIndicatorImage)

    appearance.shadowColor = .clear
    appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)

    navigationBar.standardAppearance = appearance
    navigationBar.compactAppearance = appearance
  }

  override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    guard traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle else { return }
    updateAppearance()
  }
}

extension CRUNavigationController {
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
}


@MainActor
public class CRUBarButtonItem: UIBarButtonItem {
  @MainActor public convenience init(
    title: String,
    target: AnyObject? = nil,
    action: Selector? = nil
  ) {
    let contentButton = Button()
    contentButton.contentView.titleLabel.text = title
    if let action {
      contentButton.addTarget(target, action: action, for: .touchUpInside)
    }
    self.init(customView: contentButton)
  }

  @available(iOS 14.0, tvOS 14.0, *)
  @MainActor public convenience init(
    title: String,
    primaryAction: UIAction? = nil,
    menu: UIMenu? = nil
  ) {
    let contentButton = Button(primaryAction: primaryAction)
    contentButton.menu = menu
    contentButton.contentView.titleLabel.text = title
    self.init(customView: contentButton)
  }
}

extension CRUBarButtonItem {
  class Button: UIButton {
    let contentView = ContentView()

    override init(frame: CGRect) {
      super.init(frame: frame)
      contentView.translatesAutoresizingMaskIntoConstraints = false
      addSubview(contentView)

      NSLayoutConstraint.activate([
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
        contentView.topAnchor.constraint(equalTo: topAnchor),
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
      ])
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    class ContentView: UIView {
      let titleLabel = UILabel()

      let backgroundView = UIView()

      override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
          backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
          backgroundView.topAnchor.constraint(equalTo: topAnchor),
          backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
          backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),

          titleLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
          titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 12),
          titleLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
          titleLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -12)
        ])

        tokensDidChange()
      }

      @available(*, unavailable)
      public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      }

      override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.layer.cornerRadius = bounds.height / 2
      }

      override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        nil
      }

      func tokensDidChange() {
//        titleLabel.font = .preferredFont(forTextStyle: .)
        titleLabel.textColor = .black
        backgroundView.backgroundColor = .white
      }
    }
  }
}
