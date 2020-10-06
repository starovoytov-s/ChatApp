//
//  ProfileViewModel.swift
//  ChatApp
//
//  Created by Stanislav Starovoytov on 06.10.2020.
//

import Foundation

enum ProfileViewModelType {
    case info, logout
}

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}
