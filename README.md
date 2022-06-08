# DeliveryApp

<a href="https://swift.org">
    <img src="https://img.shields.io/badge/swift-5.6-brightgreen.svg" alt="Swift 5.2">
</a>
<a href="https://swift.org">
    <img src="https://img.shields.io/badge/ios-13.0-blue.svg" alt="Swift 5.2">
</a>

#

Незамысловатый проект реализовывающий следующий функционал:
* CRUD операции с CoreData
* User Defaults
* Взаимодействие с сетью
* Работа с JSON
* Многопоточность
* Таблицы и коллекции
* AutoLayout и ручной layout

Архитектура:

```mermaid
graph TB

    subgraph Views
    direction TB
    View1
    ViewN
    end

    subgraph Sub Workers
    NetworkWorker
    CoreDataWorker
    FooWorker
    end

    View1(View) -->|Request| DataWorker(Data Worker)   
    ViewN(View N) -->|Request| DataWorker(Data Worker)
    DataWorker(Data Worker) -->|Handle| View1(View 1)
    DataWorker(Data Worker) -->|Handle| ViewN(View N)
    CoreDataWorker(Core Data Worker) <--> DataWorker
    NetworkWorker(Network Worker) <--> DataWorker
    FooWorker(Foo Worker) <--> DataWorker
```
