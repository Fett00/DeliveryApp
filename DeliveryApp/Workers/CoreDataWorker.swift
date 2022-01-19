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
    
    func delete(withCondition condition: String?)
    
    func refresh()
    
    func get<Entity: NSManagedObject>(withCondition condition: String?, withLimit limit: Int?) -> [Entity]
    
}

class CoreDataWorker: CoreDataWorkerProtocol{

    //Создание контекста для работы с CoreData
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()

    //Сохранение Данных в БД
    private func save(){
        do {
            try self.context.save()
        }
        catch  { fatalError("Can not save in CoreData!") }
    }

    //Добавление записи в CoreData
    func add(createObject: ()->()) {

        createObject()
        save()
    }

    //Удаление записей из CoreData
    func delete(withCondition condition: String?){
        
    }

    //Обновление записей в CoreData
    func refresh() {

    }


    //TODO: Добавить запрос к БД с условиями(для поиска)
    //Получение записей из CoreData

    //condition: First String - argument, second - condition.
    //Exm: ("name","Ivan") -> "rows where name = Ivan"

    func get<Entity: NSManagedObject>(withCondition condition: String?, withLimit limit: Int?) -> [Entity] {

        var predicate:NSPredicate?

        if let condition = condition{
            predicate = NSPredicate(format: condition)
        }

        do {

            let request = Entity.fetchRequest()
            request.predicate = predicate
            request.fetchLimit = limit ?? 0

            let result:[Entity] = try context.fetch(request) as! [Entity]
            return result
        }
        catch {
            return []
        }
    }
}

