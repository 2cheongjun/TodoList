//
//  DetailViewController.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/31.
//

import UIKit

// 게시글눌렀을때 상세
class DetailViewController: UIViewController, UITextViewDelegate{
    
    //피드 모델에 값이 있으면 가져온다.
    var feedResult: FeedResult?
    
    var feedIdx = 0
    
    @IBOutlet var movieCotainer: UIImageView!
    
    @IBOutlet var userID: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var myPlaceText: UILabel!
    
    @IBOutlet var postText: UITextView!{
        didSet{
            postText.font = UIFont.systemFont(ofSize: 16, weight: .light)
        }
    }
    //취소버튼
    @IBAction func barCancleBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 완료버튼
    @IBAction func barOKBtn(_ sender: Any) {
        // 수정API호출
    }
    
    
    /// 화면을 누르면 키보드 내려가게 하는 것
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 화면이 그려지기전에 세팅한다.
    override func viewDidLoad() {
        super.viewDidLoad()
        // 델리게이트 연결
        self.postText.delegate = self
        
        userID.text = feedResult?.userID
        myPlaceText.text = feedResult?.myPlaceText
        date.text = feedResult?.date
        postText.text = feedResult?.postText
        
        // 게시글번호
        feedIdx = feedResult!.feedIdx
        
        // 이미지처리방법
        if let hasURL = self.feedResult?.postImgs{
            // 이미지로드 서버요청
            self.loadImage(urlString: hasURL) { image in
                DispatchQueue.main.async {
                    self.movieCotainer.image = image
                }
            }
        }
    }
    
    // 이미지 Get요청
    func loadImage(urlString: String, completion: @escaping (UIImage?)-> Void){
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        // urlString 이미지이름을(ex:http://3.37.202.166/img/2-jun.jpg) 가져와서 URL타입으로 바꿔준다.
        if let hasURL = URL(string: urlString){
            var request = URLRequest(url: hasURL)
            request.httpMethod = "GET"
            //               request.httpMethod = "POST"
            
            session.dataTask(with: request) { data, response, error in
                //                   print( (response as! HTTPURLResponse).statusCode)
                
                if let hasData = data {
                    completion(UIImage(data: hasData))
                    return
                }
            }.resume() //실행한다.
            session.finishTasksAndInvalidate()
        }
        // 실패시 nil리턴한다.
        completion(nil)
    }
    
    
    //삭제버튼
    @IBAction func delBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "게시물 삭제", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "삭제", style: .default) { [self] (_) in
            //  여기에 실행할 코드
            // 갤러리에서 받아온 UIImage값 받아서 newProfile함수 호출
            // 서버로 게시글 번호를 보내고, 그 번호에 맞는 게시글을 삭제한다.
            requestFeedDeleateAPI()
            // 창을 닫는다.
            self.dismiss(animated: true, completion: nil)
            
        }
        alert.addAction(alertAction)
        
        // 왜인지 취소글자가 더두꺼워보임???
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancel)
        //                alert.view.tintColor =  UIColor(ciColor: .black)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    //수정버튼
    @IBAction func modifyBtn(_ sender: Any) {
        //        let postText = UITextField()
        postText.becomeFirstResponder()// 키보드가 나타나고 입력상태가 된다.
        //        postText.clearButtonMode = .always // 텍스트필드만 됨
    }
    
    
    // 게시글삭제 API호출
    func requestFeedDeleateAPI(){
        print("삭제 API호출")
        
        // 1. 전송할 값 준비
        // JSON으로 요청하기 ************************************************************************
        let param = ["feedIdx" : feedIdx]
        print("게시글번호: \(feedIdx)")
        let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])
        
        // 2. URL 객체 정의 (삭제)
        let url = URL(string: "http://3.37.202.166/post/0iOS_feedDelete.php")
        
        // 값이 있다면 받아와서 넣음.
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // 5-1. 서버가 응답이 없거나 통신이 실패했을 때
            if let e = error {
                NSLog("DetailViewController 삭제요청 /서버응답없음 통신실패 : \(e.localizedDescription)")
                return
            }
            // 5-2. 응답 처리 로직이 여기에 들어갑니다.
            // ① 메인 스레드에서 비동기로 처리되도록 한다.
            DispatchQueue.main.async() {
                do {
                    let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    guard let jsonObject = object else { return }
                    
                    print("DetailViewController 삭제요청/ 서버응답") // 코더블안해서 그런것같다???
                    // ② JSON 결과값을 추출한다.
                    //                    let result = jsonObject as? String
                    let success = jsonObject["success"] as? String
                    //                    let userID = jsonObject["userID"] as? String
                    print("DetailViewController 응답결과 \(success)")
                    
                    
                } catch let e as NSError {
                    print("DetailViewController 삭제요청/ 파싱오류: \(e.localizedDescription)")
                }
            } // end if DispatchQueue.main.async()
        }   // 6. POST 전송
        task.resume()
    }
}

