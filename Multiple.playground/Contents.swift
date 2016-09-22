//: Playground - noun: a place where people can play

import UIKit
import GameplayKit

var multiple = 7
var numbers = [Int]()
var multiples = [Int]()
var multipleRange = multiple * 12


while numbers.count < 12 {

    numbers.append(Int(arc4random_uniform(UInt32(multipleRange))))
    if numbers[(numbers.count - 1)] % multiple == 0 {
        numbers.removeLast()
    }
    
}


var i = 0
while multiples.count < 12 {
i += 1
multiples.append(multiple * i)
}



var randomMultiples = [Int]()
while randomMultiples.count < 8 {
    let randomNumber = arc4random_uniform(UInt32(multiples.count))
    randomMultiples.append(multiples[Int(randomNumber)])
    multiples.remove(at: Int(randomNumber))

}


numbers.append(contentsOf: randomMultiples)


print(numbers)

let shuffledNumbers = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: numbers)

print (shuffledNumbers)


