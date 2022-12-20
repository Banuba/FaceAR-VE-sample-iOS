//
//  ViewController.swift
//  FaceAR-VE-Sample
//
//  Created by Gleb Markin on 2/9/21.
//

import UIKit
import BanubaSdk
import VEExportSDK
import BanubaVideoEditorSDK

private struct Defaults {
  static let effectName: String = "AsaiLines"
}

class FaceARViewController: UIViewController {
  
  // MARK: - Common Outlets
  @IBOutlet weak var playerViewContainer: UIView!
  
  // MARK: - Face AR Properties
  private var sdkManager: BanubaSdkManager? = BanubaSdkManager()
  private let config = EffectPlayerConfiguration(renderMode: .video)
  
  private var effectPlayerView: EffectPlayerView?
  
  //MARK: - Video Editor Properties
  private var videoEditorSDK: BanubaVideoEditor?
  private lazy var activityView: FullscreenActivityView = loadActivity()
  
  //MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupEffectPlayerView()
    sdkManager?.setup(configuration: config)
    setUpRenderTarget()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    sdkManager?.input.startCamera()
    sdkManager?.startEffectPlayer()
  }
}

// MARK: - IBActions
extension FaceARViewController {
  @IBAction func videoEditorButtonAction(_ sender: Any) {
    presentVideoEditorSDK()
  }
  
  @IBAction func applyEffectAction(_ sender: UIButton) {
    _ = sdkManager?.loadEffect(Defaults.effectName, synchronous: true)
  }
}

// MARK: - Video Editor Helpers
extension FaceARViewController {
  private func presentVideoEditorSDK() {
    destroyEffectPlayer { [weak self] in
      guard let self = self else { return }
      
      videoEditorSDK = BanubaVideoEditor(
        token: AppDelegate.licenseToken,
        configuration: VideoEditorConfig(),
        externalViewControllerFactory: nil
      )
      videoEditorSDK?.delegate = self
      
      let launchConfig = VideoEditorLaunchConfig(
        entryPoint: .camera,
        hostController: self,
        animated: true
      )
      videoEditorSDK?.presentVideoEditor(
        withLaunchConfiguration: launchConfig,
        completion: nil
      )
    }
  }
  
  private func exportVideo() {
    let manager = FileManager.default
    let fileURL = manager.temporaryDirectory.appendingPathComponent("tmp1.mov")
    if manager.fileExists(atPath: fileURL.path) {
      try? manager.removeItem(at: fileURL)
    }
    
    let exportVideoConfigurations: [ExportVideoConfiguration] = [
      ExportVideoConfiguration(
        fileURL: fileURL,
        quality: .auto,
        useHEVCCodecIfPossible: true,
        watermarkConfiguration: nil
      )
    ]
    
    let exportConfiguration = ExportConfiguration(
      videoConfigurations: exportVideoConfigurations,
      isCoverEnabled: true,
      gifSettings: nil
    )
    
    startActivity()
    videoEditorSDK?.export(
      using: exportConfiguration,
      exportProgress: { progress in debugPrint("export progress \(progress)") },
      completion: { [weak self] success, error, exportCoverImages in
        DispatchQueue.main.async {
          self?.stopActivity()
          if success {
            self?.shareResultVideo(urls: [fileURL])
          } else {
            self?.videoEditorSDK = nil
            self?.reloadSdkManager()
          }
        }
      }
    )
  }
  
  func shareResultVideo(urls: [URL]) {
    let controller = UIActivityViewController(
      activityItems: urls,
      applicationActivities: nil
    )
      
    controller.completionWithItemsHandler = { [weak self] _, _, _, _ in
      self?.videoEditorSDK = nil
      self?.reloadSdkManager()
    }
    
    present(controller, animated: true) {
      self.videoEditorSDK?.clearSessionData()
    }
  }
}

// MARK: - Video Editor Activity indicator helper
extension FaceARViewController {
  func startActivity() {
    setActivity(
      visible: true,
      text: "Exporting..."
    )
  }
  
  func stopActivity() {
    setActivity(visible: false)
  }
  
  func loadActivity() -> FullscreenActivityView {
    let activity = FullscreenActivityView.loadFromNib()
    activity.configuration = FullScreenActivityConfiguration.config
    activity.frame = view.bounds
    return activity
  }
  
  func setActivity(
    visible: Bool,
    text: String? = nil
  ) {
    if visible {
      view.addSubview(activityView)
    }
    activityView.text = text
    UIView.animate(
      withDuration: 0.15,
      delay: .zero,
      options: [.curveEaseOut, .beginFromCurrentState],
      animations: { [weak self] in
        self?.activityView.applyVisibility(visible)
      },
      completion: { _ in
        if visible == false {
          self.activityView.removeFromSuperview()
        }
      }
    )
  }
}


// MARK: - Video Editor Delegate
extension FaceARViewController: BanubaVideoEditorDelegate {
  func videoEditorDidCancel(_ videoEditor: BanubaVideoEditor) {
    videoEditor.dismissVideoEditor(
      animated: true
    ) { [weak self] in
      self?.videoEditorSDK = nil
      self?.reloadSdkManager()
    }
  }
  
  func videoEditorDone(_ videoEditor: BanubaVideoEditor) {
    videoEditor.dismissVideoEditor(
      animated: true
    ) { [weak self] in
      self?.exportVideo()
    }
  }
}

// MARK: - Face AR Helpers
extension FaceARViewController {
  private func reloadSdkManager() {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) { [weak self] in
      guard let self = self else { return }
      BanubaSdkManager.initialize(
        resourcePath: [Bundle.main.bundlePath + "/effects"],
        clientTokenString: AppDelegate.licenseToken
      )
      
      self.sdkManager = BanubaSdkManager()
      self.sdkManager?.setup(configuration: self.config)
      self.setUpRenderTarget()
      self.sdkManager?.input.startCamera()
      self.sdkManager?.startEffectPlayer()
    }
  }
  
  private func setupEffectPlayerView() {
    let preview = EffectPlayerView(frame: playerViewContainer.frame)
    playerViewContainer.addSubview(preview)
    effectPlayerView = preview
  }
  
  private func setUpRenderTarget() {
    config.orientation = .deg90
    config.renderSize = CGSize(width: 720, height: 1280)
    if let effectLayer = self.effectPlayerView?.layer as? CAMetalLayer {
      sdkManager?.setRenderTarget(layer: effectLayer, playerConfiguration: nil)
      sdkManager?.startEffectPlayer()
    }
  }
  
  private func destroyEffectPlayer(completion: () -> Void) {
    defer { completion() }
    
    sdkManager?.destroyEffectPlayer()
    BanubaSdkManager.deinitialize()
    sdkManager = nil
  }
}
