//
//  NetworkingService.swift
//  TDD App
//
//  Created by Maysam Shahsavari on 2023-11-13.
//

import Foundation
import Combine

protocol NetworkingService: AnyObject {
    func fetchImages() -> AnyPublisher<SampleImagesResponse, Error>
    func fetchImageDetails() -> AnyPublisher<ExtraDataResponse, Error>
}
