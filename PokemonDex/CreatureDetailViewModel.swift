//
//  CreatureDetailViewModel.swift
//  PokemonDex
//
//  Created by Lori Rothermel on 6/2/23.
//

import Foundation

@MainActor
class CreatureDetailViewModel: ObservableObject {
    
    private struct Returned: Codable {
        var height: Double?
        var weight: Double?
        var sprites: Sprite
    }  // struct
    
    struct Sprite: Codable {
        var front_default: String?
        var other: Other
    }  // struct
    
    struct Other: Codable {
        var officialArtwork: OfficialArtwork
        
        enum CodingKeys: String, CodingKey {
            case officialArtwork = "official-artwork"
        }  // enum CodingKeys
        
    }  // struct
    
    struct OfficialArtwork: Codable {
        var front_default: String?
    }  // struct
    
    
    @Published var height = 0.0
    @Published var weight = 0.0
    @Published var imageURL = ""
    
    var urlString = ""
    
    
    func getData() async {
        print("🕸️ We are accessing the url \(urlString)")
        
        // convert urlString to a special URL type
        guard let url = URL(string: urlString) else {
            print("🤬 ERROR: Could not create a URL from \(urlString)")
            return
        }  // guard let url
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            // Try to decode JSON data into our own data structures
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("🤬 JSON ERROR: Could not decode returned JSON data")
                return
            }  // guard let returned
            self.height = returned.height ?? 0.0
            self.weight = returned.weight ?? 0.0
            self.imageURL = returned.sprites.other.officialArtwork.front_default ?? "n/a"
        } catch {
            print("🤬 ERROR: Could not get data from \(urlString)")
        }  // do...catch
        
        
    }  // func getData
    
}

