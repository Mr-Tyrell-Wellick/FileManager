//
//  FileViewController.swift
//  FileManager
//
//  Created by Ульви Пашаев on 30.03.2023.
//

import Foundation
import UIKit
import TinyConstraints

class FileViewController: UIViewController,
                          UITableViewDelegate,
                          UIImagePickerControllerDelegate,
                          UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    // присваемваем значение из UserDefaults для ключа "SortScheme".
    var alphabeticalSort = UserDefaults.standard.bool(forKey: "sortScheme")
    
    //    Вызываем статический метод NSSearchPathForDirectoriesInDomains класса FileManager, который возвращает путь к указанному каталогу в файловой системе
    var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    var files: [String] {
        // получаем список файлов в директории, заданной константой path. Если происходит ошибка, то возвращаем пустой массив
        let file = (try? FileManager.default.contentsOfDirectory(atPath: path)) ?? []
        // присваеваем значение UserDefaults  по ключу "sortStatus"
        let sort = UserDefaults.standard.bool(forKey: "sortStatus")
        //если значение true, то возвращаем остортированный во возрастанию список файлов
        if sort == true {
            return file.sorted(by: <)
        // или возвращаем осортированный по убыванию список файлова
        } else {
            return file.sorted(by: >)
        }
    }
    
    // создаем tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultTableCellID")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // создаем экземпляр класса UIImagePickerController и назначаем его делегатом нашего класса
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "FileManager"
        setupNavBar()
        addViews()
        addConstraints()
    }
    
    // добавляем view
    func addViews() {
        view.addSubview(tableView)
    }
    
    //настройка Navigation Bar'a
    private func setupNavBar() {
        
        let addFolderItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createFolder))
        let addFileItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(createFile))
        // устанавливаем item'ы с правой стороны

        self.navigationItem.rightBarButtonItems = [addFolderItem, addFileItem]
        
        
        // Cоздаем объект типа URL из строки path, которая представляет собой путь к файлу. Затем вызываем метод lastPathComponent для получения имени файла без его расширения, которое ПРИСВАЕВАЕМ переменной title.
        title = URL(fileURLWithPath: path).lastPathComponent
    }
    
    //MARK: - Adds and create folders/files
    // функция создания папки
    @objc func createFolder() {
        //появление диалогового окна, где пользователь может ввести имя новой папки
        TextPicker.defaultPicker.showPicker(in: self) { text in
            // В переменную newDirectoryPath записываем новый путь, где имя новой папки добавляется к текущему пути self.path.
            let newDirectoryPath = self.path + "/" + text
            // Выполняем проверку на успешное создание новой директории с помощью метода FileManager.default.createDirectory, и если операция прошла успешно, то
            try? FileManager.default.createDirectory(atPath: newDirectoryPath, withIntermediateDirectories: false)
            // перезагружаем таблицу
            self.tableView.reloadData()
        }
    }
    
    // функция создания файла
    @objc func createFile() {
        // открываем экран и выбираем файл - в нашем случае используем объект типа UIImagePickerController, который предоставляет интерфейс для выбора файлов, таких как изображения.
        present(imagePicker, animated: true)
        // перезагружаем таблицу
        self.tableView.reloadData()
    }
    
    // функция перехода из одного экрана на другой - переходим с главного экрана в выбранную нами папку
    // принимаем два параметра: viewController типа UIViewController, который используется для отображения представления FileViewController, и path типа String, который содержит путь к папке, которую нужно отобразить.
    static func showFolder(in viewController: UIViewController, withPath path: String) {
        // создаем экземпляр
        let vc = FileViewController()
        // устанавливаем значение свойства path равным переданному path
        vc.path = path
        // вызываем pushViewController у свойства navigationController переданного viewController, чтобы отобразить FileViewController на экране
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    // функция выбора изображения в ImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // проверяем, есть ли URL фото в словаре info
        if let photoURL = info[.imageURL] as? URL {
            // создаем путь для перемещения и перемещаем выбранное изображение из его текущего расположения на путь к директории, указанной в свойстве path
            try? FileManager.default.moveItem(atPath: photoURL.relativePath, toPath: self.path + "/" + photoURL.lastPathComponent)
            // закрываем экран выбора фото
            imagePicker.dismiss(animated: true)
            // перезагружаем таблицу
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Constraints
    func addConstraints() {
        
        tableView.edgesToSuperview(usingSafeArea: true)
    }
}

// MARK: - Extensions
extension FileViewController: UITableViewDataSource {
    // количество секций в таблице
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // количество строк в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count //количество равносительное количеству файлов/папок
    }
    // заполнение таблицы данными
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultTableCellID", for: indexPath)
        
        // задаем текст метки ячейки с помощью cell.textLabel?.text = files[indexPath.row], где files - массив строк, содержащий имена файлов и папок в директории.
        cell.textLabel?.text = files[indexPath.row]
        let fullPath = path + "/" + files[indexPath.row]
        var isDir: ObjCBool = false
        // Определяем, что находится в ячейке (папка или файл), проверяя тип файла по его расширению, используя полный путь к файлу fullPath и метод fileExists(atPath:isDirectory:). Если это папка, то устанавливаем соответствующий текст для ячейки и цвет для названия папки, а если это файл, то устанавливаем текст "Image".
        if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDir)
        {
            if isDir.boolValue == true {
                cell.detailTextLabel?.text = "Folder"
                cell.textLabel?.textColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
            } else {
                cell.detailTextLabel?.text = "Image"
            }
        }
        // устанавливаем стрелку указателя вправо
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // обработка события - тапа на строку в таблице. При тапе осуществляется переход в выбранную папку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // получаем полный путь к выбраннуому файлу/папке, объединяя имя файла из массива files с текущим путем path.
        let fullPath = path + "/" + files[indexPath.row]
        var isDir: ObjCBool = false
        // проверяем существования файла/папки
        if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDir)
        {
            // если существует, то извлекаем значение значение isDirectory и проверяем, является ли выбранный элемент папкой.
            if isDir.boolValue == true {
                // если является, то вызываем метод для отображения содержимого этой папки
                FileViewController.showFolder(in: self, withPath: fullPath)
            } else {
            }
        }
    }
    
    // метод определяет, может ли заданная строка в таблице быть редактированной. (удаление, переименование и др.)
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // удаление строки и обновление данных в соответствующем источнике данных
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // проверяем, что стиль редактирования ячейки является стилем удаления
        if editingStyle == .delete {
            // создаем полный путь к файлу/папке, который нужно удалить
            let fullPath = path + "/" + files[indexPath.row]
            // удаляем файл/папку по полному пути
            try? FileManager.default.removeItem(atPath: fullPath)
            // удаляем строку из таблцы с анимацией удаления
            tableView.deleteRows(at: [indexPath], with: .fade)
            // в случае если стиль редактирования ячейки не является стилем удаления, функция ничего не делает
        } else if editingStyle == .insert {
        }
    }
}
