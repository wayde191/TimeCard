import UIKit


func stringCharactersCount(s:String) -> Int
{
    return s.characters.count
}

func stringToInt(s:String) -> Int
{
    if let x = Int(s)
    {
        return x
    }
    return 0
}

func executeSuccessor(f:String -> Int, s:String) -> Int
{
    return f(s).successor()
}

let f1 = stringCharactersCount
let f2 = stringToInt

executeSuccessor(f1, s:"5555")    // 5
executeSuccessor(f2, s:"5555")    // 5556






























