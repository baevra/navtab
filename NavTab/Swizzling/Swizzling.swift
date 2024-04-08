//
//  Swizzling.swift
//  NavTab
//
//  Created by Roman Baev on 08.04.2024.
//

import UIKit

func setupSwizzling() {
  /// Изменяет позиционирование UINavigationBar по вертикали
  setupUINavigationBarSwizzling()
  /// Устанавливает вертикальный отступ для UINavigationBar
  /// Добавляет safe area для увеличенного навбара
  setupUINavigationControllerSwizzling()

  /// Сетка для проверки и сравнения верстки
  setupUINavigationControllerFigmaSwizzling()
}


