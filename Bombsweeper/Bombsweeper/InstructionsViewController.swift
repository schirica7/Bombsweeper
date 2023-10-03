//
//  InstructionsViewController.swift
//  Bombsweeper
//
//  Created by Sneezy on 2/22/23.
//

import UIKit

class InstructionsViewController: UIViewController {
    var darkMode = false {
        didSet {
            if darkMode {
                self.view.backgroundColor = UIColor.black
                instructionsLabel.textColor = UIColor.white
            } else {
                self.view.backgroundColor = UIColor.systemBackground
                instructionsLabel.textColor = UIColor.black
            }
        }
    }
    
    
    @IBOutlet weak var instructionsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
