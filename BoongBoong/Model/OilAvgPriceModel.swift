//
//  OilAvgPriceModel.swift
//  BoongBoong
//
//  Created by 상아이버거 on 4/11/24.
//

import Foundation

// MARK: - Welcome
struct OilAvgPriceModel: Codable {
    let result: Result

    enum CodingKeys: String, CodingKey {
        case result = "RESULT"
    }
}

// MARK: - Result
struct Result: Codable {
    let oil: [Oil]

    enum CodingKeys: String, CodingKey {
        case oil = "OIL"
    }
}

// MARK: - Oil
struct Oil: Codable {
    let tradeDt, prodnm, price: String
    let diff: String

    enum CodingKeys: String, CodingKey {
        case tradeDt = "TRADE_DT"
        case prodnm = "PRODNM"
        case price = "PRICE"
        case diff = "DIFF"
    }
}
