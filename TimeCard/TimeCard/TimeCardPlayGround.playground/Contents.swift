import UIKit

extension RangeReplaceableCollectionType where Generator.Element : Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(object : Generator.Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}

var members = ["Li Xufei",
    "Zhang Mingyun",
    "Cao Yangyang",
    "Chen Yu Wuhan Dev",
    "Gu Chao",
    "Wang Zhi Tupi",
    "Sun Wei Wayde",
    "Wang Tianyi",
    "Li Hongjing"]

members.removeAtIndex(0)

members

var a = 1
"abc\(a)"




















