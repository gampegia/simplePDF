import SwiftUI
import AppKit

struct PDFThemePalette: Codable, Equatable, Identifiable {
    let id: String
    let name: String
    let accentHex: String
    let accentStrongHex: String
    let backgroundHex: String
    let panelHex: String
    let panelSoftHex: String
    let dividerHex: String
    let selectionFillHex: String
    let textHex: String
    let secondaryTextHex: String
    
    static let simpleLight = PDFThemePalette(
        id: "simple-light",
        name: "Simple Light",
        accentHex: "#D73535",
        accentStrongHex: "#B91F2A",
        backgroundHex: "#F5F5F7",
        panelHex: "#FFFFFF",
        panelSoftHex: "#F0F1F4",
        dividerHex: "#D7D8DE",
        selectionFillHex: "#FCEAEA",
        textHex: "#1D1D1F",
        secondaryTextHex: "#5E6066"
    )
}

enum SimplePDFDesign {
    static let palette = PDFThemePalette.simpleLight
    
    enum Space {
        static let xxs: CGFloat = 3
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
    }
    
    enum Radius {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 6
        static let md: CGFloat = 8
        static let lg: CGFloat = 12
        static let xl: CGFloat = 16
    }
    
    enum Stroke {
        static let hairline: CGFloat = 1
        static let selected: CGFloat = 2
    }
    
    enum Typography {
        static func headline() -> Font {
            .system(size: 22, weight: .bold, design: .default)
        }
        
        static func title() -> Font {
            .system(size: 15, weight: .semibold, design: .default)
        }
        
        static func body() -> Font {
            .system(size: 13, weight: .regular, design: .default)
        }
        
        static func label() -> Font {
            .system(size: 11, weight: .semibold, design: .default)
        }
        
        static func monoLabel() -> Font {
            .system(size: 11, weight: .medium, design: .monospaced)
        }
    }
    
    enum ColorToken {
        static var accent: Color { Color(hex: palette.accentHex) }
        static var accentStrong: Color { Color(hex: palette.accentStrongHex) }
        static var background: Color { Color(hex: palette.backgroundHex) }
        static var panel: Color { Color(hex: palette.panelHex) }
        static var panelSoft: Color { Color(hex: palette.panelSoftHex) }
        static var divider: Color { Color(hex: palette.dividerHex) }
        static var selectionFill: Color { Color(hex: palette.selectionFillHex) }
        static var text: Color { Color(hex: palette.textHex) }
        static var secondaryText: Color { Color(hex: palette.secondaryTextHex) }
        
        static var macWindow: Color { Color(NSColor.windowBackgroundColor) }
        static var pdfBackground: Color { Color(NSColor.underPageBackgroundColor) }
    }
    
    enum Shadow {
        static var popover: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
            (Color.black.opacity(0.18), 24, 0, 8)
        }
        
        static var thumbnail: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
            (Color.black.opacity(0.12), 6, 0, 2)
        }
    }
}

struct SimplePanelModifier: ViewModifier {
    let padding: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(SimplePDFDesign.ColorToken.panel)
            .clipShape(RoundedRectangle(cornerRadius: SimplePDFDesign.Radius.md, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: SimplePDFDesign.Radius.md, style: .continuous)
                    .stroke(SimplePDFDesign.ColorToken.divider.opacity(0.72), lineWidth: SimplePDFDesign.Stroke.hairline)
            )
    }
}

struct SimpleOverlayModifier: ViewModifier {
    let radius: CGFloat
    
    func body(content: Content) -> some View {
        let shadow = SimplePDFDesign.Shadow.popover
        
        content
            .background(
                VisualEffectView(material: .hudWindow, blendingMode: .withinWindow)
                    .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            )
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(Color.white.opacity(0.18), lineWidth: SimplePDFDesign.Stroke.hairline)
            )
            .shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}

struct SimpleSearchFieldBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, SimplePDFDesign.Space.sm)
            .padding(.vertical, 6)
            .background(SimplePDFDesign.ColorToken.panel)
            .clipShape(RoundedRectangle(cornerRadius: SimplePDFDesign.Radius.sm, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: SimplePDFDesign.Radius.sm, style: .continuous)
                    .stroke(SimplePDFDesign.ColorToken.divider, lineWidth: SimplePDFDesign.Stroke.hairline)
            )
    }
}

extension View {
    func simplePanel(padding: CGFloat = SimplePDFDesign.Space.lg) -> some View {
        modifier(SimplePanelModifier(padding: padding))
    }
    
    func simpleOverlay(radius: CGFloat = SimplePDFDesign.Radius.lg) -> some View {
        modifier(SimpleOverlayModifier(radius: radius))
    }
    
    func simpleSearchFieldBackground() -> some View {
        modifier(SimpleSearchFieldBackground())
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    func toHex() -> String {
        guard let components = NSColor(self).usingColorSpace(.deviceRGB) else {
            return PDFThemePalette.simpleLight.accentHex
        }
        let r = Int(components.redComponent * 255)
        let g = Int(components.greenComponent * 255)
        let b = Int(components.blueComponent * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}
