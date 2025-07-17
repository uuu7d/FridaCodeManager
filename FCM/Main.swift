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

// المسار البديل الآمن داخل sandbox بدون جيلبريك
let jbroot: String = {
    let appName = "FridaCodeManager"
    let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let customRoot = documents.deletingLastPathComponent().appendingPathComponent(appName)

    // إنشاء مجلد باسم التطبيق داخل "On My iPhone"
    if !FileManager.default.fileExists(atPath: customRoot.path) {
        try? FileManager.default.createDirectory(at: customRoot, withIntermediateDirectories: true, attributes: nil)
    }

    return customRoot.path
}()

let global_documents: String = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
let global_sdkpath: String = "\(global_documents)/../.sdk"

@main
struct MyApp: App {
    @State var hello: UUID = UUID()
    @AppStorage("ui_update152") var upd: Bool = false

    init() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = UIColor.systemBackground
        let titleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationBarAppearance.titleTextAttributes = titleAttributes
        let buttonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBarAppearance.buttonAppearance.normal.titleTextAttributes = buttonAttributes
        let backItemAppearance = UIBarButtonItemAppearance()
        backItemAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor.label]
        navigationBarAppearance.backButtonAppearance = backItemAppearance
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            ContentView(hello: $hello)
                .onOpenURL { url in
                    importProj(target: url.path)
                    hello = UUID()
                }
                .onAppear {
                    if !upd {
                        resetlayout()
                        upd = true
                    }
                }
        }
    }
}