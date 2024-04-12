//
//  CoordModel.swift
//  BoongBoong
//
//  Created by 한수빈 on 4/12/24.
//

import Foundation

import Foundation

struct CoordModel: Codable {
    let meta: Meta?
    let documents: [Document]

}

// MARK: - Document
struct Document: Codable {
    let x, y: Double
}

struct Meta: Codable {
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
    }
}
