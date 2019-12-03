//
//  Observables.swift
//  RxSwift-programming
//
//  Created by czw on 12/1/19.
//  Copyright © 2019 czw. All rights reserved.
//

import Foundation
import RxSwift

func observables() {
  let bag = DisposeBag()
  
//MARK: just, of, from: array -> observable sequence
  example("just, of, from: array -> observable sequence") {
    let one = 1, two = 2, three = 3
    let ob_just = Observable.just(one)
    let ob_of   = Observable.of(one, two, three)
    let ob_from = Observable.from([one, two, three])
    
    ob_just
      .subscribe(onNext: { (v) in
        print("just:\(v)")
      })
      .disposed(by: bag)
    
    ob_of
      .subscribe(onNext: { (v) in
        print("of:\(v)")
      })
      .disposed(by: bag)
    
    ob_from
      .subscribe(onNext: { (v) in
        print("from:\(v)")
      }, onCompleted: {
        print("from:complete")
      }, onDisposed: {
        print("from:disposed")
      })
      .disposed(by: bag)
  }
  
//MARK: Empty
  example("empty") {
    let empty = Observable<Void>.empty()
    empty
      .subscribe(onNext: { (v) in
        print(v)
      }, onError: { (_) in
        
      }, onCompleted: {
        print("empty complete")
      })
      .disposed(by: bag)
  }
  
//MARK: Never
  //  As opposed to the empty operator, the never operator creates an observable that doesn’t emit anything and never terminates. It can be use to represent an inﬁnite duration.
  example("never") {
    let observable = Observable<Any>.never()
    
    observable.subscribe(
      onNext: {
        element in print(element)
    }, onCompleted: {
      print("Completed")
    }).disposed(by: bag)
  }
  
//MARK: Range
  example("range") {
    let observable = Observable<Int>.range(start: 1, count: 5).map { (x) -> String in
      return "-\(x)"
    }
    
    observable
      .subscribe(onNext: { i in
        print("range:\(i)")
      })
      .disposed(by: bag)
  }
  
//MARK: Create
  example("create") {
    let create = Observable<String>.create { (observer) -> Disposable in
      observer.onNext("one")
      observer.onCompleted()
      return Disposables.create()
    }
    
    let _ = create
      .subscribe(onNext: { (v) in print("create:\(v)") },
                 onError: { (e) in print(e) },
                 onCompleted: { print("create:complete") })
      { print("disposed") }
  }
  example("create error") {
    
    enum MyError: Error {
      case anError
      case info(i: String)
    }

    let create = Observable<String>.create { (observer) -> Disposable in
      observer.onNext("one")
      observer.onError(MyError.info(i: "233"))
      return Disposables.create()
    }
    
    let _ = create
      .subscribe(onNext: { (v) in print("create:\(v)") },
                 onError: { (e) in print(e) },
                 onCompleted: { print("create:complete") })
      { print("disposed") }
  }
  
  //MARK: Deffer
  //  Rather than creating an observable that waits around for subscribers,
//  it’s possible to create observable factories that vend a new observable to each subscriber.
  example("deffered") {
    var flip = false
    let factory: Observable<Int> = Observable.deferred {
      flip.toggle()
      return flip ? Observable.of(1, 2, 3) : Observable.of(4, 5, 6)
    }
    
    for _ in 0...3 {
      factory.subscribe(onNext: {
        print($0, terminator: " ")
      })
        .disposed(by: bag)
      print()
    }
  }
  
  // MARK: Single, Maybe and Completable
  example("Single") {
    
    enum MyError: Error {
      case info(s: String)
    }
    
    let disposeBag = DisposeBag()
    enum FileReadError: Error { case fileNotFound, unreadable, encodingFailed }
    func loadText1(from name: String) -> Single<String> {
      return Single.create { s in
        s(.success(name))
        return Disposables.create {
        }
      }
    }
    func loadText2(from name: String) -> Single<String> {
      return Single.create { s in
        s(.error(MyError.info(s: "hehe:\(name)")))
        return Disposables.create {
        }
      }
    }
    
    loadText1(from: "wtf")
      .subscribe(onSuccess: { (v) in
        print("single:\(v)")
      }) { (e) in
        print("single:\(e)")
    }.disposed(by: bag)
    
    loadText2(from: "wtf")
      .subscribe(onSuccess: { (v) in
        print("single:\(v)")
      }) { (e) in
        print("single:\(e)")
    }.disposed(by: bag)
  }
  
  example("Maybe") {
    enum MyError: Error {
      case info(s: String)
    }
    
    let disposeBag = DisposeBag()
    enum FileReadError: Error { case fileNotFound, unreadable, encodingFailed }
    func compeleted(from name: String) -> Maybe<String> {
      return Maybe.create { s in
        s(.completed)
        return Disposables.create()
      }
    }
    func success(from name: String) -> Maybe<String> {
      return Maybe.create { (m) -> Disposable in
        m(.success(name))
        return Disposables.create()
      }
    }
    func error(from name: String) -> Maybe<String> {
      return Maybe.create { (m) -> Disposable in
        m(.error(MyError.info(s:"hehe")))
        return Disposables.create()
      }
    }
    
    compeleted(from: "233")
      .subscribe(onSuccess: { (m) in
        print("maybe:\(m)")
      }, onError: { (e) in
        print("maybe:\(e)")
      }, onCompleted: {
        print("maybe:completed")
      }).disposed(by: bag)
    
    success(from: "222")
      .subscribe(onSuccess: { (m) in
        print("maybe:\(m)")
      }, onError: { (e) in
        print("maybe:\(e)")
      }, onCompleted: {
        print("maybe:completed")
      }).disposed(by: bag)
    
    error(from: "222")
      .subscribe(onSuccess: { (m) in
        print("maybe:\(m)")
      }, onError: { (e) in
        print("maybe:\(e)")
      }, onCompleted: {
        print("maybe:completed")
      }).disposed(by: bag)
  }
}
