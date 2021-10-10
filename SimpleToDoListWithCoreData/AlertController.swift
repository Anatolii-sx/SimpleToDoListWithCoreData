//
//  AlertController.swift
//  SimpleToDoListWithCoreData
//
//  Created by Анатолий Миронов on 10.10.2021.
//

import UIKit

extension UIAlertController {
    
    static func createAlertController(withTitle title: String) -> UIAlertController {
        UIAlertController(title: title, message: "What do you want to do?", preferredStyle: .alert)
    }
    
    //
    func action(task: Task?, completion: @escaping (String) -> Void) {
        
        // Создаем кнопку Save. При нажатии проверяем есть ли значение в TF и не пусто ли и возвращаем введенное значение в completion.
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newValue = self.textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }
            completion(newValue)
        }
        
        // Создание кнопки cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        // Добавление кнопок на alert controller
        addAction(saveAction)
        addAction(cancelAction)
        
        // Добавление текстового поля в alert controller
        addTextField { textField in
            textField.placeholder = "Task"
            // При добавлении новой задачи, в task будет nil (task - параметр action). При корректировке существующей задачи, в task будет title с текущим названием задачи.
            textField.text = task?.title
        }
    }
}
