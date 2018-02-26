import Cocoa
import AVFoundation

class MainViewController: NSViewController {
  
  // MARK: Internal API
  
  @IBOutlet var avaliableCamerasPopupButton: NSPopUpButton!
  @IBOutlet weak var viewContainingVideo: NSView!
  private let avaliableCameras = AVCaptureDevice.devices(for: .video)
  private var cameraSession = AVCaptureSession()
  private var selectedDevice: AVCaptureDevice!
  
  // MARK: Update UI

  private func addDevicestoList() {
    for device in avaliableCameras {
      avaliableCamerasPopupButton.addItem(withTitle: device.localizedName)
    }
  }
  
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
    
    viewContainingVideo.layer = AVCaptureVideoPreviewLayer(session: cameraSession)
    
    if cameraSession.canSetSessionPreset(.vga640x480) {
      cameraSession.sessionPreset = .vga640x480
    }
    
    cameraSession.startRunning()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.addDevicestoList()
    self.prepareSessionAndShowPreview()
  }
  
}
