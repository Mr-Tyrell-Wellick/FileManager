//
//  TabBarController.swift
//  FileManager
//
//  Created by Ульви Пашаев on 30.03.2023.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super .init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        let fileVC = FileViewController()
        let settingsVC = SettingsViewController()
        // создаем навигационные контроллеры и объявляем рутовые (стартовые) экраны
        let fileNavigationController = UINavigationController.init(rootViewController: fileVC)
        let settingsNavigationController = UINavigationController.init(rootViewController: settingsVC)
        
        //Создаем кнопки, при нажатии которых, мы будем переходить в нужный контроллер)
        fileVC.tabBarItem = UITabBarItem(title: "Documents", image: UIImage(systemName: "folder.fill.badge.plus"), tag: 0)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "folder.fill.badge.gear"), tag: 1)
        
        // Обращаемся к методу, который позволяет кастомизировать TabBar под себя
        UITabBar.appearance().tintColor = UIColor.white
        UITabBar.appearance().backgroundColor = .black
        tabBar.unselectedItemTintColor = .white
        tabBar.selectedImageTintColor = .yellow
        
        // Заполняем контейнеры с контроллерами таббара нашими навигационными контроллерами
        self.setViewControllers([fileNavigationController, settingsNavigationController], animated: false)
    }
}
