 /*
 RootView.swift

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

// 🔧 ثابت يشير إلى جذر مجلد FridaCodeManager في Files > On My iPhone
let appBaseURL: URL = {
    let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let base = docs.appendingPathComponent("FridaCodeManager")
    return base
}()

struct RootView: View {
    @State private var project_list_id: UUID = UUID()
    @State private var projects: [Project] = []

    var body: some View {
        TabView {
            Home(hellnah: $project_list_id)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            ProjectView(hello: $project_list_id, Projects: $projects)
                .tabItem {
                    Label("Projects", systemImage: "folder")
                }
            Settings()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .accentColor(.primary)
        .onOpenURL { url in
            importProj(target: url.path)
            project_list_id = UUID()
        }
        .onChange(of: project_list_id) { _ in
            GetProjectsBind(Projects: $projects)
        }
        .onAppear {
            GetProjectsBind(Projects: $projects)
        }
    }
}

/// 🔧 دالة لقراءة قائمة المشاريع من المجلد الفرعي "Projects"
func GetProjectsBind(Projects: Binding<[Project]>) {
    DispatchQueue.global(qos: .background).async {
        do {
            let projectFolder = appBaseURL.appendingPathComponent("Projects")
            let fileManager = FileManager.default
            let items = try fileManager.contentsOfDirectory(atPath: projectFolder.path)

            var foundProjectNames = Set<String>()
            let currentProjects = Projects.wrappedValue

            for item in items {
                // تجاهل ملفات النظام أو الملفات الخاصة
                guard item != "Inbox",
                      item != "savedLayouts.json",
                      item != ".sdk",
                      item != ".cache",
                      item != "virtualFS.dat"
                else { continue }

                foundProjectNames.insert(item)

                // مسارات Info.plist و DontTouchMe.plist ضمن Resources
                let projectPath = projectFolder.appendingPathComponent(item)
                let infoPlistURL = projectPath
                    .appendingPathComponent("Resources")
                    .appendingPathComponent("Info.plist")
                let dontTouchMeURL = projectPath
                    .appendingPathComponent("Resources")
                    .appendingPathComponent("DontTouchMe.plist")

                // قيم افتراضية
                var bundleID  = "Corrupted"
                var version   = "Unknown"
                var executable = "Unknown"
                var macro     = "Release"
                var minOS     = "Unknown"
                var sdk       = "Unknown"
                var type      = "Applications"

                // قراءة Info.plist
                if let info = NSDictionary(contentsOf: infoPlistURL) {
                    if let bid = info["CFBundleIdentifier"]   as? String { bundleID   = bid }
                    if let ver = info["CFBundleVersion"]      as? String { version    = ver }
                    if let exe = info["CFBundleExecutable"]   as? String { executable = exe }
                    if let tg  = info["MinimumOSVersion"]     as? String { minOS      = tg  }
                }

                // قراءة DontTouchMe.plist
                if let info2 = NSDictionary(contentsOf: dontTouchMeURL) {
                    if let s = info2["SDK"]  as? String { sdk   = s }
                    if let t = info2["TYPE"] as? String { type  = t }
                    if let m = info2["CMacro"] as? String { macro = m }
                }

                let newProject = Project(
                    Name:        item,
                    BundleID:    bundleID,
                    Version:     version,
                    ProjectPath: projectPath.path,
                    Executable:  executable,
                    Macro:       macro,
                    SDK:         sdk,
                    TG:          minOS,
                    TYPE:        type
                )

                // تحديث القائمة في الواجهة إن تغيّر المشروع
                if let idx = currentProjects.firstIndex(where: { $0.Name == item }) {
                    if currentProjects[idx] != newProject {
                        usleep(500)
                        DispatchQueue.main.async {
                            withAnimation {
                                Projects.wrappedValue[idx] = newProject
                            }
                        }
                    }
                } else {
                    usleep(500)
                    DispatchQueue.main.async {
                        withAnimation {
                            Projects.wrappedValue.append(newProject)
                        }
                    }
                }
            }

            // حذف المشاريع التي أُزيلت من المجلد
            usleep(500)
            DispatchQueue.main.async {
                withAnimation {
                    Projects.wrappedValue.removeAll { proj in
                        !foundProjectNames.contains(proj.Name)
                    }
                }
            }

        } catch {
            print("❌ خطأ بقراءة المشاريع: \(error)")
        }
    }
}