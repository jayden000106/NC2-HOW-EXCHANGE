//
//  Unit.swift
//  HowExchange
//
//  Created by 정지혁 on 2022/08/30.
//

import Foundation

enum MonetaryUnit: String, CaseIterable {
    case KRW = "KRW(대한민국 원)"
    case USD = "USD(미국 달러)"
    case VND = "VND(베트남 동)"
}

struct ParseResult: Codable {
    var success: Bool
    var timestamp: Int
    var base: String
    var date: String
    var rates: ResultUnit
}

struct ResultUnit: Codable {
    var KRW: Double
    var USD: Double
    var JPY: Double
    var EUR: Double
}
