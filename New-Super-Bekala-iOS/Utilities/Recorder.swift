
import Foundation
import AVFoundation

class Recorder{
    
    static let instance = Recorder()

    static let AVREC_SETTING = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 12000,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    static let REC_DIRECTORY_URL = "recDirectoryURL"
    
    var recordingSession: AVAudioSession!
    
    static func setupSession(allowed : @escaping (Bool)->Void) throws {
        
        self.instance.recordingSession = AVAudioSession.sharedInstance()
        
        try self.instance.recordingSession.setCategory(.playAndRecord, mode: .default)
        try self.instance.recordingSession.setActive(true)
        try self.instance.recordingSession.overrideOutputAudioPort(.speaker)
        self.instance.recordingSession.requestRecordPermission() { isAllowed in
            DispatchQueue.main.async {
                if isAllowed {
                    allowed(true)
                } else {
                    allowed(false)
                }
            }
        }
        
    }
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func getURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("order_voice.m4a")
    }
    
}
