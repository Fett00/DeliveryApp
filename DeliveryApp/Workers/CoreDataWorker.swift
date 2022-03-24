//
//  CoreDataWorker.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 12.12.2021.
//

import UIKit
import CoreData

protocol CoreDataWorkerProtocolForDeleteOnly{
    
    func delete<Entity: NSManagedObject>(type: Entity.Type, withCondition condition: String?, handler: @escaping () -> ())
}

protocol CoreDataWorkerProtocolForGetOnly{
    
    func get<Entity: NSManagedObject>(type: Entity.Type, sortingBy: [String]?, withCondition condition: String?, withLimit limit: Int?, offset: Int?) -> [Entity]
}

protocol CoreDataWorkerProtocol{

    func add(createObject: (NSManagedObjectContext)->(), handler: @escaping () -> ())

    func delete<Entity: NSManagedObject>(type: Entity.Type, withCondition condition: String?, handler: @escaping () -> ())

    func count<Entity: NSManagedObject>(type: Entity.Type, withCondition condition: String?, withLimit limit: Int?, offset: Int?) -> Int

    func get<Entity: NSManagedObject>(type: Entity.Type, sortingBy: [String]?, withCondition condition: String?, withLimit limit: Int?, offset: Int?) -> [Entity]

    func update<Entity: NSManagedObject>(type: Entity.Type, withCondition condition: String?, key: String, newValue: Any, handler: @escaping () -> ())
    
    func changeIntegerValue<Entity: NSManagedObject>(type: Entity.Type, withCondition condition: String?, key: String, increaseOrDecrease: Bool, handler: @escaping () -> ())
}

final class CoreDataWorker: CoreDataWorkerProtocol, CoreDataWorkerProtocolForGetOnly, CoreDataWorkerProtocolForDeleteOnly{
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "DeliveryApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                 
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    //Создание контекста для работы с CoreData
    var context: NSManagedObjectContext { self.persistentContainer.newBackgroundContext() }
    
    //Модель для получения fetch request'ов
    var managedObjectModel: NSManagedObjectModel { self.persistentContainer.managedObjectModel }
    
    //Сохранение Данных в БД
    private func save (handler: @escaping () -> ()) {
        
        if context.hasChanges {
            do {
                try context.save()
                handler()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        else{
            handler()
        }
    }
    
    private func saveInCurrentContext (currentContext: NSManagedObjectContext, handler: @escaping () -> ()) {
        
        if currentContext.hasChanges {
            do {
                try currentContext.save()
                handler()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        else{
            handler()
        }
    }
    
    //Добавление записи в CoreData
    //TODO: ПЕРЕДЕЛАТЬ
    ///Функция добавляет новые записи в CoreData
    func add(createObject: (NSManagedObjectContext)->(), handler: @escaping () -> ()) {
        
        let currentContext = self.context
        
        createObject(currentContext)
        saveInCurrentContext(currentContext: currentContext) {
            handler()
        }
    }

    /// Функция удаляет заданные записи из CoreData
    func delete<Entity: NSManagedObject>(type: Entity.Type, withCondition condition: String?, handler: @escaping () -> ()){
       
        var predicate: NSPredicate?
        
        let currentContext = self.context

        if let condition = condition{
            let splitedCondition = condition.split(separator: "=")
            predicate = NSPredicate(format: "\(splitedCondition[0]) = %@", "\(splitedCondition[1])")
        }
        
        do {

            let request = Entity.fetchRequest()
            request.predicate = predicate
            
            let objectsToDelete = try currentContext.fetch(request) as! [Entity]
            
            for object in objectsToDelete{
                
                currentContext.delete(object)
            }
            
            saveInCurrentContext(currentContext: currentContext) {
                handler()
                print("ПРОИЗОШЛО УДОЛЕНИЕ")
            }
        }
        catch {
            print("Delete ERROR: ", error.localizedDescription)
        }
    }
    
    /// Функция возвращает кол-во элементов по заданым параметрам
    /// - Returns: Возвращаемое кол-во найденых объектов
    func count<Entity: NSManagedObject>(type: Entity.Type, withCondition condition: String?, withLimit limit: Int?, offset: Int?) -> Int {

        var predicate: NSPredicate?
        
        let currentContext = self.context

        if let condition = condition{
            
            let splitedCondition = condition.split(separator: "=")
            predicate = NSPredicate(format: "\(splitedCondition[0]) = %@", "\(splitedCondition[1])")
        }

        do {

            let request = Entity.fetchRequest()
            request.predicate = predicate
            request.fetchOffset = offset ?? 0
            request.fetchLimit = limit ?? 0

            let count = try currentContext.count(for: request)
            return count
        }
        catch {
            print("Count ERROR: ", error.localizedDescription)
            return 0
        }
    }
    
    //TODO: Добавить запрос к БД с условиями(для поиска)
    //Получение записей из CoreData

    //condition: First String - argument, second - condition.
    //Exm: ("name","Ivan") -> "rows where name = Ivan"

    func get<Entity: NSManagedObject>(type: Entity.Type, sortingBy: [String]?, withCondition condition: String?, withLimit limit: Int?, offset: Int?) -> [Entity] {

        var predicate: NSPredicate?
        
        let currentContext = self.context

        if let condition = condition{
            
            let splitedCondition = condition.split(separator: "=")
            predicate = NSPredicate(format: "\(splitedCondition[0]) = %@", "\(splitedCondition[1])")
        }
        
        var sortDescriptors: [NSSortDescriptor]?
        
        if let sortingBy = sortingBy {
            
            sortDescriptors = sortingBy.map { NSSortDescriptor(key: $0, ascending: true) }
        }

        do {

            let request = Entity.fetchRequest()
            request.predicate = predicate
            request.fetchOffset = offset ?? 0
            request.fetchLimit = limit ?? 0
            request.sortDescriptors = sortDescriptors
            
            let result: [Entity] = try currentContext.fetch(request) as! [Entity]
            return result
        }
        catch {
            print("Get ERROR: ", error.localizedDescription)
            return []
        }
    }
    

    func update<Entity: NSManagedObject>(type: Entity.Type, withCondition condition: String?, key: String, newValue: Any, handler: @escaping () -> ()){
        
        var predicate: NSPredicate?
        
        let currentContext = self.context

        if let condition = condition{
            
            let splitedCondition = condition.split(separator: "=")
            predicate = NSPredicate(format: "\(splitedCondition[0]) = %@", "\(splitedCondition[1])")
        }
        
        var results: [Entity] = []
        
        do {
            let request = Entity.fetchRequest()
            request.predicate = predicate

            results = try currentContext.fetch(request) as! [Entity]
            
        } catch {
            
            print("Update ERROR: ", error.localizedDescription)
        }
        
        for result in results{
            
            result.setValue(newValue, forKey: key)
        }
        
        saveInCurrentContext(currentContext: currentContext) {
            
            handler()
        }
    }
    
    /// Функция изменяет целочисленный атрибут записи на одно значение
    func changeIntegerValue<Entity: NSManagedObject>(type: Entity.Type, withCondition condition: String?, key: String, increaseOrDecrease: Bool, handler: @escaping () -> ()){
        
        var predicate: NSPredicate?
        
        let currentContext = self.context

        if let condition = condition{
            
            let splitedCondition = condition.split(separator: "=")
            predicate = NSPredicate(format: "\(splitedCondition[0]) = %@", "\(splitedCondition[1])")
        }
        
        var results: [Entity] = []
        
        do {
            let request = Entity.fetchRequest()
            request.predicate = predicate
            results = try currentContext.fetch(request) as! [Entity]
            
        } catch {
            
            print("Update ERROR: ", error.localizedDescription)
        }
        
        for result in results{
            
            if let oldValue = result.value(forKey: key) as? Int32{
                
                if increaseOrDecrease == false && oldValue == 1{
                    
                    currentContext.delete(result)
                }
                else if increaseOrDecrease == true{
                    
                    result.setValue(oldValue + 1, forKey: key)
                }
                else if increaseOrDecrease == false{
                    
                    result.setValue(oldValue - 1, forKey: key)
                }
            }
        }
        
        saveInCurrentContext(currentContext: currentContext) {
            
            handler()
        }
    }
}
