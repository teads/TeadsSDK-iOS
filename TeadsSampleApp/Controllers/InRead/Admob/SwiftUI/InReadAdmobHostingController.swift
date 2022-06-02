//
//  InReadAdmobHostingController.swift
//  TeadsSampleApp
//
//  Created by Thibaud Saint-Etienne on 02/06/2022.
//  Copyright © 2022 Teads. All rights reserved.
//

import Foundation
import SwiftUI

@available(iOS 14.0, *)
class InReadAdmobHostingController: UIHostingController<InReadAdmobSwiftUIView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: InReadAdmobSwiftUIView())
    }
}
