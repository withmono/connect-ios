//
//  Mono.swift
//
//  Created by Tristan Tsvetanov on 02021-06-02.
//

import Foundation
import UIKit

public class Mono {

    init(){ }
    
    public static func create(configuration: MonoConfiguration) -> UIViewController {
        
        if(configuration.reauthCode != nil){
            #error("You cannot pass a reauthCode: String to the default create function, use Mono.reauthorise() instead.")
        }

        let widget = MonoWidget(configuration: configuration)

        return widget

    }
    
    public static func reauthorise(configuration: MonoConfiguration) -> UIViewController {
        
        if(configuration.reauthCode == nil){
            #error("Reauthorisation requires you to pass a reauthCode: String to the configuration object.")
        }

        let widget = MonoWidget(configuration: configuration)

        return widget

    }

}
