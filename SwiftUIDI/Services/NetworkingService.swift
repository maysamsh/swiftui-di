//
//  NetworkingService.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-11-13.
//

import Foundation
import Combine

protocol NetworkingService: AnyObject {
    var imagesPath: String { get }
    var extraDataPath: String { get }
    var decoder: JSONDecoder { get }
    func fetchImages() -> AnyPublisher<SampleImagesResponse, Error>
    func fetchImageDetails() -> AnyPublisher<ExtraDataResponse, Error>
}
