//
//  ViewController.swift
//  pokeDex
//
//  Created by Oscar Arnaiz on 21/06/2016.
//  Copyright © 2016 Oscar Arnaiz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    
    @IBOutlet weak var collection:UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemonArray = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var isSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
        parsePokemonCSV()
    }
    
    func parsePokemonCSV(){
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")
        
        do {
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            for row in rows{
                let pokeDexId = Int(row["id"]!)!
                let namePokemon = row["identifier"]!
                let newPokemon = Pokemon(name: namePokemon, pokedexId: pokeDexId)
                pokemonArray.append(newPokemon)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearchMode {
            return filteredPokemon.count
        } else {
            return pokemonArray.count
        }
        
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if isSearchMode {
            performSegueWithIdentifier("openDetails", sender: filteredPokemon[indexPath.row])
        } else {
            performSegueWithIdentifier("openDetails", sender: pokemonArray[indexPath.row])
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "openDetails") {
            let svc = segue.destinationViewController as! DetailsVC
            
            if let pokemonSelected = sender as? Pokemon {
                svc.passedValue = pokemonSelected
            }
            
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokemonCellVC {
            
            let poke: Pokemon!
            
            if isSearchMode {
                poke = filteredPokemon[indexPath.row]
            } else {
                poke = pokemonArray[indexPath.row]
            }
            
            cell.configureCell(poke)
            return cell
        } else {
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // No need to search again since it is trigger by textDidChange
        view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            isSearchMode = false
            view.endEditing(true) // to hide keyboard
            collection.reloadData()
        } else {
            isSearchMode = true
            let lower = searchBar.text!.lowercaseString
            filteredPokemon = pokemonArray.filter({$0.name.rangeOfString(lower) != nil})
            collection.reloadData()
        }
    }
}

