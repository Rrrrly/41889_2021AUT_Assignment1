//
//  main.swift
//  calc
//
//  Created by Jesse Clark on 12/3/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import Foundation

var args = ProcessInfo.processInfo.arguments //get input from terminal
args.removeFirst() // remove the name of the program
var joinedArgs = args.joined(separator: " ") //connect string by " "
var argsSize = args.count //get args size



let result = Calculator().calculate(args: args)
print(result)


