import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    weak var mainWindow: NSWindow?

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            captureMainWindow()
            mainWindow?.makeKeyAndOrderFront(nil)
        }
        return true
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        captureMainWindow()
        if let window = mainWindow, !window.isVisible {
            window.makeKeyAndOrderFront(nil)
        }
    }

    private func captureMainWindow() {
        guard mainWindow == nil else { return }
        if let window = NSApp.windows.first(where: { $0.canBecomeMain }) {
            window.delegate = self
            mainWindow = window
        }
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        sender.orderOut(nil)
        return false
    }
}

@main
struct ScratchApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Window("Scratch", id: "main") {
            ContentView()
        }
        .defaultSize(width: 400, height: 320)
        .windowStyle(.hiddenTitleBar)
    }
}

struct ContentView: View {
    @AppStorage("scratchText") private var text: String = ""

    var body: some View {
        VStack(spacing: 0) {
            TextEditor(text: $text)
                .font(.system(.body))
                .scrollContentBackground(.hidden)
                .padding(8)

            HStack {
                Spacer()
                Button("Copy") {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(text, forType: .string)
                    NSApp.keyWindow?.orderOut(nil)
                }
                .keyboardShortcut(.return, modifiers: .command)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        .frame(minWidth: 260, minHeight: 160)
    }
}
