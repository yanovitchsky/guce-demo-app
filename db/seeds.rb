module Seeds
  def self.seed_pokemons(db)
    pokemons = [
      { name: 'Bulbasaur', type_primary: 'Grass', type_secondary: 'Poison' },
      { name: 'Ivysaur', type_primary: 'Grass', type_secondary: 'Poison' },
      { name: 'Venusaur', type_primary: 'Grass', type_secondary: 'Poison' },
      { name: 'Charmander', type_primary: 'Fire', type_secondary: nil },
      { name: 'Charmeleon', type_primary: 'Fire', type_secondary: nil },
      { name: 'Charizard', type_primary: 'Fire', type_secondary: 'Flying' },
      { name: 'Squirtle', type_primary: 'Water', type_secondary: nil },
      { name: 'Wartortle', type_primary: 'Water', type_secondary: nil },
      { name: 'Blastoise', type_primary: 'Water', type_secondary: nil },
      { name: 'Pikachu', type_primary: 'Electric', type_secondary: nil }
    ]

    ds = db[:pokemons]
    pokemons.each { |p| ds.insert(p) }
  end
end


