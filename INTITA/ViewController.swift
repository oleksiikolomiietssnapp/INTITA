//
//  ViewController.swift
//  INTITA
//
//  Created by Anastasiia Spiridonova on 29.10.2020.
//

import UIKit

class ViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("moto".localized)
    }


}

