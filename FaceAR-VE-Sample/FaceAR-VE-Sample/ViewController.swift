//
//  ViewController.swift
//  FaceAR-VE-Sample
//
//  Created by Gleb Markin on 2/9/21.
//

import UIKit
import BanubaSdk
import BanubaVideoEditorSDK
import BanubaUtilities
import VideoEditor
import VEExportSDK

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
    setUpRenderSize()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    sdkManager?.input.startCamera()
    sdkManager?.loadEffect("UnluckyWitch", synchronous: true)
    sdkManager?.startEffectPlayer()
  }
  
  deinit {
    sdkManager?.destroyEffectPlayer()
  }
}

//MARK:- IBActions
extension FaceARViewController {
  @IBAction func videoEditorButtonAction(_ sender: Any) {
    presentVideoEditorSDK()
  }
}

// MARK:- Video Editor Helpers
extension FaceARViewController {
  private func createVideoEditorSDK() {
    BanubaSdkManager.deinitialize()
    
    sdkManager?.destroyEffectPlayer()
    sdkManager = nil
    
    videoEditorSDK = BanubaVideoEditor(
      token: banubaClientToken,
      configuration: VideoEditorConfig(),
      externalViewControllerFactory: nil
    )
    videoEditorSDK?.delegate = self
  }
  
  private func presentVideoEditorSDK() {
    createVideoEditorSDK()
    
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
      
    controller.completionWithItemsHandler = { _, _, _, _ in
      self.videoEditorSDK = nil
      self.reloadSdkManager()
    }
    
    present(
      controller,
      animated: true
    ) {
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
      })
  }
}


//MARK:- Video Editor Delegate
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

//MARK: - Face AR Helpers
extension FaceARViewController {
  private func reloadSdkManager() {
    BanubaSdkManager.initialize(
      resourcePath: [Bundle.main.bundlePath + "/effects"],
      clientTokenString: banubaClientToken,
      logLevel: .info
    )
    
    sdkManager = BanubaSdkManager()
    sdkManager?.setup(configuration: config)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      self.setUpRenderSize()
      
      self.sdkManager?.input.startCamera()
      self.sdkManager?.loadEffect("UnluckyWitch", synchronous: true)
      self.sdkManager?.startEffectPlayer()
    }
  }
  
  private func setupEffectPlayerView() {
    let preview = EffectPlayerView(frame: playerViewContainer.frame)
    playerViewContainer.addSubview(preview)
    effectPlayerView = preview
  }
  
  private func setUpRenderTarget() {
    guard let effectView = self.effectPlayerView?.layer as? CAEAGLLayer else { return }
    sdkManager?.setRenderTarget(layer: effectView, playerConfiguration: nil)
    sdkManager?.startEffectPlayer()
  }
  
  private func setUpRenderSize() {
    switch UIApplication.shared.statusBarOrientation {
    case .portrait:
      config.orientation = .deg90
      config.renderSize = CGSize(width: 720, height: 1280)
      setUpRenderTarget()
    case .portraitUpsideDown:
      config.orientation = .deg270
      config.renderSize = CGSize(width: 720, height: 1280)
      setUpRenderTarget()
    case .landscapeLeft:
      config.orientation = .deg180
      config.renderSize = CGSize(width: 1280, height: 720)
      setUpRenderTarget()
    case .landscapeRight:
      config.orientation = .deg0
      config.renderSize = CGSize(width: 1280, height: 720)
      setUpRenderTarget()
    default:
      setUpRenderTarget()
    }
  }
}
