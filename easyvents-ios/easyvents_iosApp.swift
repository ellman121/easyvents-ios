//
//  easyvents_iosApp.swift
//  easyvents-ios
//
//  Created by Elliott Rarden on 23.01.23.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

extension UIApplication {
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

@main
struct easyvents_iosApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var isLoggedIn = false
    
    init() {
        FirebaseApp.configure()
        isLoggedIn = Auth.auth().currentUser != nil
    }
    
    var body: some Scene {
        WindowGroup {
//            if (isLoggedIn) {
//                EventsList()
//                    .onAppear {
//                        Auth.auth().addStateDidChangeListener { auth, _ in
//                            if auth.currentUser == nil {
//                                isLoggedIn = false
//                            }
//                        }
//                    }
//            } else {
                LoginScreen()
                    .onOpenURL { url in
                        GIDSignIn.sharedInstance.handle(url)
                    }
                    .onAppear {
                        Auth.auth().addStateDidChangeListener { auth, _ in
                            if auth.currentUser != nil {
                                isLoggedIn = true
                            }
                        }
                    }
//            }
        }
    }
}
