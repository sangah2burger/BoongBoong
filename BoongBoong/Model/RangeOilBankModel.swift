//
//  RangeOilBankModel.swift
//  BoongBoong
//
//  Created by 상아이버거 on 4/12/24.
//

import Foundation

// MARK: - Empty
struct RangeOilBankModel: Codable {
    let rangeOilBankResult: RangeOilBankResult

    enum CodingKeys: String, CodingKey {
        case rangeOilBankResult = "RESULT"
    }
}

// MARK: - Result
struct RangeOilBankResult : Codable {
    let rangeOilBank: [RangeOilBank]

    enum CodingKeys: String, CodingKey {
        case rangeOilBank = "OIL"
    }
}

// MARK: - Oil
struct RangeOilBank: Codable {
    let uniID, pollDivCD, osNm: String
    let price: Int
    let distance, gisXCoor, gisYCoor: Double

    enum CodingKeys: String, CodingKey {
        case uniID = "UNI_ID"
        case pollDivCD = "POLL_DIV_CD"
        case osNm = "OS_NM"
        case price = "PRICE"
        case distance = "DISTANCE"
        case gisXCoor = "GIS_X_COOR"
        case gisYCoor = "GIS_Y_COOR"
    }
}
