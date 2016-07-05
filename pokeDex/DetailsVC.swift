//
//  DetailsVC.swift
//  pokeDex
//
//  Created by Oscar Arnaiz on 22/06/2016.
//  Copyright © 2016 Oscar Arnaiz. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController {
    
    @IBOutlet weak var backbtn:UIButton!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var currentEvoImg:UIImageView!
    @IBOutlet weak var nextEvoLbl: UILabel!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var currentEveImg: UIImageView!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokeDexIdLbl: UILabel!
    @IBOutlet weak var defenseAttackLbl: UILabel!
    
    var passedValue: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = passedValue.name.capitalizedString
        let img = UIImage(named: "\(passedValue.pokedexId)")
        mainImg.image = img
        currentEveImg.image = img
        passedValue.downloadPokemonDetails { () -> () in
            //This will be trigger once download is complete
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        weightLbl.text = passedValue.weight
        descriptionLbl.text = passedValue.description
        typeLbl.text = passedValue.type
        defenseLbl.text = "\(passedValue.defense)"
        heightLbl.text = passedValue.height
        pokeDexIdLbl.text = "\(passedValue.pokedexId)"
        defenseAttackLbl.text = "\(passedValue.attack)"
        if passedValue.nextEvolutionId == "" {
            nextEvoLbl.text = "No evolution"
            nextEvoImg.hidden = true
        } else {
            nextEvoImg.hidden = false
            var nextEvoStr = passedValue.nextEvolutionTxt
            
            let evoImg = "\(passedValue.nextEvolutionId)"
            nextEvoImg.image=UIImage(named: evoImg)
            if passedValue.nextEvolutionLvl != "" {
                nextEvoStr += " - LVL \(passedValue.nextEvolutionLvl)"
            }
            nextEvoLbl.text = "Next evolution: \(nextEvoStr)"
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print(passedValue.name)
    }

    @IBAction func backBtn(sender: AnyObject){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
