//
//  ForgotPasswordViewController.swift
//  INTITA
//
//  Created by Viacheslav Markov on 03.11.2020.
//

import UIKit

class ForgotPasswordViewController: UIViewController, Storyboarded {
    
    weak var coordinator: ForgotPasswordCoordinator?
    
    var validateEmail: Validate!
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var blueLineView: UIView!
    
    @IBOutlet weak var recoveryLabel: UILabel!
    @IBOutlet weak var explanationTextLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var invalidTextLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageView.rounded()
        recoveryLabel.shadowed()
        
        self.recoveryLabel.text = "passRecovery".localized
        self.explanationTextLabel.text = "textRecovery".localized
        explanationTextLabel.shadowed()
        
        setupInvalidTextLabel()
        setupEmailTextField()
        setupSendButton()
        
    }
    
    func setupInvalidTextLabel() {
        
        let title = ""
        invalidTextLabel.text = title
        invalidTextLabel.textColor = .red

    }
    
    func setupEmailTextField() {

        emailTextField.rounded(cornerRadius: 5)
        emailTextField.layer.borderWidth = 1
        emailTextField.keyboardType = .emailAddress
        emailTextField.placeholder = "inputEmail".localized
        emailTextField.clearButtonMode = .whileEditing
        
    }
    
    func setupSendButton() {
        
        let titleLocalized = "send".localized
        sendButton.bordered()
        sendButton.setTitle(titleLocalized, for: .normal)
        sendButton.rounded()
        
    }
    
    @IBAction func pressedSendButton(_ sender: UIButton) {
        
        guard let textEmail = self.emailTextField.text else { return }
        
        if !validateEmail.validateEmail(email: textEmail) {
            invalidTextLabel.isHidden = false
            invalidTextLabel.text = "You entered wrong Email"
        } else {
            invalidTextLabel.text = "Your Email sent"
        }
    }
    
}
