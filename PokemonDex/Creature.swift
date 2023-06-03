//
//  Creature.swift
//  PokemonDex
//
//  Created by Lori Rothermel on 6/2/23.
//

import Foundation

struct Creature: Codable, Identifiable {
    let id = UUID().uuidString
    var name: String
    var url: String
    
    enum CodingKeys: CodingKey {
        case name
        case url
    }
}
