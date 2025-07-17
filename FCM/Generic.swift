import UIKit

// Basically the "bootup" of FridaCodeManager

// fatal error handling
func exitWithError(_ message: String) -> Never {
    fatalError(message)
}

// 🔧 جذر المجلد المخصص داخل Files > On My iPhone > FridaCodeManager
let appBaseURL: URL = {
    let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let base  = docs.appendingPathComponent("FridaCodeManager")
    return base
}()

// 🔧 المسار العام (Container) الآن هو نفس appBaseURL
let global_container: String = {
    let path = appBaseURL.path
    // نتأكد أن المجلد موجود
    if !FileManager.default.fileExists(atPath: path) {
        try? FileManager.default.createDirectory(at: appBaseURL, withIntermediateDirectories: true)
    }
    return path
}()

// 🔧 مجلد Documents ضمن الـ container
let global_documents: String = "\(global_container)/Documents"

// 🔧 مسار SDK ضمن الـ container
let global_sdkpath: String = "\(global_container)/.sdk"

// معلومات الإصدار والسجل (كما كانت)
let changelog: String = """
v2.0.alpha_5 "iPad + Code Editor Update"

App
-> optimized the overall code
-> added copy button to console
-> removing Wiki for now
-> disabled auto correction on project creation popup

Code Editor
-> removing highlighting cache
-> fixed backspace in space spacing mode
-> added auto curly-braces, braces and string completion.
"""

let global_version: String = "v2.0.alpha_5"

// compatibility checks
let isiOS16: Bool = ProcessInfo.processInfo.isOperatingSystemAtLeast(
    OperatingSystemVersion(majorVersion: 16, minorVersion: 0, patchVersion: 0)
)

let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad