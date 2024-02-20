//
//  ColorTheme.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 20/2/24.
//

import Foundation
import UIKit

final class ColorTheme {
    struct Background {
        static let primary: UIColor = .init(light: .init(hex: "#ededf2"), dark: .init(hex: "#5e5e60"))
        static let secondary: UIColor = .init(light: .init(hex: "#f6f6f6"), dark: .init(hex: "#a5a5a9"))
    }

    struct Button {
        static let accessory: UIColor = .init(light: .init(hex: "#8e6048"), dark: .init(hex: "#48768e"))
    }
}
