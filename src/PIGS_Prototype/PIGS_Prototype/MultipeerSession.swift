import Foundation
import MultipeerConnectivity

protocol MultipeerSessionServiceDelegate {
    
    func connectedDevicesChanged(manager : MultipeerSession, connectedDevices: [String])
    func colorChanged(manager : MultipeerSession, colorString: String)
    
}

class MultipeerSession : NSObject {
    
    // Service type must be a unique string, at most 15 characters long
    // and can contain only ASCII lowercase letters, numbers and hyphens.
    private let MultipeerSessionServiceType = "pigs"
    
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    private var log: String = ""
    private var isNetReady: Bool = false
    private var logView: UITextView!
    
    public func getMcAdvertiserAssistant() -> MCAdvertiserAssistant {
        return mcAdvertiserAssistant
    }
    
    public func setMcAdvertiserAssistant(_ a: MCAdvertiserAssistant) {
        mcAdvertiserAssistant = a
    }
    
    public func isNetworkingReady() -> Bool {
        return isNetReady
    }
    
    public func getLog() -> String {
        return log
    }
    
    public func setLogView(_ _logView: UITextView) {
        logView = _logView
    }
    
    var delegate : MultipeerSessionServiceDelegate?
    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    override init() {
        super.init()
        
    }
    
    deinit {
        
    }
    
    public func sendMessage() {
        let messageToSend = "\(myPeerId.displayName): Hello \(NSDate())"
        let message = messageToSend.data(using: String.Encoding.utf8, allowLossyConversion: false)
        do {
            try session.send(message!, toPeers: session.connectedPeers, with: .unreliable)
                log = log + messageToSend + "\n"        }
        catch {
            log = log + "Error sending message" + "\n"
            debugPrint("Error sending message")
        }
        
        logView.text = log
    }
}

extension MultipeerSession : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session)
    }
    
}

extension MultipeerSession : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.rawValue)")
        self.delegate?.connectedDevicesChanged(manager: self, connectedDevices:
            session.connectedPeers.map{$0.displayName})
        
        switch state {
        case .connected:
            log = log + "Connected: \(peerID.displayName)" + "\n"
            debugPrint("Connected: \(peerID.displayName)")
            isNetReady = true
        case .connecting:
            log = log + "Connecting: \(peerID.displayName)" + "\n"
            debugPrint("Connecting: \(peerID.displayName)")
        case .notConnected:
            log = log + "Not Connected: \(peerID.displayName)" + "\n"
            debugPrint("Not Connected: \(peerID.displayName)")
        @unknown default:
            log = log + "fatal error" + "\n"
            debugPrint("fatal error")
        }
        logView.text = log
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        
        DispatchQueue.main.async { [unowned self] in
            // send message
            let message = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)! as String
            self.log = self.log + message + "\n"
            self.logView.text = self.log
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
    
}
