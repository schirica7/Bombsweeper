//
//  ViewController.swift
//  Bombsweeper
//
//  Created by Sneezy on 1/17/23.
//

import UIKit

enum Saved {
    static let darkMode = "com.jonesclass.chirica.bombsweeper.dark"
    static let easyBest = "com.jonesclass.chirica.bombsweeper.easybest"
    static let mediumBest = "com.jonesclass.chirica.bombsweeper.mediumbest"
    static let hardBest = "com.jonesclass.chirica.bombsweeper.hardbest"
}

class ViewController: UIViewController {
    let saved = UserDefaults(suiteName: "com.jonesclass.bombsweeper.chirica")
    
    //override var navigationController: UINavigati
    var buttons: [Button] = []
    var board: Board
    var boardSize: Int = 0
    let buttonMargin: CGFloat = 2.0
    var oneSecondTimer: Timer?
    var firstClick = true
    var flagMode = false
    var darkMode = false {
        didSet {
            if darkMode {
                self.view.backgroundColor = UIColor.black
                timeLabel.textColor = UIColor.white
                movesLabel.textColor = UIColor.white
                fastestTimeLabel.textColor = UIColor.white
                buttonToolbar.barTintColor = UIColor.black
            } else {
                self.view.backgroundColor = UIColor.systemBackground
                timeLabel.textColor = UIColor.black
                movesLabel.textColor = UIColor.black
                fastestTimeLabel.textColor = UIColor.black
                buttonToolbar.barTintColor = UIColor.white
            }
        }
    }
    var paused = false {
        didSet {
            if !paused {
                playPauseBarButtonItem.title = "Pause"
                playPauseBarButtonItem.tintColor = UIColor.systemBlue
            } else {
                playPauseBarButtonItem.title = "Play"
                playPauseBarButtonItem.tintColor = UIColor.red
            }
        }
    }
    var difficulty = "Easy"
    
    var moves: Int = 0 {
        didSet {
            movesLabel.text = "Moves: \(moves)"
        }
    }
    var timeTaken: Int = 0 {
        didSet {
            if timeTaken % 60 < 10 {
                timeLabel.text = "Time: \(timeTaken/60):0\(timeTaken%60)"
            } else {
                timeLabel.text = "Time: \(timeTaken/60):\(timeTaken%60)"
            }
            
            if timeTaken >= 60 {
                timeLabel.textColor = UIColor.red
            } else if timeTaken >= 30 {
                timeLabel.textColor = UIColor.systemBlue
            } else {
                if (!darkMode) {
                    timeLabel.textColor = UIColor.black
                } else {
                    timeLabel.textColor = UIColor.white
                }
            }
        }
    }
    
    var easyBestTime: Int = 0 {
        didSet {
            if easyBestTime % 60 < 10 {
                fastestTimeLabel.text = "Fastest Time: \(easyBestTime/60):0\(easyBestTime%60)"
            } else {
                fastestTimeLabel.text = "Fastest Time: \(easyBestTime/60):\(easyBestTime%60)"
            }
        }
    }
    var mediumBestTime: Int = 0 {
        didSet {
            if mediumBestTime % 60 < 10 {
                fastestTimeLabel.text = "Fastest Time: \(mediumBestTime/60):0\(mediumBestTime%60)"
            } else {
                fastestTimeLabel.text = "Fastest Time: \(mediumBestTime/60):\(mediumBestTime%60)"
            }
        }
    }
    var hardBestTime: Int = 0 {
        didSet {
            if hardBestTime % 60 < 10 {
                fastestTimeLabel.text = "Fastest Time: \(hardBestTime/60):0\(hardBestTime%60)"
            } else {
                fastestTimeLabel.text = "Fastest Time: \(hardBestTime/60):\(hardBestTime%60)"
            }
        }
    }
    
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playPauseBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var flagModeBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var fastestTimeLabel: UILabel!
    @IBOutlet weak var buttonToolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        board = Board(size: boardSize)
        startNewGame(action: nil)
        
        if let dark = saved?.string(forKey: Saved.darkMode) {
            darkMode = Bool(dark)!
        }
        
        if boardSize == 8 {
            difficulty = "Easy"
        } else if boardSize == 10 {
            difficulty = "Medium"
        } else if boardSize == 12{
            difficulty = "Hard"
        } else {
            print("Board size: \(boardSize)")
        }
        
        initializeBoard(difficulty: difficulty, action: nil)
        for button in buttons {
            button.setTitleColor(labelColor(button: button), for: .normal)
        }
        
        if difficulty == "Easy" {
            if let easyBest = saved?.string(forKey: Saved.easyBest) {
                easyBestTime = Int(easyBest)!
            }
        } else if difficulty == "Medium" {
            if let mediumBest = saved?.string(forKey: Saved.mediumBest) {
                mediumBestTime = Int(mediumBest)!
            }
        } else if difficulty == "Hard" {
            if let hardBest = saved?.string(forKey: Saved.hardBest) {
                hardBestTime = Int(hardBest)!
            }
        }
    }
    
    
    @IBAction func newGameButtonPressed(_ sender: Any) {
        print("New Game Pressed")
        startNewGame(action: nil)
    }
    
    
    
    
    @IBAction func flagModeButtonPressed(_ sender: Any) {
        flagMode = !flagMode
        
        if (flagMode) {
            flagModeBarButtonItem.tintColor = UIColor.red
        } else {
            flagModeBarButtonItem.tintColor = UIColor.systemBlue
        }
    }
    
    
    @IBAction func playPauseButtonPressed(_ sender: Any) {
        //paused = !paused
        
        if (!paused) {
            oneSecondTimer?.invalidate()
            oneSecondTimer = nil
            playPauseBarButtonItem.title = "Play"
            playPauseBarButtonItem.tintColor = UIColor.red
            
            for button in buttons {
                button.isEnabled = false
            }
            paused = true
        } else {
            playPauseBarButtonItem.title = "Pause"
            playPauseBarButtonItem.tintColor = UIColor.systemBlue
            
            if !firstClick {
                oneSecondTimer?.invalidate()
                oneSecondTimer = nil
                oneSecondTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.oneSecond), userInfo: nil, repeats: true)
            }
            
            for button in buttons {
                button.isEnabled = true
            }
            paused = false
        }
    }
    
    
    required init(coder aDecoder: NSCoder) {
        board = Board(size: boardSize)
        
        super.init(coder: aDecoder)!
    }
    
    
    @objc func initializeBoard(difficulty: String, action: UIAlertAction!) {
        //self.difficulty = difficulty
        
        //board.squares = []
        if difficulty == "Easy" {
            boardSize = 8
            //board.size = 8
        } else if difficulty == "Medium" {
            boardSize = 10
            //board.size = 10
        } else {
            boardSize = 12
            //board.size = 15
        }
        
        //board.resetBoard()
        //board = nl
        
        for row in 0..<boardSize {
            for column in 0..<boardSize {
                let square = board.squares[row][column]
                let buttonSize: CGFloat = (boardView.frame.width - buttonMargin * CGFloat(boardSize - 1))/CGFloat(boardSize)
                let button = Button(size: buttonSize, margin: buttonMargin, square: square)
                button.backgroundColor = UIColor(red: 48/255, green: 213/255, blue: 200/255, alpha: 1.0)
                button.addTarget(self, action: #selector(self.buttonPressed(_:)), for: .touchUpInside)
                
                buttons.append(button)
                boardView.addSubview(button)
                //changeLabelColor(button: button)
            }
        }
        //startNewGame(action: nil)
    }
    
    
    
    @objc func buttonPressed(_ button: Button) {
        //print("Row: \(button.square.row), Column: \(button.square.column)")
        if !flagMode {
            if !button.square.isFlagged {
                if firstClick {
                    /*if button.square.adjacentBombs != 0 {
                     startNewGame(action: nil)
                     buttonPressed(button)
                     }*/
                    
                    if button.square.isBomb {
                        button.square.isBomb = false
                        button.square.adjacentBombs = 0
                        
                        for square in board.getNeighbors(square: button.square) {
                            if square.adjacentBombs != 0 {
                                square.adjacentBombs -= 1
                            }
                            
                        }
                        autoClick(button: button)
                    } else {
                        print("inside else")
                        if button.square.adjacentBombs != 0 {
                            button.square.adjacentBombs = 0
                            
                            for square in board.getNeighbors(square: button.square) {
                                if square.isBomb {
                                    square.isBomb = false
                                    
                                    for square1 in board.getNeighbors(square: square) {
                                        if square1.adjacentBombs != 0 {
                                            square1.adjacentBombs -= 1
                                        }
                                        
                                    }
                                    
                                }
                            }
                            
                        }
                        autoClick(button: button)
                    }
                    
                    firstClick = false
                    oneSecondTimer?.invalidate()
                    oneSecondTimer = nil
                    oneSecondTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.oneSecond), userInfo: nil, repeats: true)
                    //autoClick(button: button)
                    
                }
                
                if !button.square.isShowing {
                    moves += 1
                    button.backgroundColor = UIColor.systemGray5
                    button.setTitle(button.getLabel(), for: .normal)
                    button.setTitleColor(labelColor(button: button), for: .normal)
                    
                    
                    if button.square.isBomb {
                        endGame(win: false)
                    } else {
                        //print("calling autoclick")
                        autoClick(button: button)
                        if checkForWinner() {
                            endGame(win: true)
                        }
                    }
                    
                    button.square.isShowing = true
                    
                }
            }
        } else {
            if (!button.square.isShowing) {
                button.square.isFlagged = !button.square.isFlagged

                
                if (button.square.isFlagged) {
                    button.setTitle("🚩", for: .normal)
                    //button.isUserInteractionEnabled = false
                } else {
                    button.setTitle("", for: .normal)
                    //button.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    
    @objc func startNewGame(action: UIAlertAction!) {
        paused = false
        firstClick = true
        moves = 0
        timeTaken = 0
        oneSecondTimer?.invalidate();
        oneSecondTimer = nil
        board.resetBoard();
        //TODO: Set buttons back to normal
        
        if difficulty == "Easy" {
            if let easyBest = saved?.string(forKey: Saved.easyBest) {
                easyBestTime = Int(easyBest)!
            }
        } else if difficulty == "Medium" {
            if let mediumBest = saved?.string(forKey: Saved.mediumBest) {
                mediumBestTime = Int(mediumBest)!
            }
        } else if difficulty == "Hard" {
            if let hardBest = saved?.string(forKey: Saved.hardBest) {
                hardBestTime = Int(hardBest)!
            }
        }
        
        for button in buttons {
            button.isEnabled = true
            button.backgroundColor = UIColor(red: 48/255, green: 213/255, blue: 200/255, alpha: 1.0)
            //button.setTitle(button.getLabel(), for: .normal)
            button.setTitle("", for: .normal)
            button.setTitleColor(labelColor(button: button), for: .normal)
            
        }
        
        
    }
    
    func endGame(win: Bool) {
        oneSecondTimer?.invalidate()
        oneSecondTimer = nil
        
        for button in buttons {
            button.square.isShowing = true
            button.backgroundColor = UIColor.systemGray5

            button.setTitle(button.getLabel(), for: .normal)
            button.setTitleColor(labelColor(button: button), for: .normal)
        }
        
        if !win {
            let ac = UIAlertController(title: "💥", message: "You hit a bomb bozo!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "New Game", style: .default, handler: startNewGame))
            //ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "🎉", message: "You won!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play Again", style: .default, handler: startNewGame))
            //ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            present(ac, animated: true)
            
            for button in buttons {
                if button.square.isBomb {
                    button.setTitle("💣", for: .normal)
                }
            }
            setFastestTime()
        }
    }
    
    @objc func oneSecond() {
        timeTaken += 1
    }
    
    func checkForWinner() -> Bool {
        for button in buttons {
            if !button.square.isBomb {
                if !button.square.isShowing {
                    return false
                }
            }
        }
        
        return true
    }
    
    func setFastestTime() {
        if difficulty == "Hard" {
            if hardBestTime == 0 || timeTaken < hardBestTime {
                hardBestTime = timeTaken
                saved?.set(hardBestTime, forKey: Saved.hardBest)
            }
        } else if difficulty == "Medium" {
            if mediumBestTime == 0 || timeTaken < mediumBestTime {
                mediumBestTime = timeTaken
                saved?.set(mediumBestTime, forKey: Saved.mediumBest)
            }
        } else if difficulty == "Easy" {
            if easyBestTime == 0 || timeTaken < easyBestTime {
                easyBestTime = timeTaken
                saved?.set(easyBestTime, forKey: Saved.easyBest)
            }
        }
    }
    
    func autoClick(button: Button) {
        //print("inside")
        if !button.square.isShowing {
            //changeLabelColor(button: button)
           
            
            if !button.square.isBomb {
                button.square.isShowing = true
                button.backgroundColor = UIColor.systemGray5
                button.setTitle(button.getLabel(), for: .normal)
                button.setTitleColor(labelColor(button: button), for: .normal)
            }
            
            
            //print("\(button.square.adjacentBombs)")
            if button.square.adjacentBombs == 0 {
                //print("0 bombs")
                for square in board.getNeighbors(square: button.square) {
                    for button in buttons {
                        if button.square.row == square.row && button.square.column == square.column {
                            autoClick(button: button)
                            
                        }
                    }
                }
            }
            
            
        }
    }
    
    func labelColor(button: Button) -> UIColor {
        var color: UIColor
        
        switch button.square.adjacentBombs{
        case 1:
            color = UIColor.white
        case 2:
            color = UIColor.systemBlue
        case 3:
            color = UIColor.systemTeal
        case 4:
            color = UIColor.red
        case 5:
            color = UIColor.orange
        case 6:
            color = UIColor.purple
        case 7:
            color = UIColor.brown
        case 8:
            color = UIColor.magenta
        default:
            //print("hello")
            color = UIColor.black
        }
        
        return color
        
    }
}
