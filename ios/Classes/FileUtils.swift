protocol SmileIDFileUtilsProtocol {
  var fileManager: FileManager { get set }
  func getFilePath(fileName: String) -> String
}

extension SmileIDFileUtilsProtocol {
  func getSmileIDDirectory() -> String? {
    guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
      print("Unable to access documents directory")
      return nil
    }
    
    let smileIDDirectory = documentsDirectory.appendingPathComponent("SmileID")
    return smileIDDirectory.absoluteURL.absoluteString
  }
  
  func getFilePath(fileName: String) -> String {
    guard let smileIDDirectory = getSmileIDDirectory() else {
      return ""
    }
    
    return (smileIDDirectory as NSString).appendingPathComponent(fileName)
  }
}
