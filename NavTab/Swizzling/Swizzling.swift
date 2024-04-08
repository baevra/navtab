//
//  Swizzling.swift
//  NavTab
//
//  Created by Roman Baev on 08.04.2024.
//

import UIKit

func setupSwizzling() {
  let isEnabled = true
  let showMargins = true
  /// Изменяет позиционирование UINavigationBar по вертикали
  setupUINavigationBarSwizzling(isEnabled: isEnabled)
  /// Устанавливает вертикальный отступ для UINavigationBar
  /// Добавляет safe area для увеличенного навбара
  /// showMargins: Сетка для проверки и сравнения верстки
  setupUINavigationControllerSwizzling(isEnabled: isEnabled, showMargins: showMargins)
}


