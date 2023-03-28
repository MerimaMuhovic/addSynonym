//
//  AppViewModel.swift


import Foundation
import Bond
import ReactiveKit

class AppViewModel {
    let bag = DisposeBag()
    var error = Property<AppError?>(nil)
    init() {
        
    }
}
