//
//  APIManager.swift
//  LaundryToRun
//
//  Created by IOS on 29/11/17.
//  Copyright © 2017 Ankush Chakraborty. All rights reserved.
//


import Alamofire

class APIManagerResponse {
    fileprivate let resp: Result<Any>!
    var dictionary: Dictionary<String, Any> {
        if let _ = resp.value {
            return resp.value as! Dictionary<String, Any>
        }
        return Dictionary<String, Any>()
    }
    var array: [Dictionary<String, Any>] {
        if let _ = resp.value {
            return resp.value as! [Dictionary<String, Any>]
        }
        return [Dictionary<String, Any>]()
    }
    init(response: Result<Any>) {
        resp = response
    }
}

class APIManager {
    
    enum ResponseType {
        case JSON
        case XML
    }
    
    func post(toURL: URL, params: Dictionary<String, Any>, responseType: ResponseType, progress: @escaping (_ progress: Progress) -> (), success: @escaping (_ response: APIManagerResponse) -> (), failure:  @escaping (_ error: APIManagerResponse) -> ()) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(toURL.absoluteString, method: .post, parameters: params,encoding: JSONEncoding.default, headers: ["x-api-key": API_AUTH_KEY]).responseJSON {
            response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch response.response?.statusCode {
            case 200?:
                success(APIManagerResponse(response: response.result))
            /*case 400?, 401?, 404?, 405?, 500?:
                failure(APIManagerResponse(response: response.result))*/
            default:
                failure(APIManagerResponse(response: response.result))
            }
        }
    }
    
    func get(toURL: URL, params: Dictionary<String, Any>, responseType: ResponseType, progress: @escaping (_ progress: Progress) -> (), success: @escaping (_ response: APIManagerResponse) -> (), failure:  @escaping (_ error: APIManagerResponse) -> ()) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(toURL.absoluteString, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: ["x-api-key": API_AUTH_KEY]).responseJSON {
            response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch response.response?.statusCode {
            case 200?:
                success(APIManagerResponse(response: response.result))
            /*case 400?, 401?, 404?, 405?, 500?:
                failure(APIManagerResponse(response: response.result))*/
            default:
                failure(APIManagerResponse(response: response.result))
            }
        }
    }

    func post(toURL: URL, params: Any, files:[Dictionary<String, Any>], responseType: ResponseType, progress: @escaping (_ progress: Progress) -> (), success: @escaping (_ response: APIManagerResponse) -> (), failure:  @escaping (_ error: Error?) -> ()) {
        /*UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let config = URLSessionConfiguration.default
        let manager = AFHTTPSessionManager(baseURL: BASE_URL, sessionConfiguration: config)
        manager.requestSerializer.setValue(API_AUTH_KEY, forHTTPHeaderField: "x-api-key")
        manager.responseSerializer.acceptableContentTypes = ["text/html", "application/json"]
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(toURL.absoluteString, parameters: params, constructingBodyWith: { (formData: AFMultipartFormData) in
            for dict in files {
                formData.appendPart(withFileData: dict["data"] as! Data, name: dict["key"] as! String, fileName: dict["name"] as! String, mimeType: dict["mimeType"] as! String)
            }
        }, progress: { (prog: Progress) in
            progress(prog)
        }, success: { (task: URLSessionDataTask, response: Any?) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.jsonObject(fromData: response as! Data, responseData: { (responseJSON) in
                print(responseJSON ?? "")
                success(APIManagerResponse(response: responseJSON ?? ""))
            }, error: { (err) in
                print(err)
                failure(err as? Error)
            })
        }) { (task: URLSessionDataTask?, error: Error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            print(error.localizedDescription)
            failure(error)
        }*/
    }

    func delete(toURL: URL, params: Any?, responseType: ResponseType, progress: @escaping (_ progress: Progress) -> (), success: @escaping (_ response: APIManagerResponse) -> (), failure:  @escaping (_ error: Error?) -> ()) {
        /*UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let config = URLSessionConfiguration.default
        let manager = AFHTTPSessionManager(baseURL: BASE_URL, sessionConfiguration: config)
        //        manager.responseSerializer.acceptableContentTypes = ["text/html", "application/json"]
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.delete(toURL.absoluteString, parameters: params, success: {(task: URLSessionDataTask, response: Any?) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.jsonObject(fromData: response as! Data, responseData: { (responseJSON) in
                print(responseJSON ?? "")
                success(APIManagerResponse(response: responseJSON ?? ""))
            }, error: { (err) in
                print(err)
                failure(err as? Error)
            })
        }) { (task: URLSessionDataTask?, error: Error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            print(error.localizedDescription)
            failure(error)
        }*/
    }
}


extension APIManager {
    func jsonObject(fromData: Data, responseData: @escaping (_ json: Any?) -> (), error: @escaping (_ err: Any) -> ()) {
        do {
            let json = try JSONSerialization.jsonObject(with: fromData, options: JSONSerialization.ReadingOptions.mutableContainers)
            responseData(json)
        } catch let myJSONError {
            error(myJSONError)
        }
    }
}
