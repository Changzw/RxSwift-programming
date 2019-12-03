//
//  Filtering Operators in Practice.swift
//  RxSwift-programming
//
//  Created by czw on 12/2/19.
//  Copyright © 2019 czw. All rights reserved.
//

import Foundation
import RxSwift

func filteringOperators() {
  let bag = DisposeBag()
  example("ignoreElements") {
    let strikes = PublishSubject<String>()
    strikes
      .ignoreElements()
      .subscribe { e in
        print("You're out!\(e)")
    }.disposed(by: bag)
    
    strikes.onNext("X")
    strikes.onNext("X")
    strikes.onNext("X")
  }
  
  example("elementAt") {
    let strikes = PublishSubject<String>()
    strikes
      .elementAt(2)
      .subscribe(onNext: { v in
        print("You're out!\(v)")
      })
      .disposed(by: bag)
    
    strikes.onNext("X1")
    strikes.onNext("X2")
    strikes.onNext("X3")
  }
  
  
}
