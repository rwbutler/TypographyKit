//
//  SwiftUIExample.swift
//  TypographyKit
//
//  Created by Ross Butler on 22/02/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//

import SwiftUI
import TypographyKit

@available(iOS 13.0.0, *)
struct SwiftUIView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("An example using TypographyKit with SwiftUI"
                .letterCase(style: .interactive))
                .typography(style: .interactive)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        }
    }
}

@available(iOS 13.0.0, *)
struct SwiftUIViewPreviews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
