//
//  ScalingMode.swift
//  TypographyKit
//
//  Created by Ross Butler on 7/1/19.
//

import Foundation

public enum ScalingMode: String {
    
    /// Uses `UIFontMetrics` to return a scaled `UIFont`.
    case fontMetrics = "uifontmetrics"
    
    // Returns a `UIFont` scaled with `UIFontMetrics` or scaled with stepping where `UIFontMetrics` unavailable.
    case fontMetricsWithSteppingFallback = "uifontmetrics-with-fallback"
    
    /// Point size is scaled with increasing `UIContentSizeCategory` using a step size * multiplier.
    case stepping = "stepping"
    
}
