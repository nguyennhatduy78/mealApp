//
//  SceneDelegate.swift
//  firstApp
//
//  Created by ChinhPV on 3/3/21.
//  Copyright © 2021 ChinhPV. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let loginPersist : LoginPersist = LoginPersist()
    let apis : fetchAPIs = fetchAPIs()
    let group : DispatchGroup  = DispatchGroup()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let winScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: winScene)
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let result = checkLoginStatus()
        let loginView = storyboard.instantiateViewController(identifier: "LoginView") as? LoginViewController
        if result.status {
            loginView?.username = result.username ?? ""
            loginView?.password = result.password ?? ""
            
        }
        window?.rootViewController = loginView
        window?.makeKeyAndVisible()
        
    }

    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    //Private
    private func checkLoginStatus() -> (status: Bool, username: String?, password: String?) {
        let loginStatus = self.loginPersist.getLoginInfo(forUserID: "loginInfo")
        let username = loginStatus.username
        let password = loginStatus.password
        if username == nil {
            return (false, nil, nil)
        }
        return (true, username, password)
    }

}

