//
//  Mono.swift
//
//  Created by Tristan Tsvetanov on 02021-06-02.
//

import Foundation
import UIKit

public class Mono {

    public static let sharedInstance: Mono = {
        let instance = Mono()

        return instance
    }()

    init(){ }

    public func create(configuration: MonoConfiguration) -> UIViewController {

        let widget = MonoWidget(configuration: configuration)

        return widget

    }

}
