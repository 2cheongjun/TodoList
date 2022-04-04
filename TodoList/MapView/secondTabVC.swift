//
//  secondTabVC.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/19.
//
// 지도위치
import UIKit
import Alamofire
import SwiftyJSON

class secondTabVC : UIViewController, MTMapViewDelegate, MTMapReverseGeoCoderDelegate {
    //지도map
    var mapView: MTMapView?
    var mapPoint1: MTMapPoint?
    var poiItem1: MTMapPOIItem?
    var geocoder: MTMapReverseGeoCoder!
    
//    var latitude : Double = 37.576568
//    var longitude : Double = 127.02914
    

    
    var allCircle = [MTMapCircle]()
    

    //검색창
//    @IBOutlet var placeSearch: UISearchBar!
    
    @IBOutlet var test: UITextField!
    
    public struct Place{
                let placeName :String
                let roadAdressName:String
                let longitudeX:String
                let latitudeY:String
            }
            
        var resultList=[Place]()
        
        var keyword = ""
        var page = 4
        
        
      
    
    override func viewDidLoad() {
        // 상단 백버튼가림
        self.navigationController?.navigationBar.isHidden = true
        
        self.view.bringSubviewToFront(self.test)
        // 지도 맵뷰시작
        mapView = MTMapView(frame: self.view.bounds)
        if let mapView = mapView {
            // 델리게이트 연결
            mapView.delegate = self
            // 지도의 타입 설정 - hybrid: 하이브리드, satellite: 위성지도, standard: 기본지도
            mapView.baseMapType = .standard
            
            // 현재 위치 트래킹
            mapView.currentLocationTrackingMode = .onWithoutHeading
            mapView.showCurrentLocationMarker = true
            
            // 지도의 센터를 설정 (x와 y 좌표, 줌 레벨 등을 설정)
            mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude:   37.47538105879285, longitude:  126.90334542924597)), zoomLevel: 5, animated: true)
            self.view.addSubview(mapView)
//
//            let poiltem1 = MTMapPOIItem()
//            poiltem1.itemName = "우리집"
//            poiltem1.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.47538105879285, longitude: 126.90334542924597))
//            poiltem1.markerType = .redPin
//
//            mapView.addPOIItems([poiltem1])
            
        }
    }

    
    // poiItem 클릭 이벤트
       func mapView(_ mapView: MTMapView!, touchedCalloutBalloonOf poiItem: MTMapPOIItem!) {
           // 인덱스는 poiItem의 태그로 접근
           let index = poiItem.tag
       }
    
    
    
    //finishedMapMoveAnimation함수는 지도가 이동이 끝난 후의 좌표값(위도, 경도 → 여기서는 mapCenterPoint)을 얻을 수 있다.
//    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
//
//        let geocoder = MTMapReverseGeoCoder(
//            mapPoint: MTMapPoint(geoCoord: MTMapPointGeo(
//            latitude : mapCenterPoint.mapPointGeo().latitude,
//            longitude : mapCenterPoint.mapPointGeo().longitude)),
//            with: self, withOpenAPIKey:"78eb7f9c872b5f4d6b83178c1aed4366")
//
//        self.geocoder = geocoder
//        geocoder?.startFindingAddress()
//
//        print(geocoder?.startFindingAddress() as Any? ?? "")
//
//        }
//
//    // 그리고 좌표값을 변환해서 문자열값을 얻기 위한함수
//    func mtMapReverseGeoCoder(_ rGeoCoder: MTMapReverseGeoCoder!, foundAddress addressString: String!) {
//        guard let addressSting = addressString else { return }
//        address = addressSting
//    }

       
//       override func viewWillDisappear(_ animated: Bool) {
//           // mapView의 모든 poiItem 제거
//           for item in mapView!.poiItems {
//               mapView!.remove((item as! MTMapPOIItem))
//           }
//       }
    
    // 마커 추가
//        func makeMarker(){
//
//            /*
//            저는 서버 api를 통해 가져온 데이터를 resultList에 담았어요
//            이름, 좌표, 주소 등을 담은 구조체를 담은 배열이에요
//            */
//
//            // cnt로 마커의 tag를 구분
//            var cnt = 0
//            for item in resultList {
//                self.mapPoint1 = MTMapPoint(geoCoord: MTMapPointGeo(latitude: item.x, longitude: item.y
//                ))
//                poiItem1 = MTMapPOIItem()
//                // 핀 색상 설정
//                poiItem1?.markerType = MTMapPOIItemMarkerType.redPin
//                poiItem1?.mapPoint = mapPoint1
//                // 핀 이름 설정
//                poiItem1?.itemName = item.placeName
//                // 태그 설정
//                poiItem1?.tag = cnt
//                // 맵뷰에 추가!
//                mapView!.add(poiItem1)
//                cnt += 1
//            }
//        }
        
        // 애니메이션설정
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            let tabBar = self.tabBarController?.tabBar
            //        tabBar?.isHidden = (tabBar?.isHidden == true) ? false : true
            UIView.animate(withDuration: TimeInterval(0.15),animations:{
                //알파값이 0이면 1로, 1이면 0으로 바꿔준다.
                //호출될때마다 점점 투명해졌다가 점점 진해질 것이다.
                //                              (참거짓조건)? 참일때의값 : 거짓일때의 값
                tabBar?.alpha = (tabBar?.alpha == 0 ? 1 : 0)
            })
        }
        
    }

