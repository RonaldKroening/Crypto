//
//  GenVC.swift
//  Crypto
//
//  Created by Ronald Kroening on 6/29/23.
//

import UIKit
import Foundation

class GenVC: UIViewController{
    



    
    struct CustomRandomNumberGenerator: RandomNumberGenerator {
        private var seed: UInt64
        
        init(seed: UInt64) {
            self.seed = seed
        }
        
        mutating func next() -> UInt64 {
            seed = (seed &* 0x5DEECE66D &+ 0xB) & ((1 << 48) - 1)
            return seed
        }
    }
    @IBOutlet weak var sel_lab: UILabel!
    @IBOutlet weak var p_length: UILabel!
    @IBOutlet weak var n_pw_txt: UITextField!
    @IBOutlet weak var slider: UISlider!
    var tableViewData: [String] = []
    @IBOutlet weak var p_want: UILabel!
    

    @IBOutlet var numPassesTF: UITextField!
    
    @IBAction func changed(_ sender: Any) {
        p_length.text = String(Int(slider.value))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the custom cell class
        
        
        // Additional setup code
    }

    
    func makeAllPasswords() -> [String]{
        var pw = [String]()
        let numberOfRows = Int(n_pw_txt.text!)!
        print("number of rows",numberOfRows)
        for i in 0..<numberOfRows {
            pw.append(generate_password(num: Int(p_length.text!)!))
            
        }
        print(pw)
        return pw
    }
    override func prepare(for segue:UIStoryboardSegue, sender:Any?){
        if(segue.identifier == "seguePass"){
            let GDVC = segue.destination as! GeneratedVC
            GDVC.PW = makeAllPasswords()
            print("sent values!")
        }

    }
    func generate_password(num: Int) -> String {
        let alpha = "abcdefghijklmnopqrstuvwxyz"
        let cap_alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let numeric = "1234567890"
        let char = "!@#$%^&*()_+{}|:><?,./;'[]=-`~"
        var password = ""
//        let SEED = Int.random(in: 1...1000000)
//        var generator = CustomRandomNumberGenerator(seed: UInt64(SEED))
        //https://www.youtube.com/watch?v=HqQjj6Ds53c
        let alphabets = [alpha, cap_alpha, char, numeric]
        
        for _ in 0..<num {
            let randomCat = Int.random(in: 0..<4) // Generate a random category index
            let randomIdx = Int.random(in: 0..<alphabets[randomCat].count) // Generate a random index within the selected category
                
            let categoryString = alphabets[randomCat]
            let character = categoryString[categoryString.index(categoryString.startIndex, offsetBy: randomIdx)]
            
            password += String(character)
        }
        
        return password
    }
    
}

