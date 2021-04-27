//
//  Calculator.swift
//  calc
//
//  Created by Jacktator on 31/3/20.
//  Copyright © 2020 UTS. All rights reserved.
//

import Foundation

class Calculator {

    /// For multi-step calculation, it's helpful to persist existing resul
    //calculation
    func calculate(args: [String]) -> String {
        var cal = args
        var newArgs = [Int] () //new args to store int
        var no1, no2: Int //store first and second number
        var index = 0 //track operator position
        var temp = 0 //store temp resultl
        let result: String //store final result as String
        
        Check(args: cal).checkInput() //check input
        
        //implement only if size of cal is not 0
        while cal.count != 0 {
            //rule 1
            //if "x", "/" and "%" found
            if cal.contains("x") || cal.contains("/") || cal.contains("%") {
                for op in cal { //loop to find position of operator
                    if op == "x" || op == "/" || op == "%"{
                        index = cal.index(of: op)! //store array position to var index
                        
                        no1 = index - 1 //no1 position
                        no2 = index + 1 //no2 position
                        
                        //calculation
                        switch op {
                        case "x":
                            temp = multiply(no1: Int(cal[no1])!, no2: Int(cal[no2])!);
                        case "/":
                            temp = divide(no1: Int(cal[no1])!, no2: Int(cal[no2])!);
                        case "%":
                            temp = modulus(no1: Int(cal[no1])!, no2: Int(cal[no2])!);
                        default:
                            temp = 0;
                        }
                        cal.remove(at: index - 1) //remove the elements that have been calculated
                        cal.remove(at: index - 1)
                        cal.remove(at: index - 1)
                        
                        
                        //cal still contains value, insert at temp anser no1 position
                        if cal.count != 0 {
                            cal.insert(String(temp), at: index - 1)
                        } else {
                            newArgs.append(temp) //add result to new array
                        }
                        break
                    }
                }
            } else if cal.contains("+") || cal.contains("-") {
                for val in cal {
                    if !(val == "+" || val == "-") { //find value
                        index = cal.index(of: val)!; //store index of value
                        
                        if index == 0 { //first value
                            newArgs.append(Int(val)!); //add to new array
                            cal.remove(at: index) //remove that value from cal
                        } else {
                            if cal[index - 1] == "+" { //positive value
                                newArgs.append(Int(val)!) //add to new array
                            }
                            else if cal[index - 1] == "-"{
                                if Int(val)! < 0 { //negative value
                                    newArgs.append(abs(Int(val)!)) //convert negative value to positive //get absolute value by abs()
                                }
                                else{
                                    newArgs.append(-Int(val	)!) //convert positive value to negative
                                }
                            }
                            cal.remove(at: index - 1) //remove element that have been gone through
                            cal.remove(at: index - 1)
                        }
                    }
                }
            } else {
                if cal.count > 1 && Int(cal[0]) == nil{
                    ExceptionHandling(errorInput: cal[index]).invalidInput()
                } else { //only an interger left
                    newArgs.append(Int(cal[0])!) //add int to new array
                    cal.removeAll()
                    
                }
            }
        }
        
        var sumResult: Int = 0 //store sum of all values
        for sum in newArgs { //loop through the int array
            sumResult += sum //addition
        }
        result = String(sumResult) //convert result int -> String
        Check(args: ["\(result)"]).outOfBounds() //out of integer bounds exception handle
        
        return(result) //return final result
    
    } //end calculate()
    
    //multiply function
    func multiply(no1: Int, no2: Int) -> Int {
        return no1 * no2
    }
    
    //division function
    //check divByZero and return result
    func divide(no1: Int, no2: Int) -> Int {
        if no2 == 0 {    //checks for divide operator or modulus division by zero
            ExceptionHandling(errorInput: "").divByZero()
        }
        return no1 / no2
    }
    
    //modulus function
    //check modByZero and return mod
    func modulus(no1: Int, no2: Int) -> Int {
        if no2 == 0 {
            ExceptionHandling(errorInput: "").divByZero()
        }
        return no1 % no2
    }
    
}

//check input
struct Check {
    let index = 0 //used for args[index]
    let args: [String] //array args

    //chech input are valid
    func checkInput() {
        //check input length
        if (args.count % 2 == 0) {
            ExceptionHandling(errorInput: args[index]).invalidInput() //handle exception
        }
        //signle non-numericic input
        if (args.count == 1 && Int(args[0]) == nil)  {
            ExceptionHandling(errorInput: args[index]).invalidInput()
        }
        //non int and null args in array position
        for index in stride(from: 0, to: args.count, by: 2) {
            if Int(args[index]) == nil {
                ExceptionHandling(errorInput: args[index]).invalidInput()
            }
        }
        //check if position of operator is correct
        for op in stride(from: 1, to: args.count, by: 2) {
            if (!(args[op] == "+" || args[op] == "-" || args[op] == "x" || args[op] == "/" || args[op] == "%")) {
                ExceptionHandling(errorInput: args[op]).unknownOperator()
            }
        }
        outOfBounds() //check if result overflow
    }

    //CHeck if result is out of bounds
    func outOfBounds() {
        //loop from 0 - args Size(args.count), increment by 1
        for index in stride(from: 0, to: args.count, by: 1) {
            if let integerSize = Int(args[index]) {
                if integerSize > Int64.max || integerSize < Int64.min {
                    ExceptionHandling(errorInput: joinedArgs).integerOverflow()
                }
            }
        }
    }
}

//Error handling in a centralised environment
struct ExceptionHandling {

    let errorInput: String //error input

    enum CalError: Error {
        //Error types set up
        case invalidInput
        case divByZero
        case unknownOperator
        case integerOverflow
    }

    //error handling functions
    func invalidInput() {
        do {
            throw CalError.invalidInput
        } catch {
            print("Invalid input: \(errorInput)")
            exit(1) //non-zero exist
        }
    }
    //division by zero
    func divByZero() {
        do {
            throw CalError.divByZero
        } catch {
            print("Division by zero")
            exit(1)
        }
    }
    //operatos: +, -, x, /, %
    func unknownOperator() {
        do {
            throw CalError.unknownOperator
        } catch {
            print("Unknown operator: \(errorInput)")
            exit(1)
        }
    }

    //out of bound
    func integerOverflow() {
        do {
            throw CalError.integerOverflow
        } catch {
            print("Integer Overflow: \(errorInput)")
            exit(1)
        }
    }
}
