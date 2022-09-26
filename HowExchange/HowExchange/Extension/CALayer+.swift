//
//  UIView+.swift
//  HowExchange
//
//  Created by 정지혁 on 2022/08/29.
//

import Foundation
import UIKit

extension CALayer {
    // 그림자 디자인 적용
    // https://stackoverflow.com/questions/61948721/how-to-implement-a-layer-blur-in-swift
    func applyFigmaShadow(color: UIColor = .black, alpha: Float = 0.1, x: CGFloat = 0, y: CGFloat = 5, blur: CGFloat = 20) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
    }
}
