//
//  CategoryPointModel.swift
//  BoongBoong
//
//  Created by 상아이버거 on 4/11/24.
//

import Foundation

// MARK: - CategoryPointModel
struct CategoryPointModel: Codable {
    let categorydocuments: [CategoryDocument]
    let categorymeta: CategoryMeta
}

// MARK: - Document
struct CategoryDocument: Codable {
    let addressName: String
    let categoryGroupCode: CategoryGroupCode
    let categoryGroupName: CategoryGroupName
    let categoryName, distance, id, phone: String
    let placeName: String
    let placeURL: String
    let roadAddressName, x, y: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case categoryName = "category_name"
        case distance, id, phone
        case placeName = "place_name"
        case placeURL = "place_url"
        case roadAddressName = "road_address_name"
        case x, y
    }
}

enum CategoryGroupCode: String, Codable {
    case categoryGroupCode = "OL7"
}

enum CategoryGroupName: String, Codable {
    case categoryGropuName = "주유소,충전소"
}

// MARK: - Meta
struct CategoryMeta: Codable {
    let isEnd: Bool
    let pageableCount: Int
    let sameName: CategoryJSONNull?
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case sameName = "same_name"
        case totalCount = "total_count"
    }
}

// MARK: - Encode/decode helpers

class CategoryJSONNull: Codable, Hashable {

    public static func == (lhs: CategoryJSONNull, rhs: CategoryJSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(CategoryJSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

