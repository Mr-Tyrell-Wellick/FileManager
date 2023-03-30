//
//  TextPicker.swift
//  FileManager
//
//  Created by Ульви Пашаев on 30.03.2023.
//

import Foundation
import UIKit

class TextPicker {
    
    // создаем Singleton
    static let defaultPicker = TextPicker()
    
    // метод "showPicker" для отображения UIAlertController
    // viewController - контроллер, на котором будет отображен UIAlertController
    // complition - блок, который будет вызван после того, как пользователь введет текст и нажмет кнопку "Ok"
    func showPicker(in viewController: UIViewController, completion: @escaping (_ text: String) -> Void) {
        
        let alertController = UIAlertController(title: "Create a new folder", message: nil, preferredStyle: .alert)
        
        // добавляем текстовое поле в UIAlertController
        alertController.addTextField { textField in
            textField.placeholder = "Enter text"
        }
        
        //создаем действие "OK"
        let actionOK = UIAlertAction(title: "OK", style: .default) { action in
            // если пользователь ввел текст и нажал кнопку OK, то вызываем переданный в метод блок completion с веденным текстом
            if let text = alertController.textFields?[0].text,
               text != "" {
                completion(text)
            }
        }
        
        // создаем действие "Cancel" (отмены)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        //для кнопки отмены устанавливаем красный цвет
        actionCancel.setValue(UIColor.red, forKey: "titleTextColor")
        
        // добавляем действияв в UIAlertController
        alertController.addAction(actionOK)
        alertController.addAction(actionCancel)
        
        // отображение UIAlertController на переданном контроллере
        viewController.present(alertController, animated: true)
    }
}

