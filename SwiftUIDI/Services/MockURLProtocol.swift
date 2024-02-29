//
//  MockURLProtocol.swift
//  SwiftUI-DITests
//
//  Created by Maysam Shahsavari on 2024-02-27.
//

import Foundation

/// Tutorial from https://www.hackingwithswift.com/articles/153/how-to-test-ios-networking-code-the-easy-way
class MockURLProtocol: URLProtocol {
    static var testURLs = [URL?: Data]()

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let url = request.url {
            if let data = MockURLProtocol.testURLs[url] {
                self.client?.urlProtocol(self, didLoad: data)
            }
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() { }
}
