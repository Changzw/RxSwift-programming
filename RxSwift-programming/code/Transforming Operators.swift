//
//  Transforming Operators.swift
//  RxSwift-programming
//
//  Created by czw on 12/3/19.
//  Copyright © 2019 czw. All rights reserved.
//

import Foundation
import RxSwift

struct Student {
  let score: BehaviorSubject<Int>
  
}

func transformingOperators() {
  let bag = DisposeBag()
//  an observable of individual elements into an array of all those elements is by using toArray.
  example("toArray") {
    Observable.of("A", "B", "C")
      .toArray()
      .subscribe({ print($0) })
      .disposed(by: bag)
  }
  
  example("enumerated and map") {
    Observable.of(2, 3, 4)
      .enumerated()
      .map { index, integer in
        index > 2 ? integer * 2 : integer
    }
    .subscribe(onNext: { print($0) })
    .disposed(by: bag)
  }
  
  example("flatMap") {
    let laura = Student(score: BehaviorSubject(value: 80))
    let charlotte = Student(score: BehaviorSubject(value: 90))
    let student = PublishSubject<Student>()
    student
      .flatMap { $0.score }
      .subscribe(onNext: {
        print($0)
      })
      .disposed(by: bag)
    
    student.onNext(laura)
    student.onNext(charlotte)
    charlotte.score.onNext(100)
    laura.score.onNext(70)
    
    charlotte.score
      .subscribe(onNext: { print($0) })
      .disposed(by: bag)
  }
  
  example("flatMapLastest") {
    let laura = Student(score: BehaviorSubject(value: 80))
    let charlotte = Student(score: BehaviorSubject(value: 90))
    let student = PublishSubject<Student>()
    student
      .flatMapLatest { $0.score }
      .subscribe(onNext: {
        print($0)
      })
      .disposed(by: bag)
    
    student.onNext(laura)
    student.onNext(charlotte)
    charlotte.score.onNext(100)
    laura.score.onNext(70)
    
    charlotte.score
      .subscribe(onNext: { print($0) })
      .disposed(by: bag)
  }

  example("materialize and dematerialize") {
    enum MyError: Error { case anError }
    let laura = Student(score: BehaviorSubject(value: 80))
    let charlotte = Student(score: BehaviorSubject(value: 100))
    let student = BehaviorSubject(value: laura)
    
    // can't handle error event
//    let studentScore = student
//      .flatMapLatest { $0.score }
//      studentScore
//      .subscribe(onNext: { print($0) })
//        .disposed(by: bag)
//
//    laura.score.onNext(85)
//    laura.score.onError(MyError.anError)
//    laura.score.onNext(90)
//    student.onNext(charlotte)
    
    
//    let studentScore1 = student
//      .flatMapLatest {
//        $0.score.materialize()
//    }
//
//    studentScore1
//      .subscribe(onNext: {
//        print($0)
//      })
//      .disposed(by: bag)
//
//    laura.score.onNext(85)
//    laura.score.onError(MyError.anError)
//    laura.score.onNext(90)
//    student.onNext(charlotte)
    
    
    let studentScore2 = student
      .flatMapLatest {
        $0.score.materialize()
    }
    
//    Using the materialize operator, you can wrap each event emitted by an observable in an observable.
    studentScore2
//      .catchErrorJustReturn(.next(0))
//      .catchError({ (e) -> Observable<Event<Int>> in
//        print(e)
//        return Observable.empty()
//      })
      .filter {
        guard $0.error == nil else {
          print($0.error!)
          return false
        }
        return true
    }
    .dematerialize()
    .subscribe(onNext: { print($0) })
    .disposed(by: bag)
  }
  
}
