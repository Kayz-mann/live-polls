//
//  Option.swift
//  LivePolls
//
//  Created by Balogun Kayode on 05/11/2025.
//

import Foundation

struct Option: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    var count: Int
    var name: String
}
