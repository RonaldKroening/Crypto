//
//  EnVC.swift
//  Crypto
//
//  Created by Ronald Kroening on 6/29/23.
//

import Foundation
import UIKit

class EnVC : UIViewController{
    
    var input : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
        
        
        
        
    }
    func uniqueCharacters(_ input: String) -> [Character] {
        var uniqueChars: [Character] = []
        for char in input {
            if (!uniqueChars.contains(char) && char != " ") {
                uniqueChars.append(char)
            }
        }
        return uniqueChars
    }
    
    func generateCharacterMapping(_ uniqueChars: [Character]) -> [Character: Character] {
        var characterMapping: [Character: Character] = [:]
        var availableAlphabet = Set("abcdefghijklmnopqrstuvwxyz")
        
        for char in uniqueChars {
            if let replacementChar = availableAlphabet.popFirst() {
                characterMapping[char] = replacementChar
            }
        }
        
        return characterMapping
    }
    
    func mapStringWithDictionary(_ input: String, _ characterMapping: [Character: Character]) -> String {
        let mappedString = input.map { characterMapping[$0] ?? $0 }
        return String(mappedString)
    }
    
    // Example usage:
    
    func encrypt(inputString : String) -> String{
        return mapStringWithDictionary(inputString, generateCharacterMapping(uniqueCharacters(inputString)))
    }
    
}
