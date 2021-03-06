//
//  APIProvider.swift
//  ColourLoveSwift
//
//  Created by Alexis Creuzot on 17/12/2015.
//  Copyright © 2015 alexiscreuzot. All rights reserved.
//

import Foundation
import CocoaLumberjack
import Alamofire

public class API {

    public static let baseURL: String = "http://colourlovers.com/api"

    public enum Endpoints {

        case Colors(String)
        case Palettes(String)
        case Patterns(String)

        public var method: Alamofire.Method {
            switch self {
            case .Colors,
                 .Palettes,
                 .Patterns:
                return Alamofire.Method.GET
            }
        }

        public var path: String {
            switch self {
            case .Colors:
                return baseURL+"/colors"
            case .Palettes:
                return baseURL+"/palettes"
            case .Patterns:
                return baseURL+"/patterns"
            }
        }

        public var parameters: [String : AnyObject] {
            var parameters = ["format":"json"]
            switch self {
            case .Colors(let keywords):
                parameters["keywords"] = keywords
                break
            case .Palettes(let keywords):
                parameters["keywords"] = keywords
                break
            case .Patterns(let keywords):
                parameters["keywords"] = keywords
                break
            }
            return parameters
        }
    }

    public static func request(
        endpoint: API.Endpoints,
        completionHandler: Response<AnyObject, NSError> -> Void)
        -> Request {

            let request =  Manager.sharedInstance.request(
                endpoint.method,
                endpoint.path,
                parameters: endpoint.parameters,
                encoding: .URL,
                headers: nil
                ).responseJSON { response in

                    if (response.result.error) != nil {
                        DDLogError("\n<----\n" + response.result.error!.description)
                        completionHandler(response)
                    } else {
                        DDLogInfo("\n<----\n" + response.response!.description)
                        completionHandler(response)
                    }
            }
            DDLogInfo("\n---->\n" + request.description)
            return request
    }
}
