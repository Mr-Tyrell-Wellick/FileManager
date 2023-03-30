//
//  SettingsViewController.swift
//  FileManager
//
//  Created by Ульви Пашаев on 30.03.2023.
//

import Foundation
import UIKit
import TinyConstraints

class SettingsViewController: UIViewController {
    
    // создаем вычисляемое свойство (sortMethod), используем UserDefaults для получения и сохранения значения логического типа
    // get: Блок get используем для получения значения sortMethod. В данном случае, он возвращает логическое значение, полученное из UserDefaults, используя ключ "sortStatus". Если значение не найдено, метод bool(forKey:) возвращает значение по умолчанию, равное false
    // set: Блок set используем для установки значения sortMethod. Он сохраняет значение newValue в UserDefaults с ключом "SortStatus"
    // данное вычисляемое свойство sortMethod позволяет получать и устанавливать логическое значение из UserDefaults, используя ключ "sortStatus". Используем для сохранения настроек сортировки
    var sortMethod: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "sortStatus")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "sortStatus")
        }
    }
    // MARK: - Properties
    
    // сортировка в алфавитном порядке. По умолчанию опция включена.
    private lazy var sortLabel: UILabel = {
        let label = UILabel()
        label.text = "Show alphabetical order of contents"
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //переключатель (switcher)
    private lazy var sortSwitch: UISwitch = {
        let switcher = UISwitch()
        switcher.translatesAutoresizingMaskIntoConstraints = false
        //таргет на кнопку
        switcher.addTarget(self, action: #selector(methodOfSwitching), for: .valueChanged)
        return switcher
    }()
    
    // кнопка изменения пароля
    private lazy var passwordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change password", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        button.tintColor = .white
        button.layer.cornerRadius = 7
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        //таргет на кнопку
        button.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // заголовок "Настройки"
        self.title = "Settings"
        addViews()
        addConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if sortMethod == true {
            sortSwitch.isOn = true
            print("Switching mode on")
        } else {
            sortSwitch.isOn = false
            print("switching mode off")
        }
    }
    
    func addViews() {
        view.addSubview(sortLabel)
        view.addSubview(sortSwitch)
        view.addSubview(passwordButton)
    }
    
   // функция переключения switcher'a
    @objc
    func methodOfSwitching() {
        if sortSwitch.isOn {
            sortMethod = true
            print("Alphabetical order is on")
        } else {
            sortMethod = false
            print("Alphabetical order is off")
        }
    }
    
    // функция изменения пароля (открываем новое окно)
    @objc
    func changePassword() {
        let vc = LoginViewController(isPasswordChangeState: true)
        present(vc, animated: true)
        
    }
    
    // MARK: - Constraints
    func addConstraints() {
        
        sortLabel.topToSuperview(offset: 25, usingSafeArea: true)
        sortLabel.left(to: view, offset: 16)
        
        sortSwitch.topToSuperview(offset: 20, usingSafeArea: true)
        sortSwitch.right(to: view, offset: -36)
        
        passwordButton.centerX(to: view)
        passwordButton.topToBottom(of: sortLabel, offset: 50)
    }
}
