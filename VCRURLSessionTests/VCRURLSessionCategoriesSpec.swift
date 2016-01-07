//
//  VCRURLSessionCategoriesSpec.swift
//  VCRURLSession
//
//  Created by Plunien, Johannes on 07/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

import Quick
import Nimble

class VCRURLSessionCategoriesSpec: QuickSpec {
    override func spec() {
        describe("NSError+VCRURLSession") {
            describe("VCRURLSession_dictionaryValue") {
            }
        }

        describe("NSHTTPURLResponse+VCRURLSession") {
            describe("VCRURLSession_dictionaryValue") {
                let url = NSURL.init(string: "http://www.google.com")!
                let statusCode = 200
                var headers = ["Content-Type": "application/json"]

                it("stores statusCode") {
                    let response = NSHTTPURLResponse.init(URL: url, statusCode: statusCode, HTTPVersion: nil, headerFields: headers)
                    let result: NSDictionary = response!.VCRURLSession_dictionaryValueWithData(nil)

                    expect(result["statusCode"] as? Int).to(equal(statusCode))
                }

                it("stores headers") {
                    let response = NSHTTPURLResponse.init(URL: url, statusCode: statusCode, HTTPVersion: nil, headerFields: headers)
                    let result: NSDictionary = response!.VCRURLSession_dictionaryValueWithData(nil)

                    expect(result["headers"] as? Dictionary).to(equal(headers))
                }

                it("stores text body") {
                    headers["Content-Type"] = "text/plain"
                    let response = NSHTTPURLResponse.init(URL: url, statusCode: statusCode, HTTPVersion: nil, headerFields: headers)
                    let result: NSDictionary = response!.VCRURLSession_dictionaryValueWithData("foo".dataUsingEncoding(NSUTF8StringEncoding))

                    expect(result["body"] as? String).to(equal("foo"))
                }

                it("stores form encoded body") {
                    headers["Content-Type"] = "application/x-www-form-urlencoded"
                    let response = NSHTTPURLResponse.init(URL: url, statusCode: statusCode, HTTPVersion: nil, headerFields: headers)
                    let result: NSDictionary = response!.VCRURLSession_dictionaryValueWithData("foo".dataUsingEncoding(NSUTF8StringEncoding))

                    expect(result["body"] as? String).to(equal("foo"))
                }

                it("stores json encoded body") {
                    headers["Content-Type"] = "application/json"
                    let response = NSHTTPURLResponse.init(URL: url, statusCode: statusCode, HTTPVersion: nil, headerFields: headers)
                    let result: NSDictionary = response!.VCRURLSession_dictionaryValueWithData("{\"foo\":1,\"bar\":2}".dataUsingEncoding(NSUTF8StringEncoding))

                    expect(result["body"] as? Dictionary).to(equal(["foo": 1, "bar": 2]))
                }

                it("stores invalid json encoded body") {
                    headers["Content-Type"] = "application/json"
                    let response = NSHTTPURLResponse.init(URL: url, statusCode: statusCode, HTTPVersion: nil, headerFields: headers)
                    let result: NSDictionary = response!.VCRURLSession_dictionaryValueWithData("{\"foo\":1,\"bar\":".dataUsingEncoding(NSUTF8StringEncoding))

                    expect(result["body"] as? String).to(equal("{\"foo\":1,\"bar\":"))
                }

                it("stores binary encoded body") {
                    headers["Content-Type"] = "application/binary"
                    let response = NSHTTPURLResponse.init(URL: url, statusCode: statusCode, HTTPVersion: nil, headerFields: headers)
                    let result: NSDictionary = response!.VCRURLSession_dictionaryValueWithData("foo".dataUsingEncoding(NSUTF8StringEncoding))

                    expect(result["body"] as? String).to(equal("Zm9v"))
                }
            }
        }

        describe("NSURLRequest+VCRURLSession") {
            describe("VCRURLSession_dictionaryValue") {
                let url = NSURL.init(string: "http://www.google.com")!
                let request = NSMutableURLRequest.init(URL: url, cachePolicy: .ReloadIgnoringCacheData, timeoutInterval: 5)

                it("stores url") {
                    let result: NSDictionary = request.VCRURLSession_dictionaryValue

                    expect(result["url"] as? String).to(equal(url.absoluteString))
                }

                it("stores headers") {
                    request.allHTTPHeaderFields = ["Content-Type": "application/json"]
                    let result: NSDictionary = request.VCRURLSession_dictionaryValue

                    expect(result["headers"] as? Dictionary).to(equal(request.allHTTPHeaderFields))
                }

                it("stores method") {
                    request.HTTPMethod = "POST"
                    let result: NSDictionary = request.VCRURLSession_dictionaryValue

                    expect(result["method"] as? String).to(equal(request.HTTPMethod))
                }
            }
        }
    }
}
