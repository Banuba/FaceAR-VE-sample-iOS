# BanubaTokenStorageSDK

1)  Copy BanubaTokenStorageSDK.xcframework into Frameworks dir: Your project/Frameworks/
2)  Navigate to your target’s General tab, and in the “Frameworks, Libraries, and Embedded Content” section, check "Embed & Sign in 
    for BanubaTokenStorageSDK.xcframework
3)  For work via Firebase

    if Firebase is not installed:
     if you have Podfile in your project:
     1) paste pod 'Firebase/Database' 
     2) save changes
     3) open terminal and in your project directory run pod install
     4) open AppDelegate.swift in your project, add import Firebase in header and FirebaseApp.configure() in didFinishLaunchingWithOptions method
    
    if you have not Podfile:
    1) open terminal and in your project directory run pod init
    2) run open Podile
    3) add pod 'Firebase/Database'
    4) run pod install
    5) Open the project in xCode .xcworkspace file.
    
    Further or If Firebase is installed:
    1)  add  import BanubaTokenStorageSDK in header of your swift file
    2) set value for FaceArTokenProvider.targetUrl (url of your Firebase database)
    3) set value for FaceArTokenProvider.tokenSnapshot (name of snapshot from your Firebase database) 
    4)  add in your code a line FaceArTokenProvider.getToken()

4)  For work via Info.plist
     1) Open Info.plist in your project
     2) On the top, press plus
     3) Add String key named "VideoEditorToken"
     4) In the right from key input your token value.
