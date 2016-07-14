//: Playground - noun: a place where people can play

import UIKit


func printInt(i: Int) {
    print("you passed \(i)")
}

let funVar = printInt

func useFunction(funParam: (Int) -> () ) {
    funParam(3)
}

// You can call this new function passing in either
// the original function:
useFunction(printInt)
// or the variable
//useFunction(funVar)




func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}

//func incrementer() -> Int {
//    runningTotal += amount
//    return runningTotal
//}

let incrementByTen = makeIncrementer(forIncrement: 10)

incrementByTen()
incrementByTen()











