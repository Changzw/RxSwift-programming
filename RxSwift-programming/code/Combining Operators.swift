//
//  Combining Operators.swift
//  RxSwift-programming
//
//  Created by czw on 12/4/19.
//  Copyright © 2019 czw. All rights reserved.
//

import Foundation
import RxSwift

func combiningOperators() {
  let bag = DisposeBag()
  
  example("startWith") {
    let numbers = Observable.of(2, 3, 4)
    let observable = numbers.startWith(1)
    observable
      .subscribe(onNext: { value in
        print(value)
      }, onCompleted: {
        print("completed")
      })
      .disposed(by: bag)
  }
  
//  question：concat just send one completed event，and it belongs to whom？
  example("concat") {
    let first = Observable.of(2, 3)
    let second = Observable.of(4, 5)
    
    let observable = Observable.concat([first, second])
    
    observable
      .subscribe(onNext: { value in
        print(value)
      }, onCompleted: {
        print("completed")
      }).disposed(by: bag)
    print("----------------")
    
    let germanCities = Observable.of("Berlin", "Münich", "Frankfurt")
    let spanishCities = Observable.of("Madrid", "Barcelona", "Valencia")
    let observable_ = germanCities.concat(spanishCities)
    observable_.subscribe(onNext: { (name) in
      print("\(name)")
    }, onCompleted: {
      print("completed")
    })
    .disposed(by: bag)
    
    print("----------------")
    let ob0 = Observable<Int>.create { (ober) -> Disposable in
      ober.onNext(2)
      ober.onCompleted()
      return Disposables.create()
    }
    let ob1 = Observable<Int>.create { (ober) -> Disposable in
      ober.onNext(3)
      ober.onCompleted()
      return Disposables.create()
    }
    ob0
      .concat(ob1)
      .subscribe { (e) in
        print("\(e)")
    }.disposed(by: bag)
    
    example("concatMap") {
      let sequences = [
      "German cities": Observable.of("Berlin", "Münich", "Frankfurt"),
      "Spanish cities": Observable.of("Madrid", "Barcelona", "Valencia") ]
      
      let observable = Observable.of("German cities", "Spanish cities")
        .concatMap { country in
          sequences[country] ?? .empty()
      }
      
      observable
        .subscribe(onNext: { string in
          print(string)
        }).disposed(by: bag)
      
      print("------------")
      
      Observable.of("German cities", "Spanish cities")
        .flatMap { country in
          sequences[country] ?? .empty()
      }
      .subscribe(onNext: { string in
        print(string)
      }).disposed(by: bag)
    }
  }
  
  example("merge") {
//    Results will be different each time you run this code, but they should look similar to this:
    let left = PublishSubject<String>()
    let right = PublishSubject<String>()
    let source = Observable.of(left.asObservable(), right.asObservable())
    //Observable.merge([])
    
    let observable = source.merge()
    observable
      .subscribe(onNext: { value in
        print(value)
      })
      .disposed(by: bag)
    
    var leftValues = ["Berlin", "Munich", "Frankfurt"]
    var rightValues = ["Madrid", "Barcelona", "Valencia"]
    repeat {
      switch Bool.random() {
        case true where !leftValues.isEmpty:
          left.onNext("Left: " + leftValues.removeFirst())
        case false where !rightValues.isEmpty:
          right.onNext("Right: " + rightValues.removeFirst())
        default: break
      }
    } while !leftValues.isEmpty || !rightValues.isEmpty
    
    left.onCompleted()
    right.onCompleted()
  }
  
  example("combineLatest") {
    let left = PublishSubject<String>()
    let right = PublishSubject<String>()
    let observable = Observable
      .combineLatest(left, right) { lastLeft, lastRight in
        "\(lastLeft) \(lastRight)"
    }
    
    let observable0 =
      Observable.combineLatest([left, right]) { strings in
       "-" + strings.joined(separator: " ")
    }

    observable
      .subscribe(onNext: { value in
        print(value)
      })
    .disposed(by: bag)
  
    observable0
      .subscribe(onNext: { (s) in
        print(s)
      })
    
    print("> Sending a value to Left")
    left.onNext("Hello,")
    print("> Sending a value to Right")
    right.onNext("world")
    print("> Sending another value to Right")
    right.onNext("RxSwift")
    print("> Sending another value to Left")
    left.onNext("Have a good day,")
    left.onCompleted()
    right.onCompleted()
  }
  
  example("combine user choice and value") {
    let choice: Observable<DateFormatter.Style> = Observable.of(.short, .long)
    let dates = Observable.of(Date())
    let observable = Observable.combineLatest(choice, dates) { format, when -> String in
      let formatter = DateFormatter()
      formatter.dateStyle = format
      return formatter.string(from: when)
    }
    
    observable
      .subscribe(onNext: { value in
        print(value)
      })
    .disposed(by: bag)
  }
  
  example("zip") {
    enum Weather { case cloudy, sunny }
    let left: Observable<Weather> = Observable.of(.sunny, .cloudy, .cloudy, .sunny)
    let right = Observable.of("Lisbon", "Copenhagen", "London", "Madrid", "Vienna")
    let observable = Observable.zip(left, right) { weather, city in
//      return
      "It's \(weather) in \(city)"
    }
    observable
      .subscribe(onNext: { value in
        print(value)
      }).disposed(by: bag)
  }
  
  example("withLatestFrom") {
//    button 事件使用 textField 的最新值代替
    let button = PublishSubject<Void>()
    let textField = PublishSubject<String>()
    
//    let observable = button.withLatestFrom(textField)
    let observable = textField.sample(button)
    observable
      .subscribe(onNext: { value in
        print(value)
      })
    .disposed(by: bag)
    
    button.onNext(())
    
    textField.onNext("Par")
    textField.onNext("Pari")
    textField.onNext("Paris")
    button.onNext(())
    button.onNext(())
  }
  
  example("amb") {
// 组合多个signals，哪个先发送就 取消订阅另一个
    let left = PublishSubject<String>()
    let right = PublishSubject<String>()
    let observable = left.amb(right)
    observable
      .subscribe(onNext: { value in
        print(value)
      })
      .disposed(by: bag)
    
    left.onNext("Lisbon")
    right.onNext("Copenhagen")
    left.onNext("London")
    left.onNext("Madrid")
    right.onNext("Vienna")
    left.onCompleted()
    right.onCompleted()
  }
  
  example("switchLatest") {
//  只绑定最新的那个 signal
    let one = PublishSubject<String>()
    let two = PublishSubject<String>()
    let three = PublishSubject<String>()
    
    let source = PublishSubject<Observable<String>>()
    let observable = source.switchLatest()
    observable
      .subscribe(onNext: { value in
        print(value)
      })
    .disposed(by: bag)
    
    source.onNext(one)
    one.onNext("Some text from sequence one")
    two.onNext("Some text from sequence two")
    
    source.onNext(two)
    two.onNext("More text from sequence two")
    one.onNext("and also from sequence one")
    
    source.onNext(three)
    two.onNext("Why don't you see me?")
    one.onNext("I'm alone, help me")
    three.onNext("Hey it's three. I win.")
    
    source.onNext(one)
    one.onNext("Nope. It's me, one!")
  }
  
  example("reduce") {
    let source = Observable.of(1, 3, 5, 7, 9)
    
    let observable = source.reduce(0, accumulator: +)
    observable
      .subscribe(onNext: { value in
        print(value)
      })
    .disposed(by: bag)
    
  }
  
  example("scan") {
    let source = Observable.of(1, 3, 5, 7, 9)
    let observable = source.scan(0, accumulator: +)
    observable
      .subscribe(onNext: { value in print(value) })
      .disposed(by: bag)
  }
  
}
