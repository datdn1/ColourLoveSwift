//
//  Color+Networking.swift
//  ColourLoveSwift
//
//  Created by Alexis Creuzot on 07/12/2015.
//  Copyright © 2015 alexiscreuzot. All rights reserved.
//

import Foundation
import Alamofire
import CocoaLumberjack

extension Color{
    
    static func fetch(keywords: String, completion:(result: [RLMObject]?,error: NSError?) -> Void)
    {
        let parameters:Dictionary = ["format":"json", "keywords" : keywords]
        Alamofire.request(.GET, Constants.API.colorsURL, parameters:parameters).responseJSON { response in
            DDLogInfo(response.response!.description) // URL response
            
            if((response.result.error) != nil){
                completion(result:nil, error: response.result.error)
            }else{
                if let JSON:Array = response.result.value as? Array<[String: AnyObject]> {
                    
                    let realm = RLMRealm.defaultRealm()
                    do{
                          try realm.transactionWithBlock {
                            realm.deleteObjects(Color.allObjects())
                            for dict in JSON{
                                let col = Color.mappedColor(dict)
                                realm.addOrUpdateObject(col)
                            }
                        }
                    } catch let error as NSError {
                        print(error)
                    }

                    completion(result:Color.allObjects().toArray(),error: response.result.error)
                }else{
                    completion(result:nil,error: NSError(domain: "Data", code: 0, userInfo: [NSLocalizedDescriptionKey:"Parsing Error"]))
                }
            }
        }
    }
    
}