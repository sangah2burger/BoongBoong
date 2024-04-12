//
//  InfoOilBankModel.swift
//  BoongBoong
//
//  Created by 상아이버거 on 4/12/24.
//

import Foundation

// MARK: - Empty
struct InfoOilBankModel: Codable {
    let infoOilBankResult: InfoOilBank

    enum CodingKeys: String, CodingKey {
        case infoOilBankResult = "RESULT"
    }
}

// MARK: - Result
struct InfoOilBank: Codable {
    let infoOilBank: [InfoOilBankList]

    enum CodingKeys: String, CodingKey {
        case infoOilBank = "OIL"
    }
}

// MARK: - Oil
struct InfoOilBankList: Codable {
    let uniID, pollDivCo, gpollDivCo, osNm: String
    let vanAdr, newAdr, tel, siguncd: String
    let lpgYn, maintYn, carWashYn, kpetroYn: String
    let cvsYn: String
    let gisXCoor, gisYCoor: Double
    let oilPrice: [OilPriceOfOilBank]

    enum CodingKeys: String, CodingKey {
        case uniID = "UNI_ID"
        case pollDivCo = "POLL_DIV_CO"
        case gpollDivCo = "GPOLL_DIV_CO"
        case osNm = "OS_NM"
        case vanAdr = "VAN_ADR"
        case newAdr = "NEW_ADR"
        case tel = "TEL"
        case siguncd = "SIGUNCD"
        case lpgYn = "LPG_YN"
        case maintYn = "MAINT_YN"
        case carWashYn = "CAR_WASH_YN"
        case kpetroYn = "KPETRO_YN"
        case cvsYn = "CVS_YN"
        case gisXCoor = "GIS_X_COOR"
        case gisYCoor = "GIS_Y_COOR"
        case oilPrice = "OIL_PRICE"
    }
}

// MARK: - OilPrice
struct OilPriceOfOilBank: Codable {
    let prodcd: String
    let price: Int
    let tradeDt, tradeTm: String

    enum CodingKeys: String, CodingKey {
        case prodcd = "PRODCD"
        case price = "PRICE"
        case tradeDt = "TRADE_DT"
        case tradeTm = "TRADE_TM"
    }
}

