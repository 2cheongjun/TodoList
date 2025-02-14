//
//  noticeVC.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/28.
//

import UIKit
import Kingfisher
import Alamofire
import SwiftyJSON

// 하트모음 컬렉션뷰
class HeartVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let cellIdentifier:String = "cell"
    // 모델가져오기
    var heartModel: HeartModel?
    //피드 모델에 값이 있으면 가져온다.
    var heartResult: HeartResult?
    var num = ""
    
    var feedIdx = 0
    // 게시글페이징 시작
    var page = 1
    
    // BASEURL
    var BASEURL = UrlInfo.shared.url!
    //userDefaults에 저장된이름값 가져오기
    let plist = UserDefaults.standard    
    
    // 노티3.HeartDetailViewController에서 보낸 노티 받을준비
    let HeartDetailVCNOTI = Notification.Name("HeartDetailVCNOTI")
    
    // 콜렉션뷰 연결
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //델리게이트연결안하면 뷰에 보이지도 않음
        collectionView.delegate = self
        collectionView.dataSource = self
      
        // 컬렉션API 호출
        bookMarkStart()
        //노티등록(북마크 새로고침, 북마크디테일뷰에서 받아옴)
        setNotification()
    }

    
    // 노티5.옵저버가 DissmissWrite를 받았을때 실행할 내용: 데이터 리로드
       @objc func reloadaction(_ noti: Notification) {
           // API호출
            upLoadHeart()
               OperationQueue.main.addOperation { // DispatchQueue도 가능.
                   self.collectionView.reloadData()
               }
           }

    
    override func viewWillAppear(_ animated: Bool) {
        //노티등록(북마크 1고침, 북마크디테일뷰에서 받아옴)
        setNotification()
        // 컬렉션API 호출
        bookMarkStart()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // HeartDetailVCNOTI 노티삭제
        NotificationCenter.default.removeObserver(self, name: HeartDetailVCNOTI, object: nil)
        print("HeartDetailVCNOTI 노티삭제")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return self.numberOfCell
        return self.heartModel?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as?
                HeartCollectionViewCell else {
            return HeartCollectionViewCell()
        }
        // 델리게이트위임
//         cell.delegate = self
        //글번호
//        cell.addressLabel.text = self.heartModel?.results[indexPath.row].postIdx?.description ?? ""
        let num  = self.heartModel?.results[indexPath.row].postIdx?.description ?? ""
        
        
        // 킹피셔를 사용한 이미지 처리방법
        if let imageURL =  self.heartModel?.results[indexPath.row].postImgs {
            // 이미지처리방법
            guard let url = URL(string: imageURL) else {
                //리턴할 셀지정하기
                return cell
            }
            // cell.postImg.kf.setImage(with:url)
            cell.postImg.kf.indicatorType = .activity
            cell.postImg.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholderImage"),
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            {
                result in
                switch result {
                case .success(let value):
                    print("좋아요킹피셔 Task done")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        }
        return cell
    }
    
    //***************************************************************************************************************************
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        // 컬랙션뷰의 데이터를 먼저 삭제 해주고, 데이터 배열의 값을 삭제해줍니다!! , '반대로할시에 데이터가 꼬이는 현상이 발생합니다.'
        // self.numberOfCell += 1
        print(indexPath.row)
        // 클릭해서 각해당하는 상세뷰 띄우기
        // 이동하고자하는 뷰턴 객체생성해 호출하기 / 스토리보드 기반으로 가져오기. 스토리보드ID
        let HeartDetailVC = UIStoryboard(name:"HeartDetailViewController" , bundle: nil).instantiateViewController(withIdentifier: "HeartDetailViewController") as! HeartDetailViewController
        
        // 컬렉션뷰에 좋아요모음 가져오기
        HeartDetailVC.heartResult = self.heartModel?.results[indexPath.row]
 
//        HeartDetailVC.modalPresentationStyle = .fullScreen
        
        // 화면이 띄워진후에 값을 넣어야 널크러쉬가 안남
        self.present(HeartDetailVC, animated: true){ }
    }
    
   
    // 좋아요북마크 모음 호출
    func upLoadHeart() {
        
        let userID = plist.string(forKey: "name")
        
        let param: Parameters = [ "userID" :userID ?? "" ]
        
        // API 호출 URL
        let url =  self.BASEURL+"bookMark/heartBookmark.php"
        let call = AF.request(url, method: .post, parameters: param,
                              encoding: JSONEncoding.default)
        //                call.responseJSON { res in
        call.responseJSON { res in
            
            // 성공실패케이스문 작성하기
            print("좋아요로드 요청")
            //            print("JSON= \(try! res.result.get())!)")
            
            guard let jsonObject = try! res.result.get() as? [String :Any] else {
                print("올바른 응답값이 아닙니다.")
                return
            }
            
            if let jsonObject = try! res.result.get() as? [String :Any] {
                let success = jsonObject["success"] as? Int ?? 0
                
                if success == 1 {
                  
                    print("JSON= \(try! res.result.get())!)")
                    do{
                        // Any를 JSON으로 변경
                        let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
//                        print(dataJSON)
                        // JSON디코더 사용
                        self.heartModel = try JSONDecoder().decode(HeartModel.self, from: dataJSON)
           
//                        print((self.heartModel ?? "no data"))
                        
                        // 모든UI 작업은 메인쓰레드에서
                        DispatchQueue.main.async {
                            // 테이블뷰 갱신 (자동으로 갱신안됨)
                            self.collectionView.reloadData()
                            
                            
                         }
                  
                    }// 디코딩 에러잡기
                        catch let DecodingError.dataCorrupted(context) {
                           print(context)
                       } catch let DecodingError.keyNotFound(key, context) {
                           print("Key '\(key)' not found:", context.debugDescription)
                           print("codingPath:", context.codingPath)
                       } catch let DecodingError.valueNotFound(value, context) {
                           print("Value '\(value)' not found:", context.debugDescription)
                           print("codingPath:", context.codingPath)
                       } catch let DecodingError.typeMismatch(type, context)  {
                           print("Type '\(type)' mismatch:", context.debugDescription)
                           print("codingPath:", context.codingPath)
                       } catch {
                           print("error: ", error)
                       }
                    }
                else if(success == 0){
                //sucess가 0이면
                        print("응답실패")
                    }
                }
            }
            }//함수 끝
    
    func bookMarkStart(){
        // 북마크모음호출 API
        let userID = plist.string(forKey: "name")
        // 로그인상태에서만 호출
        if userID != nil {
            upLoadHeart()
            // 뷰업데이트 // 뷰업데이트
            OperationQueue.main.addOperation { // DispatchQueue도 가능.
                self.collectionView.reloadData()
            }
        }
    }
    
    func setNotification(){
        // 노티4.옵저버를 등록하고,DissmissWrite가 오면 writeVCNotification함수를 실행한다.
              NotificationCenter.default.addObserver(self, selector: #selector(self.reloadaction(_:)), name: HeartDetailVCNOTI, object: nil)
    }
    
}//VC끝
        
        // 컬렉션뷰 상태옵션
        // cell layout
        extension HeartVC: UICollectionViewDelegateFlowLayout {
            
            // 위 아래 간격
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
                return 1
            }
            
            // 옆 간격
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
                return 1
            }
            
            // cell 사이즈( 옆 라인을 고려하여 설정 )
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                
                let width = collectionView.frame.width / 3 - 1 ///  3등분하여 배치, 옆 간격이 1이므로 1을 빼줌
//                print("collectionView width=\(collectionView.frame.width)")
//                print("cell하나당 width=\(width)")
//                print("root view width = \(self.view.frame.width)")
                
                let size = CGSize(width: width, height: width)
                return size
            }
        }
        
