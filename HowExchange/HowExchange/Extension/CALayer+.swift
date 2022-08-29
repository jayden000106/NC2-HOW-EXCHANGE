//
//  UIView+.swift
//  HowExchange
//
//  Created by 정지혁 on 2022/08/29.
//

import Foundation
import UIKit

extension CALayer {
    func applyFigmaShadow(color: UIColor = .black, alpha: Float = 0.1, x: CGFloat = 0, y: CGFloat = 5, blur: CGFloat = 20) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
    }
}
