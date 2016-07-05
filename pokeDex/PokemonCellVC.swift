//
//  PokemonCellVC.swift
//  pokeDex
//
//  Created by Oscar Arnaiz on 21/06/2016.
//  Copyright © 2016 Oscar Arnaiz. All rights reserved.
//

import UIKit

class PokemonCellVC: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg:UIImageView!
    @IBOutlet weak var nameLbl:UILabel!
    
    var pokemon: Pokemon!
    
    func configureCell(pokemon: Pokemon) {
        self.pokemon = pokemon
        nameLbl.text = self.pokemon.name.capitalizedString
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
}
