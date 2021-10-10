//
//  MainViewController.swift
//  SimpleToDoListWithCoreData
//
//  Created by Анатолий Миронов on 10.10.2021.
//

import UIKit

protocol TaskViewControllerDelegate {
    func getTask(task: String)
}

class MainViewController: UITableViewController {
    
    private let cellID = "task"
    
    var tasks: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = tasks[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task
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
        let taskVC = TaskViewController()
        taskVC.delegate = self
        present(taskVC, animated: true)
        
//        taskVC.modalPresentationStyle = .fullScreen
//        navigationController?.pushViewController(taskVC, animated: true)
    }
}

extension MainViewController: TaskViewControllerDelegate {
    func getTask(task: String) {
        tasks.append(task)
        tableView.reloadData()
    }
}

