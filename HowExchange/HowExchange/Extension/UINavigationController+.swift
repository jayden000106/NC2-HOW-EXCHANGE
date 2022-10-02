//
//  UINavigationController+.swift
//  HowExchange
//
//  Created by 정지혁 on 2022/10/02.
//

import Foundation
import UIKit

// Custom Navigation View에서 Swipe-back 가능하게 하기
// https://medium.com/hcleedev/swift-custom-navigationview%EC%97%90%EC%84%9C-swipe-back-%EA%B0%80%EB%8A%A5%ED%95%98%EA%B2%8C-%ED%95%98%EA%B8%B0-c3c519c59bcb
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
