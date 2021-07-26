//
//  fetchAPIs.swift
//  firstApp
//
//  Created by ChinhPV on 3/8/21.
//  Copyright © 2021 ChinhPV. All rights reserved.
//
import Foundation
import Alamofire

class fetchAPIs{

    struct Tiin {
        static let URL = "http://api.tiin.vn/TiinAPI/ws/"
        static let GET_NEWS = URL+"news/getArticleOfCategory"
        static let GET_NEWS_DETAIL = URL+"news/getArticleDetail"
        static let GET_VIDEO = URL+"news/getListVideoHomepage"
        static let GET_VIDEO_DETAIL = URL + "news/getVideoDetail"
        static let GET_IMAGE = URL + "news/getHomepageArticleImage"
        static let GET_IMAGE_DETAIL = URL+"news/getPhotoListOfArticle"
    }
    
    func createMeals(meal: Meal, completion: @escaping (Bool) -> ()) {
        let dataTest: [String: Any] = [
            "name" : meal.name,
            "photo" : meal.photo,
            "rating" : meal.rating,
            "address" : meal.address,
        ]
        let data = try? JSONSerialization.data(withJSONObject: dataTest, options: [])
        var request = URLRequest(url: URL(string: API.URL+MEAL.CREATE+"\(meal.user_id)")!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        print("API Create data in json: ",NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        AF.request(request).validate(statusCode: 200..<300).responseJSON{ (response) in
            switch response.result{
            case .success(_):
                completion(true)
                print("Meal create successful")
            case .failure(let err):
                print("Meal create failed", err)
                completion(false)
            }
        }.resume()
    }
    
    func updateMeals(meal: Meal, completion: @escaping(Bool) -> () ){
        let dataTest: [String: Any] = [
            "id" : meal.id,
            "name" : meal.name,
            "photo" : meal.photo,
            "rating" : meal.rating,
            "address" : meal.address
        ]
        let data = try? JSONSerialization.data(withJSONObject: dataTest, options: [])
        var request = URLRequest(url: URL(string: API.URL+MEAL.UPDATE)!)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        print("API update data of id: \(meal.id) in json: ",NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        AF.request(request).validate(statusCode: 200..<300).responseJSON{ response in
            switch response.result{
            case .success(_):
                completion(true)
            case .failure(let err):
                print("Meal update failed", err)
                completion(false)
            }
        }.resume()
    }
    
    func deleteMeals(id: Int, completion: @escaping(Bool) -> ()) {
        var request = URLRequest(url: URL(string: API.URL+MEAL.DELETE+"?id=\(id)")!)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print("API delete data of id: \(id)")
        AF.request(request).validate(statusCode: 200..<300).responseJSON{ response in
            switch response.result{
            case .success(_):
                completion(true)
            case .failure(let err):
                print("Meal delete failed", err)
                completion(false)
            }
        }.resume()
    }

    func createImage(image: UIImage, name: String, withCompletion completion:@escaping (Bool) -> Void){
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(image.pngData()!, withName: "file" , fileName: "\(name).jpeg", mimeType: "image/jpeg")
        },
            to: API.URL+IMG.CREATE, method: .post , headers: headers)
            .response { resp in
                switch resp.result{
                case .success(_):
                    completion(true)
                case .failure(_):
                    completion(false)
                }
            }.resume()
    }
    
    func login(username: String, password: String, withCompletion completion: @escaping (User?,String?) -> Void){
        let login: [String: Any] = [
            "username": username,
            "password": password
        ]
        let data = try? JSONSerialization.data(withJSONObject: login, options:[])
        var request = URLRequest(url: URL(string: API.URL+USER.LOGIN)!)
        request.httpMethod = HTTP_METHOD.POST
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.cachePolicy = .reloadIgnoringCacheData
        request.httpBody = data
        AF.request(request).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.result {
            case .success(let result as NSDictionary):
                if !(result.count < 3) {
                    var meals = [Meal]()
                    for x in result.value(forKey: "meals") as! NSArray {
                        let y = x as! NSDictionary
                        let meal = Meal(id: y.value(forKey: "id") as! Int,
                                        name: y.value(forKey: "name") as! String,
                                        photo: y.value(forKey: "photo") as? String ?? "",
                                        rating: y.value(forKey: "rating") as! Int,
                                        address: y.value(forKey: "address") as! String,
                                        user_id: result.value(forKey: "id") as! Int)
                        meals.append(meal!)
                    }
                    let user = User(id: result.value(forKey: "id") as! Int,
                                    username: result.value(forKey: "username") as! String,
                                    password: result.value(forKey: "password") as! String,
                                    name: result.value(forKey: "name") as? String ?? "",
                                    phone: result.value(forKey: "phone") as? String ?? "",
                                    address: result.value(forKey: "address") as? String ?? "",
                                    photo: result.value(forKey: "photo") as? String ?? "",
                                    meals: meals)
                    completion(user,nil)
                } else {
                    completion(nil,"User login error")
                }
            default:
                print("API connect Error")
                completion(nil,"API connect Error")
            }
            }.resume()
    }
    
    func register(user: User, withCompletion completion: @escaping (Bool) -> Void){
        let userJS:[String: Any] = [
            "username": user.username,
            "password": user.password,
            "name" : user.name,
            "phone" : user.phone,
            "address": user.address,
            "photo" : user.photo,
        ]
        let data = try? JSONSerialization.data(withJSONObject: userJS, options: [])
        var request = URLRequest(url: URL(string: API.URL+USER.CREATE)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.cachePolicy = .reloadIgnoringCacheData
        request.httpBody = data
        AF.request(request).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.result{
            case .success(_):
                print("API create user success")
                completion(true)
            default:
                print("API create user error")
                completion(false)
            }
        }.resume()
        
    }
    
    func update(user: User, withCompletion completion: @escaping (Bool) -> Void){
        let userJS:[String: Any] = [
            "password": user.password,
            "name" : user.name,
            "phone" : user.phone,
            "address": user.address,
            "photo" : user.photo
        ]
        let data = try? JSONSerialization.data(withJSONObject: userJS, options: [])
        var request = URLRequest(url: URL(string: API.URL+USER.UPDATE+"?username=\(user.username)")!)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.cachePolicy = .reloadIgnoringCacheData
        request.httpBody = data
        AF.request(request).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.result{
            case .success(_):
                print("API update user success")
                completion(true)
            default:
                print("API update user error")
                completion(false)
            }
        }.resume()
        
    }
    
    func updateLogout(user: User, withCompletion completion: @escaping (Bool) -> Void){
        var meals : [[String: Any]]?
        for x in user.meals {
            let y : [String: Any] = [
                "id": x.id,
                "name": x.name,
                "address": x.address,
                "photo" : x.photo,
                "rating": x.rating
            ]
            meals?.append(y)
        }
        print(meals)
        let userJS:[String: Any] = [
            "username": user.username,
            "password": user.password,
            "name" : user.name,
            "phone" : user.phone,
            "address": user.address,
            "photo" : user.photo,
            "meals": meals ?? []
        ]
        let data = try? JSONSerialization.data(withJSONObject: userJS, options: [])
        var request = URLRequest(url: URL(string: API.URL+USER.COMPLETE_UPDATE+"?id=\(user.id)")!)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.cachePolicy = .reloadIgnoringCacheData
        request.httpBody = data
        AF.request(request).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.result{
            case .success(_):
                print("API complete update user success")
                completion(true)
            default:
                print("API complete update user error")
                completion(false)
            }
        }.resume()
        
    }
    
    func validate(username: String, withCompletion completion: @escaping (Bool) -> Void){
        var request = URLRequest(url: URL(string: API.URL+USER.VALIDATE+"?username=\(username)")!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.cachePolicy = .reloadIgnoringCacheData
        AF.request(request).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.result{
            case .success(let result as NSDictionary):
                let check = result.value(forKey: "message") as! String
                if check == "TRUE" {
                    print("username available")
                    completion(true)
                } else {
                    print("username already taken")
                    completion(false)
                }
            default:
                print("API validate error")
                completion(false)
            }
        }.resume()
    }
    
    func getNews(completion: @escaping (Bool, NSDictionary?) -> ()) {
        var request = URLRequest(url: URL(string: Tiin.GET_NEWS )!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.cachePolicy = .reloadIgnoringCacheData
        AF.request(request).validate(statusCode: 200..<300).responseJSON{ (response) in
            switch response.result{
            case .success(let data as NSDictionary):
                completion(true, data)
            case .failure(_):
                print("API get news error")
                completion(false, nil)
            default:
                completion(false, nil)
            }
        }.resume()
    }

}
