import SwiftUI

class FloatingPanel<Content: View>: NSPanel {
    @Binding var isPresented: Bool
    
    init(view: () -> Content, contentRect: NSRect, backing: NSWindow.BackingStoreType = .buffered, defer flag: Bool = false, isPresented: Binding<Bool>) {
        self._isPresented = isPresented
     
        super.init(contentRect: contentRect, styleMask: [.nonactivatingPanel, .titled, .resizable, .closable, .fullSizeContentView], backing: backing, defer: flag)
     
        isFloatingPanel = true
        level = .floating
     
        collectionBehavior.insert(.fullScreenAuxiliary)
     
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
     
        isMovableByWindowBackground = true
     
        hidesOnDeactivate = true
     
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true
     
        animationBehavior = .utilityWindow
     
        contentView = NSHostingView(rootView: view()
            .ignoresSafeArea()
            .environment(\.floatingPanel, self))
    }
    
    override func resignMain() {
        super.resignMain()
        close()
    }
     
    override func close() {
        super.close()
        isPresented = false
    }
     
    override var canBecomeKey: Bool {
        return true
    }
     
    override var canBecomeMain: Bool {
        return true
    }
}

private struct FloatingPanelKey: EnvironmentKey {
    static let defaultValue: NSPanel? = nil
}
 
extension EnvironmentValues {
  var floatingPanel: NSPanel? {
    get { self[FloatingPanelKey.self] }
    set { self[FloatingPanelKey.self] = newValue }
  }
}

fileprivate struct FloatingPanelModifier<PanelContent: View>: ViewModifier {
    @Binding var isPresented: Bool
 
    var contentRect: CGRect = CGRect(x: 0, y: 0, width: 624, height: 512)
 
    @ViewBuilder let view: () -> PanelContent
 
    @State var panel: FloatingPanel<PanelContent>?
 
    func body(content: Content) -> some View {
        content
            .onAppear {
                panel = FloatingPanel(view: view, contentRect: contentRect, isPresented: $isPresented)
                panel?.center()
                if isPresented {
                    present()
                }
            }
            .onDisappear {
                panel?.close()
                panel = nil
            }
            .onChange(of: isPresented) { value in
                if value {
                    present()
                } else {
                    panel?.close()
                }
            }
    }
 
    func present() {
        panel?.orderFront(nil)
        panel?.makeKey()
    }
}

extension View {
    func floatingPanel<Content: View>(isPresented: Binding<Bool>, contentRect: CGRect = CGRect(x: 0, y: 0, width: 624, height: 512), @ViewBuilder content: @escaping () -> Content) -> some View {
        self.modifier(FloatingPanelModifier(isPresented: isPresented, contentRect: contentRect, view: content))
    }
}
