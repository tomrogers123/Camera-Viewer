import Cocoa
import AVFoundation

class MainViewController: NSViewController {
  
  // MARK: Internal API
  
  @IBOutlet var avaliableCamerasPopupButton: NSPopUpButton!
  @IBOutlet weak var viewContainingVideo: NSView!
  private let avaliableCameras = AVCaptureDevice.devices(for: .video)
  private let cameraSession = AVCaptureSession()
  private let output = AVCaptureStillImageOutput()
  private var selectedDevice: AVCaptureDevice!
  
  // MARK: Update UI

  private func addDevicestoList() {
    for device in avaliableCameras {
      avaliableCamerasPopupButton.addItem(withTitle: device.localizedName)
    }
  }
  
  // MARK: Overall Session Configuration
  
  private func prepareSessionAndShowPreview() {
    for device in avaliableCameras {
      if device.localizedName == avaliableCamerasPopupButton.selectedItem?.title {
        selectedDevice = device
      }
    }
    
    do {
      try cameraSession.addInput(AVCaptureDeviceInput(device: selectedDevice))
    } catch let error {
      print(error.localizedDescription)
    }
    
    let preview = AVCaptureVideoPreviewLayer(session: cameraSession)
    preview.videoGravity = .resizeAspectFill
    
    viewContainingVideo.layer = preview
    
    
    if cameraSession.canSetSessionPreset(.vga640x480) {
      cameraSession.sessionPreset = .vga640x480
    }
    
    cameraSession.addOutput(output)
    cameraSession.startRunning()
  }
  
  // MARK: Handle Saving Images
  
  private func captureImageAndSave() {
    let connection = output.connections.last!
    output.captureStillImageAsynchronously(from: connection) { (data, problem) in
      
      if problem == nil {
        let jpegData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(data!)
        let path = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop").appendingPathComponent("image").appendingPathExtension("jpg")
        do {
          try jpegData?.write(to: path)
        } catch let errorSaving {
          print(errorSaving)
        }
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.addDevicestoList()
    self.prepareSessionAndShowPreview()
  }
  
  @IBAction func captureImageOnClick(sender: NSButton) {
    captureImageAndSave()
  }
  
}
