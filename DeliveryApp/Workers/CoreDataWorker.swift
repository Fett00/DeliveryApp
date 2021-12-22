//
//  CoreDataWorker.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 12.12.2021.
//

import UIKit
import CoreData

protocol CoreDataWorkerProtocol{
    
}

class CoreDataWorker: CoreDataWorkerProtocol{
    
}

//class CoreDataWorker{
//
//    //Создание контекста для работы с CoreData
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
//
//    static public let shared = CoreDataWorker()
//    private init(){}
//
//    //Сохранение Данных в БД
//    private func save(){
//        do {
//            try self.context.save()
//        }
//        catch  {fatalError("Can not save in CoreData!")}
//    }
//
//    //Добавление записи в CoreData
//    func add(createObject: ()->()) {
//
//        createObject()
//        save()
//    }
//
//    //Удаление записи из CoreData
//    func delete(withCondition condition:(String,String)?){
//
//        var predicate:NSPredicate?
//
//        if let condition = condition{
//            predicate = NSPredicate(format: "\(condition.0)=%@", condition.1)
//        }
//
//        let request = Entity.fetchRequest()
//        request.predicate = predicate
//
//        do {
//
//            let toDelete = try context.fetch(request) as! [Entity]
//            context.delete(toDelete.first!)
//        }
//        catch {
//
//            print(error.localizedDescription)
//        }
//
//        save()
//    }
//
//    //Обновление записей в CoreData
//    func refresh() {
//
//    }
//
//
//    //TODO: Добавить запрос к БД с условиями(для поиска)
//    //Получение записей из CoreData
//
//    //condition: First String - argument, second - condition.
//    //Exm: ("name","Ivan") -> "rows where name = Ivan"
//
//    func get(withCondition condition:(String,String)?,withLimit limit:Int?) -> [Entity] {
//
//        var predicate:NSPredicate?
//
//        if let condition = condition{
//            predicate = NSPredicate(format: "\(condition.0)%@", condition.1)
//        }
//
//        do {
//
//            let request = Entity.fetchRequest()
//            request.predicate = predicate
//            request.fetchLimit = limit ?? 0
//
//            let result:[Entity] = try context.fetch(request) as! [Entity]
//            return result
//        }
//        catch {
//            return []
//        }
//    }
//}

