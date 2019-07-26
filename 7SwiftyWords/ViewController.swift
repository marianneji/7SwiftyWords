//
//  ViewController.swift
//  7SwiftyWords
//
//  Created by Graphic Influence on 25/07/2019.
//  Copyright © 2019 marianne massé. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var cluesLabel: UILabel!
    var answerLabel: UILabel!
    var scoreLabel: UILabel!
    var currentAnswer: UITextField!
    var letterButtons = [UIButton]()
    var numberOfQuestion = 0
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.font = UIFont.systemFont(ofSize: 24)
        answerLabel.textAlignment = .right
        answerLabel.text = "ANSWERS"
        answerLabel.numberOfLines = 0
        answerLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answerLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.textAlignment = .center
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("Submit", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("Clear", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            answerLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answerLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answerLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.heightAnchor.constraint(equalToConstant: 44),
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)])
        
        let width = 150
        let height = 80
        
        for row in 0..<4 {
            for col in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.setTitle("WWW", for: .normal)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.layer.borderWidth = 1
                letterButton.layer.borderColor = UIColor.gray.cgColor
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performSelector(inBackground: #selector(loadLevel), with: nil)
    }
    
    @objc func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        if let levelFileUrl = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContent = try? String(contentsOf: levelFileUrl) {
                var lines = levelContent.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, lines) in lines.enumerated() {
                    let parts = lines.components(separatedBy: ": ")
                    let clue = parts[1]
                    let answer = parts[0]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        DispatchQueue.main.async {
            [weak self] in
            
            self?.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
            self?.answerLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
            
            letterBits.shuffle()
            
            if letterBits.count == self?.letterButtons.count {
                for i in 0..<letterBits.count {
                    self?.letterButtons[i].setTitle(letterBits[i], for: .normal)
                }
            }
        }
    }
    
    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }
        
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()
            
            var splitAnswers = answerLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answerLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            numberOfQuestion += 1
            
            if numberOfQuestion == 7 {
                let ac = UIAlertController(title: "Well done!", message: "Ready for next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
            
        } else {
            let ac = UIAlertController(title: "Wrong answer!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ok", style: .default, handler: clearAnswer))
            present(ac, animated: true)
            score -= 1
        }
    }
    
    func clearAnswer(action: UIAlertAction) {
        
        for buttons in activatedButtons {
            clearTapped(buttons)
        }
    }
    
    @objc func clearTapped(_ sender: UIButton) {
        
        currentAnswer.text = ""
        
        for buttons in activatedButtons {
            buttons.isHidden = false
        }
        activatedButtons.removeAll()
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        for buttons in letterButtons {
            buttons.isHidden = false
        }
    }
}

