//
//  InstallSettings.swift
//  PlayCover
//
//  Created by TheMoonThatRises on 10/9/22.
//

import SwiftUI

class InstallPreferences: NSObject, ObservableObject {
    static var shared = InstallPreferences()

    @objc @AppStorage("AlwaysInstallPlayTools") var alwaysInstallPlayTools = true

    @AppStorage("DefaultAppType") var defaultAppType: LSApplicationCategoryType = .none
    @AppStorage("PlayToolsSettings") var playToolsSettings = "preferences.toggle.showInstallPopup"
    @AppStorage("ShowInstallPopup") var showInstallPopup = false
}
var playToolsSettingsList = [
    NSLocalizedString("preferences.toggle.showInstallPopup", comment: ""),
    NSLocalizedString("button.Yes", comment: ""),
    NSLocalizedString("button.No", comment: "")]
struct InstallSettings: View {
    public static var shared = InstallSettings()

    @ObservedObject var installPreferences = InstallPreferences.shared

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("settings.applicationCategoryType")
                Spacer()
                Picker("", selection: installPreferences.$defaultAppType) {
                    ForEach(LSApplicationCategoryType.allCases, id: \.rawValue) { value in
                        Text(value.localizedName)
                            .tag(value)
                    }
                }
                .frame(width: 225)
            }
            Spacer()
                .frame(height: 20)
            HStack {
                Text("settings.menu.installPlayTools")
                Spacer()

                Picker("", selection: installPreferences.$playToolsSettings) {
                    ForEach(playToolsSettingsList, id: \.self) { value in
                        Text(value)
                    }
                }
                .frame(width: 225)
            }.onChange(of: installPreferences.playToolsSettings) { setting in
                switch setting {
                case "Ask":
                    installPreferences.showInstallPopup = true
                    installPreferences.alwaysInstallPlayTools = false
                case "Yes":
                    installPreferences.showInstallPopup = false
                    installPreferences.alwaysInstallPlayTools = true
                case "No":
                    installPreferences.showInstallPopup = false
                    installPreferences.alwaysInstallPlayTools = false
                default:
                    installPreferences.showInstallPopup = true
                    installPreferences.alwaysInstallPlayTools = false
                }
            }
        }
        .padding(20)
        .frame(width: 400, height: 200)
    }
}
