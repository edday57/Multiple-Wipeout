//
//  ViewController.swift
//  Multiple
//
//  Created by Edward Day on 03/09/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    
    var chosenNumber: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonPressed(_ sender: AnyObject) {
        if sender.tag != nil {
            chosenNumber = sender.tag
            performSegue(withIdentifier: "game", sender: self)

    }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let multiple = chosenNumber
        if segue.identifier == "game" {
            let vc = segue.destination as! GameViewController
            vc.multiple = multiple
            
        }
    }
    @IBAction func returnToHome(sender: UIStoryboardSegue) {

        
    }
    /*
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     selectedRecipe = recipes[indexPath.row]
     performSegue(withIdentifier: "detailView", sender: self)
     }
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if(segue.identifier == "detailView") {
     var destinationViewController = segue.destination as! ViewRecipeNavBarVC
     let targetController = destinationViewController.topViewController as! ViewRecipeVC
     targetController.recipe = selectedRecipe
     
     }
     }

 */
    

}

