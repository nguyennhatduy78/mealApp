//
//  contants.swift
//  firstApp
//
//  Created by ChinhPV on 3/8/21.
//  Copyright © 2021 ChinhPV. All rights reserved.
//

import Foundation
struct HTTP_METHOD {
    static let GET = "GET"
    static let POST = "POST"
    static let PUT = "PUT"
    static let DELETE = "DELETE"
}
struct API {
    static let URL = "http://localhost:8080/api/v1"
//    static let URL = "http://localhost:3001"
}
struct DB {
    static let USERNAME = "nguyenduy2911"
    static let PASSWORD = "Nhatduy1998"
}
struct MEAL {
    static let GET = "/meal"
    static let CREATE = "/create-meal?user_id="
    static let UPDATE = "/update-meal"
    static let DELETE = "/delete-meal"
}
struct USER{
    static let GET = "/users"
    static let CREATE = "/create-user"
    static let UPDATE = "/update-user"
    static let COMPLETE_UPDATE = "/complete-update-user"
    static let DELETE = "/delete-user"
    static let LOGIN = "/user"
    static let VALIDATE = "/validate"
}
struct IMG {
    static let CREATE = "/img"
    static let GET = "/img"
    static let NAME = API.URL+"/img?filename="
}

