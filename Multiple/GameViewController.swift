//
//  GameViewController.swift
//  Multiple
//
//  Created by Edward Day on 03/09/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import UIKit
import GameplayKit

class GameViewController: UIViewController {
    
    //OUTLETS
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var goBtn: UIButton!
    @IBOutlet weak var multipleLabel: UILabel!
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var penaltiesLabel: UILabel!

    
    //Return to the main menu if a user presses back.
    @IBAction func backButtonTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    //VARIABLES
    let backgroundImage = UIImage(named: "Button")
    var multiple: Int?
    var numbers = [Int]()
    var buttons = [UIButton]()
    
    //Score trackers
    
    var remaining = 8
    var penalties = 0
    
    //Timer Object
    var timer = Timer()

    //Custom color to be used in some UI elements
    let customPurple = UIColor(displayP3Red: 153/255, green: 63/255, blue: 180/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        var multiples = [Int]()
        let multipleRange = multiple! * 12
        
        // Generate 12 random numbers that arent multiples of the chosen number, and add them to an array
        while numbers.count < 12 {
            numbers.append(Int(arc4random_uniform(UInt32(multipleRange))))
            //If the generated number is a multiple of the chosen number, then remove it from the array.
            if numbers[(numbers.count - 1)] % multiple! == 0 {
                numbers.removeLast()
            }
            
        }
        
        //Add all multiples of chosen number up to 12x to an array
        var i = 0
        while multiples.count < 12 {
            i += 1
            multiples.append(multiple! * i)
        }
        
        //Randomly choose 8 of these multiples.
        var randomMultiples = [Int]()
        while randomMultiples.count < 8 {
            let randomNumber = arc4random_uniform(UInt32(multiples.count))
            randomMultiples.append(multiples[Int(randomNumber)])
            multiples.remove(at: Int(randomNumber))
            
        }
        
        //Add the newly generated multiples to the numbers array
        numbers.append(contentsOf: randomMultiples)
        
        
        
        //Shuffle the numbers so they will be layed out randomly
        let shuffledNumbers = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: numbers)

      
        var buttonsi:Int = 0
        
        //X Coordinates for each row of buttons
        var buttonX: CGFloat = 65
        var buttonX2: CGFloat = 139
        var buttonX3: CGFloat = 65
        var buttonX4: CGFloat = 139
        var buttonX5: CGFloat = 65
        
        //Create 20 buttons and lay them out, with each number from the generated numbers.
        while buttonsi < shuffledNumbers.count    {
            
            let button = UIButton()//(frame: CGRect(x: 50, y: buttonY, width: 250, height: 30))
            if buttonsi < 4 {
                button.frame = CGRect(x: buttonX, y: 130, width: 119, height: 119)
                buttonX += 150
            } else if buttonsi < 8 {
                button.frame = CGRect(x: buttonX2, y: 280, width: 119, height: 119)
                buttonX2 += 150
            } else if buttonsi < 12 {
                button.frame = CGRect(x: buttonX3, y: 430, width: 119, height: 119)
                buttonX3 += 150
            } else if buttonsi < 16 {
                button.frame = CGRect(x: buttonX4, y: 580, width: 119, height: 119)
                buttonX4 += 150
            } else {
                button.frame = CGRect(x: buttonX5, y: 730, width: 119, height: 119)
                buttonX5 += 150
            }
            button.isUserInteractionEnabled = true
            button.addTarget(self, action: #selector(GameViewController.numberTap), for: UIControlEvents.touchUpInside)
       //     button.addGestureRecognizer(numberTap)
           // button.layer.cornerRadius = 10
           // button.layer.backgroundColor = UIColor.darkGray.cgColor
            button.setTitleColor(customPurple, for: UIControlState.normal)
            button.titleLabel?.font = UIFont(name: "Intro", size: 48)
            button.setBackgroundImage(backgroundImage, for: UIControlState.normal)
            button.setTitle("\(shuffledNumbers[buttonsi])", for: UIControlState.normal)
            button.isHidden = true
            self.view.addSubview(button)
            buttons.append(button)
            buttonsi += 1
        }
        
        //Show the chosen multiple at the bottom of the screen
        multipleLabel.text = String(multiple!)
        
        
    }
    
    
    
    //When the user presses go then start the game
    @IBAction func goPressed(_ sender: AnyObject) {
        goBtn.isHidden = true
        
        start()
    }
    

    //To start the game, start the timer and make the buttons appear!
    func start() {

        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.processTimer), userInfo: nil, repeats: true)
        
        for button in buttons {
            button.isHidden = false
        }
    }
    
    //Make the time start of as one second
    var time:Int = 1
    
    //Every second...
    //If there are no multiples left then execute the completed function, and if there are multiples left, then add one to the time.
    //If the time reaches 100 seconds then game over!
    func processTimer() {
        if remaining == 0 {
            timer.invalidate()
            gameCompleted()
            return
        }
        timeLabel.text = "Time: \(String(time)) seconds"
        time += 1

        if time > 100 {
            gameOver()
            timer.invalidate()
            return
        }
        
        
    }
    
    
    //User taps a number
    func numberTap(sender: UIButton) {
        
        //If it is a desired multiple then...
        if Double(sender.titleLabel!.text!)!.truncatingRemainder(dividingBy: Double(multiple!)) == 0 {
            //Disable user interaction, subtract 1 from the remaining counter, update the remaining text and make it disappear!
            sender.isUserInteractionEnabled = false
            remaining -= 1
            remainingLabel.text = "Remaining: \(String(remaining))"
            UIView.animate(withDuration: 0.7) {
                sender.alpha = 0.0
            }


        } else {
            //If it is not a multiple and there is a multiple left...
            //Add a penalty, and if the time reaches 100 seconds then game over.
            if remaining > 0 {
                if time < 100 {
            penalties += 1
            penaltiesLabel.text = "Penalties: \(String(penalties))"

            time += 3
            timeLabel.text = "Time: \(String(time)) seconds"
            }
            } else {
                gameOver()
                timer.invalidate()
            }
        }
    }
    


    //GameOver function
    func gameOver() {
        performSegue(withIdentifier: "gameOverVC", sender: self)
        print("Game Over! Better luck next time!")
    }
    
    //Game completed function
    func gameCompleted() {
        
    }
    
    


}
