//
//  TaskViewController.swift
//  SimpleToDoListWithCoreData
//
//  Created by Анатолий Миронов on 10.10.2021.
//

import UIKit

class TaskViewController: UIViewController {
    
    var delegate: TaskViewControllerDelegate!
    
    // Создание свойств с отложенной инициализацией (инициализация при вызове), в котором создание экземпляра класса и его настройка
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "New Task"
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.3960784314, blue: 0.7529411765, alpha: 1)
        button.layer.cornerRadius = 7
        
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.3921568627, blue: 0.1921568627, alpha: 1)
        button.layer.cornerRadius = 7
        
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupSubviews(taskTextField, saveButton, cancelButton)
        
        setConstraintsForTaskTextField()
        setConstraintsForSaveButton()
        setConstraintsForCancelButton()
    }
    
    // Метод для помещения всех созданных элементов (subviews) во view
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
//        subviews.forEach { view.addSubview($0) }
    }
    
    private func setConstraintsForTaskTextField() {
        taskTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])
    }
    
    private func setConstraintsForSaveButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 50),
            saveButton.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -40),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            
            saveButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor)
        ])
    }
    
    private func setConstraintsForCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 50),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }
    
    @objc private func save() {
        delegate.getTask(task: taskTextField.text ?? "")
        dismiss(animated: true)
        
//        navigationController?.popViewController(animated: true)
    }
    
    @objc private func cancel() {
        dismiss(animated: true)
    }
}
