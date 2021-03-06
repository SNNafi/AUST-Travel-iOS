//
//  View+Ex.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 17/9/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI
import UIKit
import Combine

let iphone12miniWidth: CGFloat =  375.0
let iphone12miniHeight: CGFloat =  812.0

/// `ScaledFont`
@available(iOS 13, macCatalyst 13, tvOS 13, watchOS 6, *)
struct ScaledFont: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    var name: String? = nil
    var size: CGFloat
    
    func body(content: Content) -> some View {
        let scaledSize = UIFontMetrics.default.scaledValue(for: size)
        return content.font(name == nil ? .system(size: scaledSize) : .custom(name!, size: scaledSize))
    }
}

@available(iOS 13, macCatalyst 13, tvOS 13, watchOS 6, *)
extension View {
    
    func scaledFont(name: String? = nil, size: CGFloat) -> some View {
        return self.modifier(ScaledFont(name: name, size: size))
    }
    
    func scaledFont(name: String? = nil, dsize: CGFloat) -> some View {
        return self.modifier(ScaledFont(name: name, size: dynamicFontSize(size: Float(dsize))))
    }
    
    
    func scaledFont(font: GenericFont.Font, size: CGFloat) -> some View {
        return self.modifier(ScaledFont(name: font.rawValue, size: size))
    }
    
    func scaledFont(font: GenericFont.Font, dsize: CGFloat) -> some View {
        return self.modifier(ScaledFont(name: font.rawValue, size: dynamicFontSize(size: Float(dsize))))
    }
    
    /// 812.0 - `iPhone 12 mini`
    func dynamicFontSize(size: Float) -> CGFloat {
        let scaleFactor = Float(UIScreen.main.bounds.height) / Float(iphone12miniHeight)
        let fontSize = CGFloat(size * scaleFactor)
        return fontSize
    }
}


extension View {
    /// A backwards compatible wrapper for iOS 14 `onChange`
    @ViewBuilder func valueChanged<T: Equatable>(value: T, onChange: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            self.onChange(of: value, perform: onChange)
        } else {
            self.onReceive(Just(value)) { (value) in
                onChange(value)
            }
        }
    }
}

extension View {
    /// Check for non notched devices
    func isSafeArea() -> Bool {
        let bottom = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? 0
        print("Bottom \(bottom)")
        return bottom > 0
    }
}


extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}


extension View {
    var dWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var dHeight: CGFloat {
        UIScreen.main.bounds.height
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(ABRoundedCorner(radius: radius, corners: corners))
    }
}

extension UIView {
    func asImage() -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        return UIGraphicsImageRenderer(size: self.layer.frame.size, format: format).image { context in
            self.drawHierarchy(in: self.layer.bounds, afterScreenUpdates: true)
            //layer.render(in: context.cgContext)

        }
    }
} 


extension View {
    func clickable(action: @escaping () -> ()) -> some View {
        return Button {
            action()
        } label: {
            self
        }
    }
}
