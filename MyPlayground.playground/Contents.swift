//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var arr1 = [1,2,3,5,6,6,7]
var arr2 = [2,2,3,3,4,5,6]
var arr3 = [1,2,2,3,3,4,4,6,7]

var newArr: [Int] = []
newArr.append(contentsOf: arr1)
newArr.append(contentsOf: arr2)
newArr.append(contentsOf: arr3)

print(newArr)

var newestArr: [Int] = [0]
for item in newArr {
    for newItem in newestArr {
        if item != newItem {
            print(newestArr)
            newestArr.append(item)
        } else {
            break
        }
    }
}

//print(newestArr)

