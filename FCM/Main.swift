 /*
 main.swift

 Copyright (C) 2023, 2024 SparkleChan and SeanIsTethered
 Copyright (C) 2024 fridakitten

 This file is part of FridaCodeManager.

 FridaCodeManager is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 FridaCodeManager is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with FridaCodeManager. If not, see <https://www.gnu.org/licenses/>.

 ______    _     _         _____        __ _                           ______                    _       _   _
 |  ___|  (_)   | |       /  ___|      / _| |                          |  ___|                  | |     | | (_)
 | |_ _ __ _  __| | __ _  \ `--.  ___ | |_| |___      ____ _ _ __ ___  | |_ ___  _   _ _ __   __| | __ _| |_ _  ___  _ __
 |  _| '__| |/ _` |/ _` |  `--. \/ _ \|  _| __\ \ /\ / / _` | '__/ _ \ |  _/ _ \| | | | '_ \ / _` |/ _` | __| |/ _ \| '_ \
 | | | |  | | (_| | (_| | /\__/ / (_) | | | |_ \ V  V / (_| | | |  __/ | || (_) | |_| | | | | (_| | (_| | |_| | (_) | | | |
 \_| |_|  |_|\__,_|\__,_| \____/ \___/|_|  \__| \_/\_/ \__,_|_|  \___| \_| \___/ \__,_|_| |_|\__,_|\__,_|\__|_|\___/|_| |_|
 Founded by. Sean Boleslawski, Benjamin Hornbeck and Lucienne Salim in 2023
 */

import SwiftUI

@main
struct MyApp: App {
    init() {
        UIInit(type: 0)

        if !UserDefaults.standard.bool(forKey: "UPDFIX_001") {
            setTheme(0)
            storeTheme()
            UserDefaults.standard.set(true, forKey: "UPDFIX_001")
        }

        if !UserDefaults.standard.bool(forKey: "UPDFIX_002") {
            UserDefaults.standard.set(0, forKey: "tabmode")
            UserDefaults.standard.set(4, forKey: "tabspacing")
            UserDefaults.standard.set(true, forKey: "UPDFIX_002")
        }

        if !UserDefaults.standard.bool(forKey: "UPDFIX_003") {
            UserDefaults.standard.set(true, forKey: "CEAutocomplete")
            UserDefaults.standard.set(true, forKey: "UPDFIX_003")
        }

        // 🔧 إنشاء مجلد التطبيق في Files
        createAppDirectory()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

/// 🔧 دالة لإنشاء مجلد التطبيق والمجلدات الفرعية
func createAppDirectory() {
    let fileManager = FileManager.default
    if let root = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
        let base = root.appendingPathComponent("FridaCodeManager")
        let subfolders = ["Projects", "SDK", "Libraries"]
        do {
            if !fileManager.fileExists(atPath: base.path) {
                try fileManager.createDirectory(at: base, withIntermediateDirectories: true)
            }
            for folder in subfolders {
                let path = base.appendingPathComponent(folder)
                if !fileManager.fileExists(atPath: path.path) {
                    try fileManager.createDirectory(at: path, withIntermediateDirectories: true)
                }
            }
        } catch {
            print("❌ خطأ أثناء إنشاء مجلد التطبيق: \(error)")
        }
    }
}