struct PokemonList: Decodable {
    let results: [Pokemon]
}

struct Pokemon: Decodable {
    let name: String
    let url: String
}

struct PokemonData: Decodable, Identifiable {
    let id: Int
    let name: String
    let sprites: Sprites
}

struct Sprites: Decodable {
    let front_default: String
}
