

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
  @IBOutlet private var searchCityName: UITextField!
  @IBOutlet private var tempLabel: UILabel!
  @IBOutlet private var humidityLabel: UILabel!
  @IBOutlet private var iconLabel: UILabel!
  @IBOutlet private var cityNameLabel: UILabel!

  private let bag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    style()
    ApiController.shared.currentWeather(city: "RxSwift")
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { data in
        self.tempLabel.text = "\(data.temperature)° C"
        self.iconLabel.text = data.icon
        self.humidityLabel.text = "\(data.humidity)%"
        self.cityNameLabel.text = data.cityName
      })
      .disposed(by: bag)
    
// version 1
//    searchCityName.rx.text
//      .orEmpty
//      .filter { !$0.isEmpty }
//      .flatMap { text in
//        return ApiController.shared.currentWeather(city: text)
//          .catchErrorJustReturn(ApiController.Weather.empty)
//    }
//    .observeOn(MainScheduler.instance)
//    .subscribe(onNext: { data in
//      self.tempLabel.text = "\(data.temperature)° C"
//      self.iconLabel.text = data.icon
//      self.humidityLabel.text = "\(data.humidity)%"
//      self.cityNameLabel.text = data.cityName
//    })
//      .disposed(by: bag)
    
// version 2
//    let search = searchCityName.rx.text
//      .orEmpty
//      .filter { !$0.isEmpty }
//      .flatMapLatest { text in
//        return ApiController.shared.currentWeather(city: text)
//          .catchErrorJustReturn(ApiController.Weather.empty)
//    }
//    .share(replay: 1)
//    .observeOn(MainScheduler.instance)
    
// version 3
//    let search = searchCityName.rx.text
//      .orEmpty
    let search = searchCityName.rx.controlEvent(.editingDidEndOnExit)
      .map { self.searchCityName.text ?? "" }
      .filter { !$0.isEmpty }
      .flatMapLatest { text in
        return ApiController.shared.currentWeather(city: text)
          .catchErrorJustReturn(ApiController.Weather.empty)
    }
      .asDriver(onErrorJustReturn: ApiController.Weather.empty)
    
    search.map { "\($0.temperature)° C" }
      .drive(tempLabel.rx.text)
      .disposed(by: bag)
    search
      .map{ $0.icon }
      .drive(iconLabel.rx.text)
      .disposed(by: bag)
    search
      .map{ String($0.humidity) }
      .drive(humidityLabel.rx.text)
      .disposed(by: bag)
    search
      .map{ $0.cityName }
      .drive(cityNameLabel.rx.text)
      .disposed(by: bag)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    Appearance.applyBottomLine(to: searchCityName)
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Style

  private func style() {
    view.backgroundColor = UIColor.aztec
    searchCityName.textColor = UIColor.ufoGreen
    tempLabel.textColor = UIColor.cream
    humidityLabel.textColor = UIColor.cream
    iconLabel.textColor = UIColor.cream
    cityNameLabel.textColor = UIColor.cream
  }
}
