//
//  ProfileViewModel.swift
//  SuperheroKhalilov
//
//  Created by Эдип on 22.02.2022.
//

import Foundation
import UIKit

class ProfileViewModel {

    let rightBarButtonItemTitle = "Save"

    let addParametersButtonText = "Add options"
    
    let defaultCameraImage = "Camera"
    let headerNameTitle = "Name"
    let headerNameTitleText = "Name"
    let headerNamePlaceholder = "Enter Your Name"
    
    let footerSelectLabel = "Select an option to display on the main screen."
    
    let alertTitle = "Profile has been saved!"
    let alertImage = "CheckmarkAccessory"
    let alertTitleNumberOfLines: Int = 1
    let opacity: UIColor = .black.withAlphaComponent(0.65)
    let alertTimeInterval: Double = 2
    
    let profile = ProfileManager.sharedInstance.userProfile
    var profileName: String?
    
    var bodyParametersStorage = BodyParametersStorage()
    
    var bodyParameteresViewModel = [BodyParameterViewModel]()
    var parameterList: [BodyParameter] = []
    
    var selectedParameterViewModel = [BodyParameterViewModel]()
    
    init() {
        fetchParameters()
        check()
    }
    
    func fetchParameters() {
        profileName = profile?.name
        bodyParameteresViewModel = bodyParametersStorage.fetchProfileParametersViewModel()
        guard let parameters = profile?.parameters else { return }
        parameterList = Array(_immutableCocoaArray: parameters)
        
        if !parameterList.isEmpty {
            selectedParameterViewModel = parameterList.map({ parameters in
                createViewModel(with: parameters)
            })
        }
    }
    
    func createViewModel(with bodyParameter: BodyParameter) -> BodyParameterViewModel {
        let parameterViewModel = BodyParameterViewModel(model: bodyParameter)
        return parameterViewModel
    }
    
    func toggleIsSelected(at index: Int) {
        let selectedElement = bodyParameteresViewModel[index]
        
        if selectedElement.isSelected == false {
            selectedParameterViewModel.append(selectedElement)
            selectedElement.isSelected.toggle()
            
        } else if selectedElement.isSelected == true {
            if let deselect = selectedParameterViewModel.firstIndex(where: { $0.bodyPart == selectedElement.bodyPart }) {
                selectedParameterViewModel.remove(at: deselect)
                selectedElement.isSelected.toggle()
            }
        }
    }
    
    func remove(at index: Int) {
        selectedParameterViewModel.remove(at: index)
        let removedElement = bodyParameteresViewModel[index]
        removedElement.isSelected.toggle()
    }
    
    func check() {
        for viewModel in selectedParameterViewModel {
            if let model = bodyParameteresViewModel.first(where: { $0.bodyPart == viewModel.bodyPart }) {
                model.isSelected = true
            }
        }
    }
    
    func saveParameters() {
        var params: [BodyParameter] = []
        
        for viewModel in selectedParameterViewModel {
            if let model = bodyParametersStorage.parametersList.first(where: { $0.bodyPart == viewModel.bodyPart }) {
                model.bodyPart = viewModel.bodyPart
                model.isSelected = viewModel.isSelected
                model.value = viewModel.value
                model.changeValue = viewModel.changeValue
                model.isOn = viewModel.isOn
                
                params.append(model)
            }
        }
        profile?.parameters = NSOrderedSet(array: params)
        ProfileManager.sharedInstance.saveProfile()
    }
}
