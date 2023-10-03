//
//  HomeViewController.swift
//  Bombsweeper
//
//  Created by Sneezy on 2/8/23.
//

import UIKit

//TODO: Make dark mode look decent
//TODO: Change
class HomeViewController: UIViewController {
    let saved = UserDefaults(suiteName: "com.jonesclass.bombsweeper.chirica")
    
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!

    var darkMode = false {
        didSet {
            if darkMode {
                self.view.backgroundColor = UIColor.black
                darkModeLabel.textColor = UIColor.white
                welcomeLabel.textColor = UIColor.white
                print("dark mode on")
            } else {
                self.view.backgroundColor = UIColor.systemBackground
                darkModeLabel.textColor = UIColor.black
                welcomeLabel.textColor = UIColor.black
                print("dark mode off")
            }
        }
    }
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    //var darkMode = ViewController.darkMode
    
    override func viewDidLoad() {
        if let dark = saved?.string(forKey: Saved.darkMode) {
            print("loading")
            darkMode = Bool(dark)!
            darkModeSwitch.isOn = darkMode
        } else {
            print("inside else")
            darkMode = false
        }

        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func easyButtonClicked(_ sender: Any) {
    }
    
    
    @IBAction func mediumButtonClicked(_ sender: Any) {
    }
    
    
    @IBAction func hardButtonClicked(_ sender: Any) {
    }
    
    
    @IBAction func darkModeSwitchClicked(_ sender: Any) {
        darkMode = darkModeSwitch.isOn
        saved?.set("\(darkModeSwitch.isOn)", forKey: Saved.darkMode)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "easySegue" {
            let mainVC = segue.destination as! ViewController
            mainVC.boardSize = 8
            mainVC.saved?.set("\(darkModeSwitch.isOn)", forKey: Saved.darkMode)
        } else if segue.identifier == "mediumSegue" {
            let mainVC = segue.destination as! ViewController
            mainVC.boardSize = 10
            mainVC.saved?.set("\(darkModeSwitch.isOn)", forKey: Saved.darkMode)
        } else if segue.identifier == "hardSegue" {
            let mainVC = segue.destination as! ViewController
            mainVC.boardSize = 12
            mainVC.saved?.set("\(darkModeSwitch.isOn)", forKey: Saved.darkMode)
        } else {
            let instructionsVC = segue.destination as! InstructionsViewController
            instructionsVC.darkMode = darkMode
        }
        
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
