//
//  GeneratedVC.swift
//  Crypto
//
//  Created by Ronald Kroening on 9/5/23.
//

import UIKit
//VYICPNCJC VYICANWSB WSFJCUWTOC WV PLWAWSB AY TC HSYPS

class GeneratedVC: UIViewController {
    
    
    @IBOutlet var exportButton: UIButton!
    @IBOutlet var passwordsLabel: UITextView!
    @IBOutlet var passNumLab: UILabel!
    var PW = [String]()


    @objc private func presentShareSheet(){
        guard let text = passwordsLabel.text else{
            return
        }
        let shareSheetVC = UIActivityViewController(
        activityItems:[text],
            applicationActivities: nil)
    present(shareSheetVC, animated: true)
                
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()



        exportButton.addTarget(self,action:#selector(presentShareSheet), for:.touchUpInside)
        passNumLab.text = String(self.PW.count) + " Passwords Generated"
        passwordsLabel.text = self.PW.joined(separator: "\n\n")
        
        
        
        
        
        

        //VYICPNCJC VYICANWSB WSFJCUWTOC WV PLWAWSB AY TC HSYPS


    }



    




}
