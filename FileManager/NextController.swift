//
//  NextController.swift
//  FileManager
//
//  Created by Ульви Пашаев on 30.03.2023.
//

import Foundation

import Foundation
import UIKit
import TinyConstraints

class NextController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        addViews()
        addConstraints()
    }
    
    private lazy var passwordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Mercy", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        button.tintColor = .white
        button.layer.cornerRadius = 7
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        //таргет на кнопку
        button.addTarget(self, action: #selector(showController), for: .touchUpInside)
        return button
    }()
    
    
    func addViews() {
        
        view.addSubview(passwordButton)
    }
    
    
    @objc func showController() {
        

//        let nextViewController = LoginViewController()
        
//        navigationController?.pushViewController(nextViewController, animated: true)
//        
        
        
    }
    
    func addConstraints() {
        
        passwordButton.centerX(to: view)
        passwordButton.top(to: view, offset: 200)
        
    }
}
