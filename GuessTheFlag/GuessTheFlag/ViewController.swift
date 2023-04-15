//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Илья Казначеев on 15.04.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var countries = [String]()
    var score = 0
    var correctedAnswer = 0
    
    var timerLine: UIView?
    var timer: Timer?
    var timeToThink = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "us", "uk"]
        
        scoreLabel.text = "Score: \(score)"
        
        askQuestion()
    }
        
    func askQuestion() {
        countries.shuffle()
        correctedAnswer = Int.random(in: 0...2)

        // Remove any previous timer line
        timerLine?.removeFromSuperview()

        // Create a new timer line and add it to the view
        timerLine = UIView(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: 1))
        timerLine?.backgroundColor = .black
        view.addSubview(timerLine!)

        // Start the timer animation
        startTimer()
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor

        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)

        title = countries[correctedAnswer].uppercased()
    }

    func startTimer() {
        // Stop any previous timer
        timer?.invalidate()

        // Start a new timer
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timeToThink), repeats: false) { [weak self] _ in
            self?.timerLine?.removeFromSuperview()
            self?.gameOver()
        }

        // Animate the timer line
        UIView.animate(withDuration: TimeInterval(timeToThink), delay: 0, options: [.curveLinear], animations: { [weak self] in
            self?.timerLine?.frame.origin.x = -(self?.timerLine?.frame.width)!
        })
    }

    func gameOver() {
        timer?.invalidate()

        let ac = UIAlertController(title: "Game Over", message: "Your final score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { [weak self] _ in
            self?.score = 0
            self?.askQuestion()
        }))
        present(ac, animated: true)
    }

    
    @IBAction func buttonTaped(_ sender: UIButton) {
        timerLine?.removeFromSuperview()
        timerLine = nil
        
        if sender.tag == correctedAnswer {
            title = "Correct"
            sender.layer.borderColor = UIColor.green.cgColor
            sender.layer.borderWidth = 4
            score += 1
        } else {
            title = "Wrong"
            score -= 1
            sender.layer.borderColor = UIColor.red.cgColor
            sender.layer.borderWidth = 4
            
            if correctedAnswer == 0 {
                button1.layer.borderColor = UIColor.green.cgColor
                button1.layer.borderWidth = 4
            }
            if correctedAnswer == 1 {
                button2.layer.borderColor = UIColor.green.cgColor
                button2.layer.borderWidth = 4
            }
            if correctedAnswer == 2 {
                button3.layer.borderColor = UIColor.green.cgColor
                button3.layer.borderWidth = 4
            }
        }
        scoreLabel.text = "Score: \(score)"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.askQuestion()
        }
    }
}

