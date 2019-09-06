import Foundation
import MultipeerConnectivity
import UIKit
import ARKit

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
    private var doneNetworkingButton: UIButton!
    private var sceneView: ARSCNView!
    private var isNetworkingViewEnabled: Bool! = false
    private var isGamePlacementViewEnabled: Bool! = false
    private var isNameViewEnabled: Bool! = false
    private var isGameViewEnabled: Bool! = false
    private var isResultsViewEnabled: Bool! = false
    
    
    public func setIsNetworkingViewEnabled(_ _isNetworkingViewEnabled: Bool) {
        isNetworkingViewEnabled = _isNetworkingViewEnabled
    }
    
    public func setIsGamePlacementViewEnabled(_ _isGamePlacementViewEnabled: Bool) {
        isGamePlacementViewEnabled = _isGamePlacementViewEnabled
    }
    
    public func setIsNameViewEnabled(_ _isNameViewEnabled: Bool) {
        isNameViewEnabled = _isNameViewEnabled
    }
    
    public func setIsGameViewEnabled(_ _isGameViewEnabled: Bool) {
        isGameViewEnabled = _isGameViewEnabled
    }
    
    public func setIsResultsViewEnabled(_ _isResultsViewEnabled: Bool) {
        isResultsViewEnabled = _isResultsViewEnabled
    }
    
    public func setSceneView(_ _sceneView: inout ARSCNView) {
        sceneView = _sceneView
    }
    
    public func setDoneNetworkingButton(_ _doneNetworkingButton: UIButton) {
        doneNetworkingButton = _doneNetworkingButton
    }
    
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
    
    func sendToAllPeers(_ data: Data) {
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("error sending data to peers: \(error.localizedDescription)")
        }
    }
    
    var connectedPeers: [MCPeerID] {
        return session.connectedPeers
    }
    
    public func sendMessage() {
        let messageToSend = "\(myPeerId.displayName): Hello \(NSDate())"
        let message = messageToSend.data(using: String.Encoding.utf8, allowLossyConversion: false)
        do {
            try session.send(message!, toPeers: session.connectedPeers, with: .unreliable)
                log = log + messageToSend + "\n" }
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
            doneNetworkingButton.isEnabled = true
            isNetReady = true
        case .connecting:
            log = log + "Connecting: \(peerID.displayName)" + "\n"
            debugPrint("Connecting: \(peerID.displayName)")
        case .notConnected:
            log = log + "Not Connected: \(peerID.displayName)" + "\n"
            debugPrint("Not Connected: \(peerID.displayName)")
            isNetReady = false
        @unknown default:
            log = log + "fatal error" + "\n"
            debugPrint("fatal error")
        }
        logView.text = log
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data.debugDescription)")
        
        if(isNetworkingViewEnabled) {
            DispatchQueue.main.async { [unowned self] in
                // send message
                let message = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)! as String
                self.log = self.log + message + "\n"
                self.logView.text = self.log
            }
        } else if(isGamePlacementViewEnabled) {
            do {
                if let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data) { // If we received a ARWorldMap
                    debugPrint("1001: " + worldMap.debugDescription)
                    // Run the session with the received world map.
                    let configuration = ARWorldTrackingConfiguration()
                    configuration.planeDetection = .horizontal
                    configuration.initialWorldMap = worldMap
                    sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
                    debugPrint("1001: " + worldMap.debugDescription)
                }
            } catch {
                print("can't decode data received from \(peerID)")
            }
        } else if(isNameViewEnabled) {
            
        } else if(isGameViewEnabled) {
            
        } else if(isResultsViewEnabled) {
            
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
