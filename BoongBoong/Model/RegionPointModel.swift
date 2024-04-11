//
//  RegionPointModel.swift
//  BoongBoong
//
//  Created by 한수빈 on 4/10/24.
//

import Foundation

// MARK: - Welcome
struct RegionPointModel: Codable {
    var regionDocuments: [RegionDocument]
    let regionMeta: RegionMeta
}

// MARK: - Document
struct RegionDocument: Codable {
    let address: Address
    let addressName, addressType: String
    let roadAddress: RegionJSONNull?
    let x, y: String

    enum CodingKeys: String, CodingKey {
        case address
        case addressName = "address_name"
        case addressType = "address_type"
        case roadAddress = "road_address"
        case x, y
    }
}

// MARK: - Address
struct Address: Codable {
    let addressName, bCode, hCode, mainAddressNo: String
    let mountainYn, region1DepthName, region2DepthName, region3DepthHName: String
    let region3DepthName, subAddressNo, x, y: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case bCode = "b_code"
        case hCode = "h_code"
        case mainAddressNo = "main_address_no"
        case mountainYn = "mountain_yn"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthHName = "region_3depth_h_name"
        case region3DepthName = "region_3depth_name"
        case subAddressNo = "sub_address_no"
        case x, y
    }
}

// MARK: - Meta
struct RegionMeta: Codable {
    let isEnd: Bool
    let pageableCount, totalCount: Int

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}

// MARK: - Encode/decode helpers

class RegionJSONNull: Codable, Hashable {

    public static func == (lhs: RegionJSONNull, rhs: RegionJSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(RegionJSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
