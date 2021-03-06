//
//  LogInViewController.swift
//  INTITA
//
//  Created by Stepan Niemykin on 02.11.2020.
//

import UIKit
import SafariServices

enum CredentialsError {
    case wrongPassword
    case emailIsEmpty
    case wrongEmail
    
    func getString() -> String {
        switch self {
        case .wrongPassword:
            return "wrongPassword".localized
        case .emailIsEmpty:
            return "inputEmail".localized
        case .wrongEmail:
            return "wrongEmail".localized
        }
    }
}

class LogInViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    weak var coordinator: LogInCoordinator?
    var viewModel: LogInViewModel?
    let validator = Validate()
    let alert: AlertView = AlertView.fromNib()
    
    //private let keyboardHeight: CGFloat = 200.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        registerCells()
        
        view.addSubview(alert)
        navigationController?.setNavigationBarHidden(false, animated: true)
        viewModel?.subscribe(updateCallback: handleViewModelUpdateWith)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        startMonitoringKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        stopMonitoringKeyboard()
        stopSpinner()
    }
    
    override func animateKeyboardAppearance(height: CGFloat) {
        tableView.beginUpdates()
        tableViewBottomContraint.constant = height
        view.layoutSubviews()
        tableView.endUpdates()
        
        tableView.scrollToRow(at: IndexPath(row: 4, section: 0), at: .bottom, animated: true)
    }
    
    func handleViewModelUpdateWith(error: Error?) {
        if let error = error {
            print("ERRORORROOR \(error)")
            DispatchQueue.main.async {
                self.stopSpinner()
                self.alert.customizeAndShow(message: error.localizedDescription)
            }
        }
    }
    
    private func showSafari(_ url: String) {
        guard let url = URL(string: url) else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
    func registerCells() {
        let logoCell = UINib(nibName: "LogoTableViewCell", bundle: nil)
        let textCell = UINib(nibName: "TextTableViewCell", bundle: nil)
        let registerButtonCell = UINib(nibName: "RegisterButtonTableViewCell", bundle: nil)
        let linksCell = UINib(nibName: "LinksTableViewCell", bundle: nil)
        tableView.register(logoCell, forCellReuseIdentifier: "reuseForLogo")
        tableView.register(textCell, forCellReuseIdentifier: "reuseForText")
        tableView.register(registerButtonCell, forCellReuseIdentifier: "reuseForButton")
        tableView.register(linksCell, forCellReuseIdentifier: "reuseForLinks")
    }
}

extension LogInViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return view.frame.height / 3
        case 1, 2:
            return view.frame.height / 9
        case 3:
            return 25
        case 4:
            return 100
        default:
            return 125.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let logoCell = tableView.dequeueReusableCell(withIdentifier: "reuseForLogo") as? LogoTableViewCell else { return UITableViewCell() }
            return logoCell
        case 1:
            guard let emailCell = tableView.dequeueReusableCell(withIdentifier: "reuseForText") as? TextTableViewCell else { return UITableViewCell() }
            emailCell.textField.placeholder = "inputEmail".localized
            emailCell.textField.textContentType = .emailAddress
            return emailCell
        case 2:
            guard let passwordCell = tableView.dequeueReusableCell(withIdentifier: "reuseForText") as? TextTableViewCell else { return UITableViewCell() }
            passwordCell.textField.placeholder = "inputPassword".localized
            passwordCell.textField.textContentType = .password
            passwordCell.textField.isSecureTextEntry = true
            return passwordCell
        case 3:
            guard let linksCell = tableView.dequeueReusableCell(withIdentifier: "reuseForLinks") as? LinksTableViewCell else { return UITableViewCell() }
            linksCell.delegate = self
            return linksCell
        case 4:
            guard let buttonCell = tableView.dequeueReusableCell(withIdentifier: "reuseForButton") as? RegisterButtonTableViewCell else { return UITableViewCell() }
            buttonCell.delegate = self
            return buttonCell
        default:
            return UITableViewCell()
        }
    }
}

extension LogInViewController: RegisterButtonTableViewCellDelegate {
    func didPressLogInButton(_ sender: RegisterButtonTableViewCell) {
        guard let emailCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? TextTableViewCell else { return }
        guard let passwordCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? TextTableViewCell else { return }
        
        guard let password = passwordCell.textField.text, let email = emailCell.textField.text else {
            return
        }
        
        if !validator.validateEmail(email: email) {
            emailCell.errorLabel.isHidden = false
            emailCell.errorImage.isHidden = false
            emailCell.errorLabel.text = CredentialsError.wrongEmail.getString()
            emailCell.textField.bordered(borderWidth: 1, borderColor: UIColor.red.cgColor)
        } else if !validator.validatePassword(password: password) {
            passwordCell.errorLabel.isHidden = false
            passwordCell.errorImage.isHidden = false
            passwordCell.errorLabel.text = CredentialsError.wrongPassword.getString()
            passwordCell.textField.bordered(borderWidth: 1, borderColor: UIColor.red.cgColor)
        } else {
            startSpinner()
            viewModel?.login(email: email, password: password)
        }
    }
}

extension LogInViewController: LinksTableViewCellDelegate {
    func linksTableViewCellDidPressRegister(_ sender: LinksTableViewCell) {
        showSafari("https://intita.com/register")
    }
    
    func linksTableViewCellDidPressForgotPassword(_ sender: LinksTableViewCell) {
        coordinator?.forgotPasswordScreen()
    }
}
