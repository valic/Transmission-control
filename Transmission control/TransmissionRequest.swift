//
//  TransmissionRequest.swift
//  transmission remote
//
//  Created by Mialin Valentin on 19.04.17.
//  Copyright © 2017 Mialin Valentin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class torrent {
    
    var id:Int
    var name:String
    var percentDone:Float
    var eta:Int
    var rateDownload:Int
    var rateUpload:Int
    var status:Int
    var peersGettingFromUs:Int
    var peersSendingToUs:Int
    var peersConnected:Int
    var totalSize:Int
    var sizeWhenDone:Int
    var error:Int
    var errorString:String
    var uploadRatio:Float
    var downloadedEver:Int
    var uploadedEver:Int
    var queuePosition:Int
    var trackerStats:[trackerStats]
    var recheckProgress:Float
  
    
    
    init(id:Int, name:String, percentDone:Float, eta:Int, rateDownload:Int, rateUpload:Int, status:Int, peersGettingFromUs:Int, peersSendingToUs:Int, peersConnected:Int, totalSize:Int, sizeWhenDone:Int, error:Int, errorString:String,  uploadRatio:Float, downloadedEver:Int, uploadedEver:Int, queuePosition:Int, trackerStats:[trackerStats], recheckProgress:Float) {
        self.id = id
        self.name = name
        self.percentDone = percentDone
        self.eta = eta
        self.rateDownload = rateDownload
        self.rateUpload = rateUpload
        self.status = status
        self.peersGettingFromUs = peersGettingFromUs
        self.peersSendingToUs = peersSendingToUs
        self.peersConnected = peersConnected
        self.totalSize = totalSize
        self.sizeWhenDone = sizeWhenDone
        self.error = error
        self.errorString = errorString
        self.uploadRatio = uploadRatio
        self.downloadedEver = downloadedEver
        self.uploadedEver = uploadedEver
        self.queuePosition = queuePosition
        self.trackerStats = trackerStats
        self.recheckProgress = recheckProgress
        
    }
}

class torrentInfo {
   
    var id:Int
    var name:String
    var status:Int
    var downloadedEver:Int
    var rateDownload:Int
    var trackerStats:[trackerStats]
    
    init(id:Int, name:String, status:Int, downloadedEver:Int, rateDownload:Int, trackerStats:[trackerStats]) {
        self.id = id
        self.name = name
        self.status = status
        self.downloadedEver = downloadedEver
        self.rateDownload = rateDownload
        self.trackerStats = trackerStats
    }
    
    
}


class torrentFiles{

    var id:Int
    var name:String
    var length:Int
    
    
    init(id:Int, name:String, length:Int) {
        self.id = id
        self.name = name
        self.length = length
    }
    
    convenience init() {
        self.init(id:Int(), name:String(), length:Int())
    }
}

class torrentFileStats{
    var bytesCompleted:Int
    var priority:Int
    var wanted:Bool
    
    init(bytesCompleted:Int, priority:Int, wanted:Bool) {

        self.bytesCompleted = bytesCompleted
        self.priority = priority
        self.wanted = wanted
        
    }
    convenience init() {
        self.init(bytesCompleted:Int(), priority:Int(), wanted:Bool())
    }
    
}

class torrentFilesAll {
    
    var idTorrent:Int
    var id:Int
    var name:String
    var length:Int
    var bytesCompleted:Int
    var priority:Int
    var wanted:Bool
    
    init(idTorrent:Int, torrentFiles:torrentFiles, torrentFileStats:torrentFileStats) {
        self.idTorrent = idTorrent
        self.id = torrentFiles.id
        self.name = torrentFiles.name
        self.length = torrentFiles.length
        self.bytesCompleted = torrentFileStats.bytesCompleted
        self.priority = torrentFileStats.priority
        self.wanted = torrentFileStats.wanted
    }
   
    convenience init() {
        self.init(idTorrent:Int(), torrentFiles:torrentFiles(), torrentFileStats:torrentFileStats())
    }
    
}
struct trackerStats {
    var seederCount:Int
    var leecherCount:Int
    
    init(seederCount:Int, leecherCount:Int) {
        self.seederCount = seederCount
        self.leecherCount = leecherCount
    }
}

class TransmissionRequest{
    
    var transmissionSessionId = ""
    var resultData:Data?
    var resultResponse:URLResponse?
    
    
    func requestAlamofire(json: [String: Any], completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        
        let loginString = String(format: "%@:%@", "admin", "hause")
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: "http://192.168.64.100:9091/transmission/rpc/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        // insert json data to the request
        request.httpBody = jsonData
        request.setValue(transmissionSessionId, forHTTPHeaderField: "X-Transmission-Session-Id")
        request.timeoutInterval = 3
        
        
        Alamofire.request(request).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                
                completionHandler(value as AnyObject, nil)
                
            case .failure(let error):
                
                if response.response?.statusCode == 409 {
                    if let SessionId = response.response?.allHeaderFields["X-Transmission-Session-Id"] as? String {
                        
                        self.transmissionSessionId = SessionId
                        request.setValue(self.transmissionSessionId, forHTTPHeaderField: "X-Transmission-Session-Id")
                        
                        Alamofire.request(request).responseJSON { response in
                            switch response.result {
                            case .success(let value):
                                
                                completionHandler(value as AnyObject, nil)
                                
                            case .failure(let error):
                                completionHandler(nil, error as NSError)
                                print("Failure \(error)")
                            }
                        }
                    }
                }
                else{
                    completionHandler(nil, error as NSError)
                    print("Failure \(error)")
                }
                
            }
        }

    }
    func torrentGet(completion: @escaping  ([torrent]?, NSError?) -> ()) {
        
        var torrentArray = [torrent]()
        
        let jsonString: [String: Any] = [
            "arguments": [ "fields" :  ["id",
                                        "name",
                                        "percentDone",
                                        "eta",
                                        "rateDownload",
                                        "rateUpload",
                                        "queuePosition",
                                        "peersGettingFromUs",
                                        "peersSendingToUs",
                                        "peersConnected",
                                        "status",
                                        "totalSize",
                                        "sizeWhenDone",
                                        "error",
                                        "errorString",
                                        "uploadRatio",
                                        "downloadedEver",
                                        "uploadedEver",
                                        "queuePosition",
                                        "recheckProgress",
                                        "trackerStats"
                ]],
            "method": "torrent-get"
        ]
        
        requestAlamofire(json: jsonString) { responseObject, error in
            
            if let responseObject = responseObject {
                let json = JSON(responseObject)
                
                if json["result"].stringValue == "success" {
                    
                    
                    
                    for item in json["arguments"]["torrents"].arrayValue {
                        
                        var trackerStatsArray = [trackerStats]()
                        
                        for tracker in item["trackerStats"].arrayValue{
                            trackerStatsArray.append(trackerStats(seederCount: tracker["seederCount"].intValue,
                                                                  leecherCount: tracker["leecherCount"].intValue))
                        }
                        
                        torrentArray.append(torrent(id: item["id"].intValue,
                                                    name: item["name"].stringValue,
                                                    percentDone: item["percentDone"].floatValue,
                                                    eta: item["eta"].intValue,
                                                    rateDownload: item["rateDownload"].intValue,
                                                    rateUpload: item["rateUpload"].intValue,
                                                    status: item["status"].intValue,
                                                    peersGettingFromUs: item["peersGettingFromUs"].intValue,
                                                    peersSendingToUs: item["peersSendingToUs"].intValue,
                                                    peersConnected: item["peersConnected"].intValue,
                                                    totalSize: item["totalSize"].intValue,
                                                    sizeWhenDone: item["sizeWhenDone"].intValue,
                                                    error: item["error"].intValue,
                                                    errorString: item["errorString"].stringValue,
                                                    uploadRatio: item["uploadRatio"].floatValue,
                                                    downloadedEver: item["downloadedEver"].intValue,
                                                    uploadedEver: item["uploadedEver"].intValue,
                                                    queuePosition: item["queuePosition"].intValue,
                                                    trackerStats: trackerStatsArray,
                                                    recheckProgress: item["recheckProgress"].floatValue))
                    }
                }
            }
            completion(torrentArray, error)
            
        }
    }
    
    func getTorrentInfo(ids:Int,completion: @escaping  (torrentInfo) -> ()) {
        
        
        let jsonString: [String: Any] = [
            "arguments": [
                "fields" :  ["id", "name", "status", "downloadedEver", "rateDownload", "trackerStats"],
                "ids": [ids]
            ],
            "method": "torrent-get"
        ]
        
        requestAlamofire(json: jsonString) { responseObject, error in
            
           
            
            if let responseObject = responseObject {
                let json = JSON(responseObject)
                
                if json["result"].stringValue == "success" {
                    
                    for item in json["arguments"]["torrents"].arrayValue {
                        
                        var trackerStatsArray = [trackerStats]()
                        
                        for tracker in item["trackerStats"].arrayValue{
                            trackerStatsArray.append(trackerStats(seederCount: tracker["seederCount"].intValue,
                                                                  leecherCount: tracker["leecherCount"].intValue))
                        }
                        
                        completion(torrentInfo(id: item["id"].intValue,
                            name: item["name"].stringValue,
                            status: item["status"].intValue,
                            downloadedEver: item["downloadedEver"].intValue,
                            rateDownload: item["rateDownload"].intValue,
                            trackerStats: trackerStatsArray))

                    }
                }
            }           
        }
    }
    
    func torrentFilesGet(ids:Int, completion: @escaping  ([torrentFilesAll]) -> ()) {
        
        var torrentFilesAllArray = [torrentFilesAll]()
        
        let jsonString: [String: Any] = [
            "arguments": [
                "fields": [ "id", "files", "fileStats" ],
                "ids": [ids]
            ],
            "method": "torrent-get"
        ]
        
        requestAlamofire(json: jsonString) { responseObject, error in
            
            if let responseObject = responseObject {
                let json = JSON(responseObject)
                
                
                var filesArray =  [torrentFiles]()
                var fileStatsArray = [torrentFileStats]()
                
                if json["result"].stringValue == "success" {
                    for item in json["arguments"]["torrents"].arrayValue {
                        
                        for (index, itemFiles) in item["files"].arrayValue.enumerated(){
                            
                            filesArray.append(torrentFiles(id: index,
                                                           name: itemFiles["name"].stringValue,
                                                           length: itemFiles["id"].intValue))
                            
                        }
                        
                        for itemfileStats in item["fileStats"].arrayValue{
                            
                            fileStatsArray.append(torrentFileStats(bytesCompleted: itemfileStats["bytesCompleted"].intValue,
                                                                   priority: itemfileStats["priority"].intValue,
                                                                   wanted: itemfileStats["wanted"].boolValue))
                            
                        }
                        
                        for i in  0..<filesArray.count  {
                            torrentFilesAllArray.append(torrentFilesAll(idTorrent: ids, torrentFiles: filesArray[i], torrentFileStats: fileStatsArray[i]))
                        }
                    }
                }
            }
            completion(torrentFilesAllArray)
        }
    }
    func torrentAdd(data: Data, paused: Bool, completion: @escaping  (Bool) -> ()) {
        let jsonString: [String: Any] = [
            "arguments": ["metainfo" : data.base64EncodedString(),
                          "paused" : paused],
            "method": "torrent-add"
        ]
        requestAlamofire(json: jsonString) { responseObject, error in
            
            if let responseObject = responseObject {
                let json = JSON(responseObject)
                
                completion((json["result"].stringValue == "success"))
            }
            else{
                completion(false)
            }
        }
    }
    func stopTorrent(id: Int){
        
        let jsonString: [String: Any] = [
            "arguments": [ "ids" :  [id]],
            "method": "torrent-stop"
        ]
        
        requestAlamofire(json: jsonString) { responseObject, error in
        }
        
    }
    func startTorrent(id: Int){

        let jsonString: [String: Any] = [
            "arguments": [ "ids" :  [id]],
            "method": "torrent-start"
        ]
        
        requestAlamofire(json: jsonString) { responseObject, error in
        }
    }
    func deleteTorrent(id: Int){
        let jsonString: [String: Any] = [
            "arguments": [ "ids" :  [id]],
            "method": "torrent-remove"
        ]
        
        requestAlamofire(json: jsonString) { responseObject, error in
        }
    }
    
    func queuePosition(id: Int, queuePosition: Int, completion: @escaping  (Bool) -> ()) {
        let jsonString: [String: Any] = [
            "arguments": [ "ids" :  [id],
                           "queuePosition" : queuePosition],
            "method": "torrent-set"
        ]
        requestAlamofire(json: jsonString) { responseObject, error in
            
            let json = JSON(responseObject!)
            
            completion((json["result"].stringValue == "success"))
        }
    }
    
    func filesUnwanted(id: Int, filesArray: [Int], completion: @escaping  (Bool) -> ()) {
        let jsonString: [String: Any] = [
            "arguments": [ "ids" :  [id],
                            "files-unwanted" : filesArray],
            "method": "torrent-set"
        ]
        requestAlamofire(json: jsonString) { responseObject, error in
            
            let json = JSON(responseObject!)
            
            completion((json["result"].stringValue == "success"))
    }
    }
    
    func filesWanted(id: Int, filesArray: [Int], completion: @escaping  (Bool) -> ()) {
        let jsonString: [String: Any] = [
            "arguments": [ "ids" :  [id],
                           "files-wanted" : filesArray],
            "method": "torrent-set"
        ]
        requestAlamofire(json: jsonString) { responseObject, error in
            
            let json = JSON(responseObject!)
            
            completion((json["result"].stringValue == "success"))
        }
    }
    
}


