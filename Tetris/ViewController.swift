//
//  ViewController.swift
//  Tetris
//
//  Created by Admin on 2/13/18.
//  Copyright © 2018 Victoria Galanciuc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        let tetrisViewController = TetrisViewController()
        self.present(tetrisViewController, animated: true, completion: nil)
    }



}

