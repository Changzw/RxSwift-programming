//
//  OperatorViewController.swift
//  RxSwift-programming
//
//  Created by czw on 12/6/19.
//  Copyright © 2019 czw. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OperatorViewController: UIViewController {
  
  let bag = DisposeBag()
  let containerView = UIView()
  var timer: DispatchSourceTimer?
  
  @objc let type: String
  
  init(type: String) {
    self.type = type
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(containerView)
    containerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
      containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100.0),
      containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])

    perform(Selector(type))
  }
}

extension OperatorViewController {
  @objc func buffer() {
    let elementsPerSecond = 1
    let maxElements = 5
    let replayedElements = 1
    let replayDelay: TimeInterval = 3
    
    let sourceObservable = Observable<Int>.create { observer in
      var value = 1
      self.timer = DispatchSource.timer(interval: 1.0 / Double(elementsPerSecond), queue: .main) {
        if value <= maxElements {
          observer.onNext(value)
          value += 1
        }
      }
      return Disposables.create { self.timer?.suspend() }
    }
    .replay(replayedElements)
    
    let sourceTimeline = TimelineView<Int>.make()
    let replayedTimeline = TimelineView<Int>.make()
    let stack = UIStackView.makeVertical([
      UILabel.makeTitle("replay"),
      UILabel.make("Emit \(elementsPerSecond) per second:"),
      sourceTimeline,
      UILabel.make("Replay \(replayedElements) after \(replayDelay) sec:"),
      replayedTimeline])
    
    sourceObservable.subscribe(sourceTimeline)
      .disposed(by: bag)
    DispatchQueue.main.asyncAfter(deadline: .now() + replayDelay) {
      sourceObservable.subscribe(replayedTimeline)
        .disposed(by: self.bag)
    }
    sourceObservable.connect()
      .disposed(by: bag)
    
    containerView.addSubview(stack)
  }
  
  @objc func delay() {
    let elementsPerSecond = 1
    let delayInSeconds: RxTimeInterval = RxTimeInterval.milliseconds(1500)

    let sourceObservable = PublishSubject<Int>()

    let sourceTimeline = TimelineView<Int>.make()
    let delayedTimeline = TimelineView<Int>.make()

    let stack = UIStackView.makeVertical([
      UILabel.makeTitle("delay"),
      UILabel.make("Emitted elements (\(elementsPerSecond) per sec.):"),
      sourceTimeline,
      UILabel.make("Delayed elements (with a \(delayInSeconds)s delay):"),
      delayedTimeline])

    var current = 1
    timer = DispatchSource.timer(interval: 1.0 / Double(elementsPerSecond), queue: .main) {
      sourceObservable.onNext(current)
      current = current + 1
    }
    
    sourceObservable.subscribe(sourceTimeline)
      .disposed(by: bag)
    
    // Setup the delayed subscription
    Observable<Int>
      .timer(3, scheduler: MainScheduler.instance)
      .flatMap { _ in
        sourceObservable.delay(delayInSeconds, scheduler: MainScheduler.instance)
    }
    .subscribe(delayedTimeline)
    .disposed(by: bag)

    containerView.addSubview(stack)
  }
  
  @objc func replay(){
    let elementsPerSecond = 1
    let replayedElements = 1
    let replayDelay: TimeInterval = 3
    
    let sourceObservable = Observable<Int>
      .interval(RxTimeInterval.milliseconds(Int(1000.0 / Double(elementsPerSecond))), scheduler: MainScheduler.instance)
      .replay(replayedElements)
    
    let sourceTimeline = TimelineView<Int>.make()
    let replayedTimeline = TimelineView<Int>.make()
    
    let stack = UIStackView.makeVertical([
      UILabel.makeTitle("replay"),
      UILabel.make("Emit \(elementsPerSecond) per second:"),
      sourceTimeline,
      UILabel.make("Replay \(replayedElements) after \(replayDelay) sec:"),
      replayedTimeline])
    
    sourceObservable.subscribe(sourceTimeline)
      .disposed(by: bag)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + replayDelay) {
      sourceObservable.subscribe(replayedTimeline)
        .disposed(by: self.bag)
    }
    
    sourceObservable.connect()
      .disposed(by: bag)
    
    containerView.addSubview(stack)
  }
  
  @objc func timeout() {
    
    let button = UIButton(type: .system)
    button.setTitle("Press me now!", for: .normal)
    button.sizeToFit()
    
    let tapsTimeline = TimelineView<String>.make()
    
    let stack = UIStackView.makeVertical([
      button,
      UILabel.make("Taps on button above"),
      tapsTimeline])
    
    let _ = button
      .rx.tap
      .map { _ in "•" }
      .timeout(5, other: Observable.just("X"), scheduler: MainScheduler.instance)
      .subscribe(tapsTimeline)

    containerView.addSubview(stack)
  }
  
  @objc func window() {
    let elementsPerSecond = 3
    let windowTimeSpan: RxTimeInterval = RxTimeInterval.milliseconds(4000)
    let windowMaxCount = 10
    let sourceObservable = PublishSubject<String>()
    
    let sourceTimeline = TimelineView<String>.make()
    
    let stack = UIStackView.makeVertical([
      UILabel.makeTitle("window"),
      UILabel.make("Emitted elements (\(elementsPerSecond) per sec.):"),
      sourceTimeline,
      UILabel.make("Windowed observables (at most \(windowMaxCount) every \(windowTimeSpan) sec):")])
    
    timer = DispatchSource.timer(interval: 1.0 / Double(elementsPerSecond), queue: .main) {
      sourceObservable.onNext("🐱")
    }
    
    _ = sourceObservable.subscribe(sourceTimeline)
    
    _ = sourceObservable
      .window(timeSpan: windowTimeSpan, count: windowMaxCount, scheduler: MainScheduler.instance)
      .flatMap { windowedObservable -> Observable<(TimelineView<Int>, String?)> in
        let timeline = TimelineView<Int>.make()
        stack.insert(timeline, at: 4)
        stack.keep(atMost: 8)
        return windowedObservable
          .map { value in (timeline, value) }
          .concat(Observable.just((timeline, nil)))
    }
    .subscribe(onNext: { tuple in
      let (timeline, value) = tuple
      if let value = value {
        timeline.add(.next(value))
      } else {
        timeline.add(.completed(true))
      }
    })
    
    containerView.addSubview(stack)
  }
}
