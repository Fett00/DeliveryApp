//
//  CoreDataWorker.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 12.12.2021.
//

import UIKit
import CoreData

protocol CoreDataWorkerProtocol{
    
    var context: NSManagedObjectContext { get }
    
    func add(createObject: ()->())
    
    func delete<Entity: NSManagedObject>(type: Entity.Type, withCondition condition: String?)
    
    func refresh()
    
    func get<Entity: NSManagedObject>(type: Entity.Type, sortingBy: [String]?, withCondition condition: String?, withLimit limit: Int?, offset: Int?) -> [Entity]
    
    func count<Entity: NSManagedObject>(type: Entity.Type, withCondition condition: String?, withLimit limit: Int?, offset: Int?) -> Int
}

class CoreDataWorker: CoreDataWorkerProtocol{

    //Создание контекста для работы с CoreData
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
    
    //Модель для получения fetch request'ов
    let managedObjectModel = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.managedObjectModel
    
    //Сохранение Данных в БД
    private func save () {
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    //Добавление записи в CoreData
    //TODO: ПЕРЕДЕЛАТЬ
    func add(createObject: ()->()) {

        createObject()
        save()
    }

    //Удаление записей из CoreData
    func delete<Entity: NSManagedObject>(type: Entity.Type, withCondition condition: String?){
       
        var predicate:NSPredicate?

        if let condition = condition{
            //let splitedCondition = condition.split(separator: "=")
            predicate = NSPredicate(format: condition)//"\(splitedCondition[0]) = %@", "\(splitedCondition[1])")
        }
        
        do {

            let request = Entity.fetchRequest()
            request.predicate = predicate
            
            let objectsToDelete = try context.fetch(request)as! [Entity]
            
            for object in objectsToDelete{
                
                context.delete(object)
            }
            
            save()
            print("ПРОИЗОШЛО УДОЛЕНИЕ")
        }
        catch {
            print(error.localizedDescription)
        }
    }

    //Обновление записей в CoreData
    func refresh() {

    }


    //TODO: Добавить запрос к БД с условиями(для поиска)
    //Получение записей из CoreData

    //condition: First String - argument, second - condition.
    //Exm: ("name","Ivan") -> "rows where name = Ivan"

    func get<Entity: NSManagedObject>(type: Entity.Type, sortingBy: [String]?, withCondition condition: String?, withLimit limit: Int?, offset: Int?) -> [Entity] {

        var predicate: NSPredicate?

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

            let result:[Entity] = try context.fetch(request) as! [Entity]
            return result
        }
        catch {
            return []
        }
    }
    
    func count<Entity: NSManagedObject>(type: Entity.Type, withCondition condition: String?, withLimit limit: Int?, offset: Int?) -> Int {

        var predicate:NSPredicate?

        if let condition = condition{
            predicate = NSPredicate(format: condition)
        }

        do {

            let request = Entity.fetchRequest()
            request.predicate = predicate
            request.fetchOffset = offset ?? 0
            request.fetchLimit = limit ?? 0

            let result = try context.count(for: request)
            return result
        }
        catch {
            return 0
        }
    }
}

