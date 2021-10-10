//
//  StorageManager.swift
//  SimpleToDoListWithCoreData
//
//  Created by Анатолий Миронов on 10.10.2021.
//

import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    // "Вход" в БД
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SimpleToDoListWithCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // Создание viewContext (все изменения данных фиксируются в оперативной памяти)
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - Public Methods
    // Получение данных (массива [Task])
    func fetchData(completion: (Result<[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()

        do {
            let tasks = try viewContext.fetch(fetchRequest)
            completion(.success(tasks))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    // Сохранение данных. Сохраняемая новая задача и возвращаемое значение в completion для передачи в массив во вью
    func save(_ taskName: String, completion: (Task) -> Void) {
        // Создание экземпляра модели данных из БД
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: viewContext) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: viewContext) as? Task else { return }
        
        task.title = taskName
        completion(task)
        saveContext()
    }
    
    // Редактирование данных (название текущей задачи и новое)
    func edit(_ task: Task, newName: String) {
        task.title = newName
        saveContext()
    }

    // Удаление задачи из контекста и сохранение изменений в базе
    func delete(_ task: Task) {
        viewContext.delete(task)
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    // Если есть изменения в viewContext, то сохранить в базе
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
