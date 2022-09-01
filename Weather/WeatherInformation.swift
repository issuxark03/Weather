//
//  WeatherInformation.swift
//  Weather
//
//  Created by Yongwoo Yoo on 2022/03/17.
//

import Foundation

struct WeatherInformation : Codable { //외부표현, JSON 등 사용하기위해 Codable 사용
	let weather: [Weather]
	let temp: Temp
	let name: String
	
	//mapping
	enum CodingKeys: String, CodingKey {
		case weather
		case temp = "main"
		case name
	}
}


struct Weather: Codable {
	let id: Int
	let main: String
	let description: String
	let icon: String
}

struct Temp: Codable {
	let temp: Double
	let feelsLike: Double //feels_like
	let minTemp: Double //temp_min
	let maxTemp: Double //temp_max
	
	//mapping
	enum CodingKeys: String, CodingKey {
		case temp
		case feelsLike = "feels_like"
		case minTemp = "temp_min"
		case maxTemp = "temp_max"
	}
}


