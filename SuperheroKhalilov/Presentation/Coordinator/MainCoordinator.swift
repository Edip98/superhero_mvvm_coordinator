//
//  MainCoordinator.swift
//  SuperheroKhalilov
//
//  Created by Эдип on 19.02.2022.
//

import UIKit

class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.navigationBar.tintColor = .customYellow
        navigationController.navigationBar.barTintColor = .clear
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func start() {
        ProfileManager.sharedInstance.fetchProfile()
        
        if ProfileManager.sharedInstance.userProfile != nil {
            moveToHome()
        } else {
            let vc = StartViewController.instantiate()
            vc.coordinator = self
            navigationController.pushViewController(vc, animated: false)
        }
    }
    
    func moveToHome() {
        let vc = HomeViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
    
    func dismiss(animated: Bool) {
        navigationController.dismiss(animated: animated, completion: nil)
    }
}
