//
//  ViewController.swift
//  Weather
//
//  Created by Yongwoo Yoo on 2022/03/15.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var cityNameTextField: UITextField!
	
	@IBOutlet weak var cityNameLabel: UILabel!
	
	@IBOutlet weak var weatherDescriptionLabel: UILabel!
	
	@IBOutlet weak var tempLabel: UILabel!
	
	@IBOutlet weak var minTempLabel: UILabel!
	@IBOutlet weak var maxTempLabel: UILabel!
	
	@IBOutlet weak var weatherStackView: UIStackView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

	@IBAction func tabFetchWeatherButton(_ sender: UIButton) {
		if let cityName = self.cityNameTextField.text {
			getCurrentWeather(cityName: cityName)
			self.view.endEditing(true) //버튼이 눌리면 키보드가 사라지게
		}
	}
	
	func configureView(weatherInformain: WeatherInformation) {
		self.cityNameLabel.text = weatherInformain.name
		if let weather = weatherInformain.weather.first { //배열의 첫번째요소
			self.weatherDescriptionLabel.text = weather.description
		}
		self.tempLabel.text = "\(Int(weatherInformain.temp.temp - 273.15))℃"
		self.minTempLabel.text = "최저: \(Int(weatherInformain.temp.minTemp - 273.15))℃"
		self.maxTempLabel.text = "최고: \(Int(weatherInformain.temp.maxTemp - 273.15))℃"
	}
	
	func showAlert(message: String){
		let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	
	func getCurrentWeather(cityName: String) {
		guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=eccec4d600de4349eb0d1eb9504659b2") else { return }
		
		let session = URLSession(configuration: .default)
		session.dataTask(with: url) { [weak self] data, response, error in
			let successRange = (200..<300)
			guard let data = data, error == nil else { return }
			let decoder = JSONDecoder()
			
			if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
				guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else { return }
				
				//main thread
				DispatchQueue.main.async {
					self?.weatherStackView.isHidden = false
					self?.configureView(weatherInformain: weatherInformation)
				}
			}else{
				guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
				DispatchQueue.main.async {
					self?.showAlert(message: errorMessage.message)
				}
				
			}
			

		}.resume()
	}
}

