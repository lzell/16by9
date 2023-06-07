#! /usr/bin/env swift
///
///
/// Creates a visual overlay to assist in creating 16:9 screen recordings.
/// Anything in the semi-transparent green overlay are outside of a 16:9 aspect ratio.
/// I use this to create 16:9 screen recordings on a Macbook Air, M1 2020.
///
/// Usage
/// -----
///
/// Save this program anywhere in your path, and make it executable.
///
/// For example, in Term:
///
///     cd /usr/local/bin
///     curl -O https://www.louzell.com/programs/16by9
///
/// Make it executable:
///
///     chmod +x 16by9
///
/// Run it:
///
///     16by9
///     :: Use ctrl+c to quit

import AppKit
import Dispatch

class ScreenMaskAppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        let window = NSWindow(contentRect: NSScreen.main!.frame,
                              styleMask: [.borderless],
                              backing: .buffered,
                              defer: true)
        window.contentView!.addSubview(createOverlayView())
        window.backgroundColor = .clear
        window.level = .floating
        window.ignoresMouseEvents = true
        window.orderFront(nil)
    }

    private var screenWidth: CGFloat {
        return NSScreen.main!.frame.width
    }

    private var screenHeight: CGFloat {
        return NSScreen.main!.frame.height
    }

    private var heightToPad: CGFloat {
        assert(screenWidth <= screenHeight * 16 / 9, "Expecting a monitor that is less wide than 16:9")
        return screenHeight - screenWidth * 9 / 16
    }

    private func createOverlayView() -> NSView {
        let view = NSView(frame: NSRect(x: 0, y: 0, width: screenWidth, height: heightToPad))
        view.wantsLayer = true
        view.layer!.backgroundColor = NSColor(red: 0, green: 1, blue: 0, alpha: 0.4).cgColor
        return view
    }
}

let monitorForSigInt = DispatchSource.makeSignalSource(signal: SIGINT, queue: .main)
monitorForSigInt.setEventHandler(handler: {
    exit(0)
})
monitorForSigInt.resume()

let appDelegate = ScreenMaskAppDelegate()
NSApplication.shared.delegate = appDelegate
NSApplication.shared.run()
