//
//  OilAvgPriceModel.swift
//  BoongBoong
//
//  Created by 상아이버거 on 4/11/24.
//

import Foundation

// MARK: - Welcome
struct OilAvgPriceModel: Codable {
    let oilAvgresult: OilAvgResult

    enum CodingKeys: String, CodingKey {
        case oilAvgresult = "RESULT"
    }
}

// MARK: - Result
struct OilAvgResult: Codable {
    let oilPrice: [OilPrice]

    enum CodingKeys: String, CodingKey {
        case oilPrice = "OIL"
    }
}

// MARK: - Oil
struct OilPrice: Codable {
    let tradeDt, prodnm, avgPrice: String
    let diff: String

    enum CodingKeys: String, CodingKey {
        case tradeDt = "TRADE_DT"
        case prodnm = "PRODNM"
        case avgPrice = "PRICE"
        case diff = "DIFF"
    }
}
