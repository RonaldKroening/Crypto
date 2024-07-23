//
//  SolutionsVC.swift
//  Crypto
//
//  Created by Ronald Kroening on 9/5/23.
//

import UIKit
//VYICPNCJC VYICANWSB WSFJCUWTOC WV PLWAWSB AY TC HSYPS

class SolutionsVC: UIViewController {
    
    @IBOutlet var ogLab: UITextView!

    @IBOutlet var pathsLab: UILabel!
    
    @IBOutlet var solsLab: UITextView!
    @IBOutlet var exportButton: UIButton!
    var original = String()
    var Sols = [String]()


    @objc private func presentShareSheet(){
        guard let text = solsLab.text else{
            return
        }
        let shareSheetVC = UIActivityViewController(
        activityItems:[text],
            applicationActivities: nil)
    present(shareSheetVC, animated: true)
                
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ogLab.text = original
        
        print("solutons in svc: ",self.Sols)
        solsLab.text = self.Sols.joined(separator: "\n\n")

        exportButton.addTarget(self,action:#selector(presentShareSheet), for:.touchUpInside)
        pathsLab.text = String(self.Sols.count) + " Paths Found"
        
        
        
        
        
        

        //VYICPNCJC VYICANWSB WSFJCUWTOC WV PLWAWSB AY TC HSYPS


    }



    




}
