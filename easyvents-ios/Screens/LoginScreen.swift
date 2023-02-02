//
//  LoginScreen.swift
//  easyvents-ios
//
//  Created by Elliott Rarden on 01.02.23.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift

func signInToFirebaseGoogle(userResult: GIDSignInResult?, error: Error?) {
    if error != nil || userResult == nil {
        print(error!)
        return
    }
    
    let credential = GoogleAuthProvider.credential(
        withIDToken: userResult!.user.idToken!.tokenString,
        accessToken: userResult!.user.accessToken.tokenString
    )
    Auth.auth().signIn(with: credential)
}

struct LoginScreen: View {
    var body: some View {
        GoogleSignInButton {
            guard let rvc = UIApplication.shared.keyWindow?.rootViewController,
                  let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.signIn(withPresenting: rvc, completion: signInToFirebaseGoogle)
        }.padding()
        
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
