//
//  MainViewController.swift
//  SimpleToDoListWithCoreData
//
//  Created by Анатолий Миронов on 10.10.2021.
//

import UIKit

class MainViewController: UITableViewController {
    
    private let cellID = "task"
    
    private var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
        fetchData()
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = tasks[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
    
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Создание экземпляра класса для настройки внешнего вида navBar
        let navBarAppearance = UINavigationBarAppearance()
        
        navBarAppearance.backgroundColor = #colorLiteral(red: 0.08021575958, green: 0.4831395745, blue: 0.7987222075, alpha: 0.76)
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Добавление кнопки
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        navigationController?.navigationBar.tintColor = .white
        
        // Сохранение настроек для наших двух состояний navBar
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    @objc private func addNewTask() {
        showAlert()
    }
    // Сохранение введенного названия задачи. Вызов метода save у Storage Manager, который возвращает task в completion, данный task добавляем в массив и добавляем новую строку
    private func save(taskName: String) {
        StorageManager.shared.save(taskName) { task in
            self.tasks.append(task)
            self.tableView.insertRows(
                at: [IndexPath(row: self.tasks.count - 1, section: 0)],
                with: .automatic
            )
        }
    }
    // Получение данных. В completion возвращается result с двумя case. В первом case возвращается массив tasks.
    private func fetchData() {
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let tasks):
                self.tasks = tasks
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension MainViewController {
    // Редактирование task
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Снятие выделения с ячейки при нажатии
        tableView.deselectRow(at: indexPath, animated: true)
        
        // вызов alert controller для выбранной задачи и в блоке замыкания обновляем строку, которая обновиться после нажатия кнопки save в alert
        let task = tasks[indexPath.row]
        showAlert(task: task) {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    // Удаление task
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        
        if editingStyle == .delete {
            // Удаление из массива
            tasks.remove(at: indexPath.row)
            // Удаление строки из таблицы
            tableView.deleteRows(at: [indexPath], with: .automatic)
            // Удаление из БД (вызов метода delete у StorageManager с передачей удаляемой task)
            StorageManager.shared.delete(task)
        }
    }
}

// MARK: - Alert Controller
extension MainViewController {
    
    // Вызов alert с параметрами task и completion, которые по умолчанию принимают значения nil. Если nil (вызов без параметра) -> значит alert для новой задачи, если не nil (вызов с параметрами) -> значит alert для редактирования
    private func showAlert(task: Task? = nil, completion: (() -> Void)? = nil) {
        let title = task != nil ? "Update Task" : "New Task"
        
        // Создание экземпляра alert controller с передаваемым title
        let alert = UIAlertController.createAlertController(withTitle: title)
        
        // Вызываем метод action из созданного экземпляра с передаваемым task. Блок замыкания возвращает новое название задачи с типом String
        alert.action(task: task) { taskName in
            if let task = task, let completion = completion {
                StorageManager.shared.edit(task, newName: taskName)
                
                // Completion для того, чтобы задействовать indexPath, см. строка 97)
                completion()
            } else {
                self.save(taskName: taskName)
            }
        }
        
        present(alert, animated: true)
    }
}


