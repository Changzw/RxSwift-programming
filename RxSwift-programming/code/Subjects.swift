//
//  Subjects.swift
//  RxSwift-programming
//
//  Created by czw on 12/1/19.
//  Copyright © 2019 czw. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

// Observable & Observer
/*
a common need when developing apps is to manually add new values onto an observable at runtime that will then be emitted to subscribers.
 What you want is something that can act as both an observable and as an observer. And that something is called a Subject.
 */
/*
• PublishSubject: Starts empty and only emits new elements to subscribers.

• BehaviorSubject: Starts with an initial value and replays it or the latest element to new subscribers.

• ReplaySubject: Initialized with a buffer size and will maintain a buffer of elements up to that size and replay it to new subscribers.

• AsyncSubject: Emits only the last .next event in the sequence, and only when the subject receives a .completed event. This is a seldom used kind of subject, and you won't use it in this book. It's listed here for the sake of completeness.

• PublishRelay and BehaviorRelay: These wrap their relative subjects, but only

accept .next events. You cannot add a .completed or .error event onto relays at all, so they're great for non-terminating sequences.
 */

func subjects() {
//  hot signal
  let bag = DisposeBag()
//  MARK: PublishSubject
  example("PublishSubject") {
    let subject = PublishSubject<Int>()
    subject.onNext(1)
    subject.onNext(2)
    
    subject
      .subscribe(onNext: { (v) in
        print("PublishSubject:\(v)")
      })
    .disposed(by: bag)
    
    subject.onNext(3)
    subject.onNext(4)
  }
  
//  Behavior subjects work similarly to publish subjects, except they will replay the latest .next event to new subscribers.
//  MARK: BehaviorSubject
  example("BehaviorSubject") {
    let behavior = BehaviorSubject<Int>(value: 3)
    
    print((try? behavior.value()) ?? 0)
    
    let disposable = behavior
      .subscribe { (v) in
        print("BehaviorSubject:\(v)")
    }
    behavior.onNext(2)
    print((try? behavior.value()) ?? 0)
    
    disposable.dispose()
  }
  
  example("ReplaySubject") {
    let replay = ReplaySubject<Int>.create(bufferSize: 2)
    replay.onNext(1)
    replay.onNext(2)
    replay
      .subscribe(onNext: { (v) in
        print("ReplaySubject1:\(v)")
      }).disposed(by: bag)
    
    replay.onNext(3)
    replay
      .subscribe(onNext: { (v) in
        print("ReplaySubject2:\(v)")
      }).disposed(by: bag)
    
  }
  
//  you add a value onto a relay by using the accept(_:) method.
  /*
   Unlike other subjects (and observables in general),
   you add a value onto a relay by using the accept(_:) method.
   In other words, you don’t use onNext(_:).
   This is due to the fact relays can only accept values,
   and you cannot add a .error or .completed event onto them.
   
   A PublishRelay wraps a PublishSubject and a BehaviorRelay wraps a BehaviorSubject.
   What sets relays apart from their wrapped subjects is that they are guaranteed to never
   
   terminate.
   */
  example("PublishRelay") {
    let relay = PublishRelay<String>()
    relay.accept("toggling")
    relay
      .subscribe(onNext: { print($0) })
      .disposed(by: bag)
    relay.accept("1")
  }
  
  
  example("BehaviorRelay") {
    let relay = BehaviorRelay(value: "Initial value")
    relay.accept("New initial value")
    relay
      .subscribe({ (e) in
        print("BehaviorRelay:\(e)")
      })
      .disposed(by: bag)
    
    print(relay.value)
    relay.accept("2")
  }
}

