//
//  DeVC.swift
//  Crypto
//
//  Created by Ronald Kroening on 6/29/23.
//

import Foundation
import UIKit
import Vision


class DeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var cryptext = "";
    var Solutions = [String]()
    var pathsSeen = 0
    var Numrex = [String: [String]]()
    var dictionarySet = [String]()
    
    //VYICPNCJC VYICANWSB WSFJCUWTOC WV PLWAWSB AY TC HSYPS
    
    @IBOutlet weak var display_label: UILabel!
    @IBOutlet weak var cryptIn: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func getCameraPhoto(_ sender: Any) {
        showPhotoMenu()
        

    }
    func showPhotoMenu() {
        
      let alert = UIAlertController(title: nil, message: nil,
                           preferredStyle: .actionSheet)

      let actCancel = UIAlertAction(title: "Cancel", style: .cancel,
                                  handler: nil)
      alert.addAction(actCancel)

      let actLibrary = UIAlertAction(title: "Choose From Library",
                                     style: .default, handler: { (UIAlertAction) in
                                        //api call, buyVoucher
                                        self.choosePhotoFromLibrary()
                                })
      alert.addAction(actLibrary)

      present(alert, animated: true, completion: nil)
    }

    func choosePhotoFromLibrary() {
      let imagePicker = UIImagePickerController()
      imagePicker.sourceType = .photoLibrary
      imagePicker.delegate = self
      imagePicker.allowsEditing = true
      present(imagePicker, animated: true, completion: nil)
    }

    //VYICPNCJC VYICANWSB WSFJCUWTOC WV PLWAWSB AY TC HSYPS
    
    @IBAction func finishedAdding(_ sender: Any) {
        self.cryptext = (cryptIn.text?.uppercased())!
        self.display_label.text = self.cryptext
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        self.cryptext = (cryptIn.text?.uppercased())!
        self.display_label.text = self.cryptext
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                // Handle the selected image (e.g., display it in an image view)
                let usedImg = selectedImage
                let request = VNRecognizeTextRequest { (request, error) in
                            if let error = error {
                                print("Error: \(error)")
                                return
                            }

                            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                                return
                            }

                            var extractedText = ""
                            for observation in observations {
                                guard let topCandidate = observation.topCandidates(1).first else {
                                    continue
                                }

                                extractedText += topCandidate.string
                            }

                            DispatchQueue.main.async {
                                self.cryptext = extractedText
                            }
                        }

                        // Create an image request handler
                        let handler = VNImageRequestHandler(cgImage: usedImg.cgImage!, options: [:])

                        // Perform the request
                        do {
                            try handler.perform([request])
                        } catch {
                            print("Error: \(error)")
                        }
                    }
            }


        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // Handle cancel action (e.g., dismiss the image picker)
            picker.dismiss(animated: true, completion: nil)
        }
    

    func isValid(input: String) -> Bool {
        let words = input.split(separator: " ")

        var wordCount = 0
        var uniqueLetters = Set<Character>()
        
        for word in words {
            wordCount += 1
            let lettersInWord = Set(word.filter { $0.isLetter })
            uniqueLetters.formUnion(lettersInWord)
        }
        

        if wordCount > 3 && uniqueLetters.count > 5 {
            return true
        } else {
            return false
        }
    }
    func get_numrexes(n:String)-> [String]{
        if(Numrex[n] != nil){
            return Numrex[n]!
        }else{
            return [""]
        }
    }
    func frequency(text: String) -> [Character: Int] {
        var frequency = [Character: Int]()
        
        for letter in text {
            if !(". ".contains(letter)) {
                var f = 0
                if let existingFrequency = frequency[letter] {
                    f = existingFrequency
                }
                frequency[letter] = f + 1
            }
        }
        
        return frequency
    }
    
    func match(_ word1: String, _ word2: String) -> Bool {
        if word1.count != word2.count {
            return false
        } else {
            let A = Array(word1)
            let B = Array(word2)
            for i in 0..<A.count {
                if A[i] != B[i] && A[i] != "." {
                    return false
                }
            }
            return true
        }
    }
    
    func dictionariesClash(_ dict1: [Character: Character], _ dict2: [Character: Character]) -> Bool {
        for (key, value1) in dict1 {
            if let value2 = dict2[key], value1 != value2 {
                return true
            }
        }
        return false
    }
    
    func next(Frequency: [Character: Int], OPTIONS: [String: [String]], cryptext: String, SOLVED: String) -> String? {
        var C = cryptext.components(separatedBy: " ")
        let S = SOLVED.components(separatedBy: " ")
        var new_C = [String]()
        
        for x in 0..<S.count {
            let word = S[x]
            if !wordInDictionary(word) && word.contains(".") {
                new_C.append(C[x])
            }
        }
        
        C = new_C
        var bestWord: String? = nil
        var bestScore: Double = 0.0
        
        for word in C {
            var score: Double = 0.0
            for letter in word {
                if SOLVED.contains(String(letter)) == false{
                    if let letterFrequency = Frequency[letter] {
                        score += Double(letterFrequency)
                    }
                }
            }
            
            if let options = OPTIONS[word], !options.isEmpty {
                score /= Double(options.count)
                if score > bestScore || bestWord == nil {
                    bestWord = word
                    bestScore = score
                }
            }
        }
        
        return bestWord
    }
    
    
    func loadDictionary() -> [Any]? {
        if let path = Bundle.main.path(forResource: "dictionary", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: path, encoding: .utf8)
                
                // Split the contents into lines
                let lines = contents.components(separatedBy: .newlines)
                
                var numrex = [String: [String]]()
                var dictionary = [String]()
                for line in lines {
                    // Split each line by whitespaces
                    var components = line.components(separatedBy: .whitespaces)
                    
                    
                    if components.count >= 2 {
                        // Remove the first element to create the key
                        let key = String(components[0])
                        
                        // Join the rest of the components as the value
                        let value = Array(components[1...])
                        
                        numrex[key] = value
                        
                        components.remove(at: 0)
                        
                        for v in components{
                            dictionary.append(v)
                        }
                    }
                }
                
                return [numrex, dictionary]
            } catch {
                print("Error loading dictionary file: \(error.localizedDescription)")
                return nil
            }
        }
        
        return nil
    }
    
    
    
    func wordInDictionary(_ word: String) -> Bool {
        if word.count < 2 {
            return "A I".contains(word.uppercased())
        } else {
            let DICT = dictionarySet.joined(separator: " ")
            return DICT.contains(word)
        }
    }
    
    
    func limitOptions(_ options: inout [String: [String]], _ solved: String, _ cryptext: String) {
        let C = cryptext.split(separator: " ")
        let S = solved.split(separator: " ")
        for x in 0..<S.count {
            let optkeys = options.keys.joined(separator: " ")
            if optkeys.contains(String(C[x])) && !wordInDictionary(String(C[x])) {
                if let O = options[String(C[x])] {
                    var newO = [String]()
                    for option in O {
                        let st = newO.joined(separator: " ")
                        if match(String(S[x]), option) && !st.contains(option) {
                            newO.append(option)
                        }
                    }
                    
                    options[String(S[x])] = newO
                }
            }
        }
    }
    
    func numrex(_ word: String) -> String {
        var d = [Character: String]()
        var itr = 0
        var mutableWord = word
        
        for letter in word {
            if d[letter] == nil {
                d[letter] = String(itr)
                mutableWord = mutableWord.replacingOccurrences(of: String(letter), with: d[letter]!)
                itr += 1
            } else {
                mutableWord = mutableWord.replacingOccurrences(of: String(letter), with: d[letter]!)
            }
        }
        
        return mutableWord
    }
    
    func decrypt(_ cryptext: String, _ mapping: [Character: Character], _ OPTIONS : [String: [String]] ) -> [String] {
        var SOLVED = ""
        var Left = [Character]()
        
        for letter in cryptext {
            if let mappedLetter = mapping[letter] {
                SOLVED.append(mappedLetter)
            } else if letter == " " {
                SOLVED.append(letter)
            } else {
                SOLVED.append(".")
                Left.append(letter)
            }
        }
        
        if !SOLVED.contains(".") {
            for word in SOLVED.split(separator: " ") {
                if !wordInDictionary(String(word)) {
                    return []
                }
            }
            return [SOLVED]
        } else {
            for word in SOLVED.split(separator: " ") {
                if !word.contains(".") {
                    if !wordInDictionary(String(word)) {
                        return []
                    }
                }
            }
            
            let C = cryptext.split(separator: " ")
            var Frequency = frequency(text: cryptext)
            var OPTIONS = OPTIONS
            if OPTIONS.isEmpty {
                for word in C {
                    OPTIONS[String(word)] = Numrex[numrex(String(word))]
                }
            } else {
                limitOptions(&OPTIONS, SOLVED, cryptext)
            }

            var bestWord: String? = next(Frequency: Frequency, OPTIONS: OPTIONS, cryptext: cryptext, SOLVED: SOLVED)
            
            if bestWord == nil {
                return []
            }
            
            var ALL_PATHS = [String]()
            
            if var options = OPTIONS[bestWord!] {
                for option in options {
                    var M = [Character: Character]()
                    for (index, character) in option.enumerated() {
                        M[bestWord![bestWord!.index(bestWord!.startIndex, offsetBy: index)]] = character
                    }
                    var canCheck = true
                    if self.dictionariesClash(mapping, M) {
                        canCheck = false
                    }
                    if canCheck {
                        var combined = mapping
                        for (key, value) in M {
                            combined[key] = value
                        }
                        var Paths = self.decrypt(cryptext, combined, OPTIONS)
                        if !Paths.isEmpty {
                            ALL_PATHS += Paths
                        }
                    }
                }
            }
            return ALL_PATHS
        }
    }
    
    
    func solve()-> [String]{
        let C = loadDictionary()!
        self.dictionarySet = C[1] as![String]
        self.Numrex = C[0] as! [String: [String]]
        
        if(cryptext != ""){
            let words = cryptext.split(separator: " ")

            var numPaths = 1
            
            for str in Array(words) {
                var count = get_numrexes(n: String(str)).count
                numPaths = numPaths * count
            }
            var MAPS = [Character:Character]()
            var OPTS = [String: [String]]()
            
            let S = decrypt(cryptext, MAPS, OPTS)
            print("Solutions in devc: "+S.joined(separator: " "))
            return S
        }
        
        
        return []
    }
    override func prepare(for segue:UIStoryboardSegue, sender:Any?){
        if(segue.identifier == "segueSolutions"){
            let SolutionsVC = segue.destination as! SolutionsVC
            SolutionsVC.Sols = self.solve()
            self.Solutions = SolutionsVC.Sols
            SolutionsVC.original = self.cryptext
            print("sent values!")
        }

    }
}



//use this: https://developer.apple.com/documentation/vision/recognizing_text_in_images
