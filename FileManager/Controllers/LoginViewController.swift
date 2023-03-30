//
//  LoginViewController.swift
//  FileManager
//
//  Created by Ульви Пашаев on 30.03.2023.
//

import Foundation
import UIKit
import KeychainAccess
import TinyConstraints


fileprivate enum LoginTexts {
    static let enterPasswordText = "Enter your password"
    static let enterNewPasswordText = "Enter your new password"
    static let confirmPasswordText = "Confirm your password"
    static let confirmNewPasswordText = "Confirm your new password"
    static let signInText = "Sign In"
    static let changePasswordText = "Change password"
}

class LoginViewController: UIViewController {
    
    convenience init(isPasswordChangeState: Bool) {
        self.init()
        self.isPasswordChangeState = isPasswordChangeState
    }
    
    // MARK: - Properties
    
    private let keychain = Keychain(service: "FileManager")
    private var isFirstPasswordEntered = false
    
    private var isEnteredPasswordValid = false {
        didSet {
            logInButton.isEnabled = isEnteredPasswordValid
        }
    }
    private let passwordKey = "pass_key"
    private var isKeychainEmpty = true {
        didSet {
            confirmPasswordTextField.isHidden = !isKeychainEmpty
            if !isKeychainEmpty {
                titleLabel.text = LoginTexts.enterPasswordText
            }
        }
    }
    private var isPasswordChangeState: Bool = false
    
    // Заголовок с командой ввода пароля/подтверждения пароля
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = LoginTexts.enterPasswordText
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    // поле ввода пароля
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = LoginTexts.enterPasswordText
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.textAlignment = .center
        textField.clearButtonMode = .whileEditing
        textField.layer.cornerRadius = 10.0
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(didEnterToPasswordTextField), for: .editingChanged)
        return textField
    }()
    // поле подтверждения пароля
    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = LoginTexts.confirmPasswordText
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.textAlignment = .center
        textField.clearButtonMode = .whileEditing
        textField.layer.cornerRadius = 10.0
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        textField.clipsToBounds = true
        //target на кнопку
        textField.addTarget(self, action: #selector(didEnterToConfirmPasswordTextField), for: .editingChanged)
        textField.isEnabled = false
        return textField
    }()
    
    // создание кнопки "Log In"
    private let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LoginTexts.signInText, for: .normal)
        //        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = 10.0
        button.layer.borderWidth = 0.5
        button.layer.borderColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        // target на кнопку
        button.addTarget(self, action: #selector(didTapLogInButton), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        addViews()
        addConstraints()
        
//        try? keychain.removeAll() //если нужно скинуть пароль
        
        // реализуем функциональность для изменения пароля пользователя в приложении.
        if isPasswordChangeState {
            titleLabel.text = LoginTexts.enterNewPasswordText
            passwordTextField.placeholder = LoginTexts.enterNewPasswordText
            confirmPasswordTextField.placeholder = LoginTexts.confirmNewPasswordText
            logInButton.setTitle(LoginTexts.changePasswordText, for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passwordTextField.text = nil
        if !isPasswordChangeState {
            guard let passwordFromKeychain = try? keychain.get(passwordKey),
                  !passwordFromKeychain.isEmpty else {
                isKeychainEmpty = true
                return
            }
            isKeychainEmpty = false
        } else {
            isKeychainEmpty = true
        }
        isEnteredPasswordValid = false
    }
    
    func addViews() {
        view.addSubview(titleLabel)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(logInButton)
    }
    
    // MARK: - Actions
    @objc private func didEnterToPasswordTextField() {
        if passwordTextField.text?.count ?? 0 >= 4 {
            if confirmPasswordTextField.isHidden {
                isEnteredPasswordValid = true
            } else {
                
                isEnteredPasswordValid = false
                confirmPasswordTextField.isEnabled = true
                titleLabel.text = isPasswordChangeState
                ? LoginTexts.confirmNewPasswordText
                : LoginTexts.confirmPasswordText
            }
        } else {
            isEnteredPasswordValid = false
            confirmPasswordTextField.isEnabled = false
            titleLabel.text = isPasswordChangeState
            ? LoginTexts.enterNewPasswordText
            : LoginTexts.enterPasswordText
        }
    }
    
    @objc private func didEnterToConfirmPasswordTextField() {
        if passwordTextField.text == confirmPasswordTextField.text {
            isEnteredPasswordValid = true
        } else {
            isEnteredPasswordValid = false
        }
    }
    
    @objc private func didTapLogInButton() {
        guard let enteredPassword = passwordTextField.text else { return }
        if isKeychainEmpty {
            do {
                try keychain.set(enteredPassword, key: passwordKey)
                present(TabBarController(), animated: true)
            } catch (let error) {
                fatalError(error.localizedDescription)
            }
        } else {
            do {
                guard let savedPassword = try keychain.get(passwordKey) else { return }
                if savedPassword == enteredPassword {
                    present(TabBarController(), animated: true)
                } else {
                }
            } catch (let error) {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Constraints
    
    private func addConstraints() {
        
        titleLabel.centerX(to: view)
        titleLabel.bottomToTop(of: passwordTextField, offset: -40)
        
        passwordTextField.center(in: view)
        passwordTextField.height(45)
        passwordTextField.width(280)
        
        confirmPasswordTextField.topToBottom(of: passwordTextField, offset: 15)
        confirmPasswordTextField.centerX(to: view)
        
        confirmPasswordTextField.height(45)
        confirmPasswordTextField.width(280)
        
        logInButton.topToBottom(of: confirmPasswordTextField, offset: 15)
        logInButton.centerX(to: view)
        logInButton.height(50)
        logInButton.width(280)
    }
}
