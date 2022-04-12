//
//  JoinVC.swift
//  MyMemory


import UIKit
import Alamofire

class JoinVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // API 호출 상태값을 관리할 변수
    var isCalling = false
    
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    // 테이블 뷰에 들어갈 텍스트 필드들
    var fieldAccount: UITextField! // 계정 필드
    var fieldPassword: UITextField! // 비밀번호 필드
    var fieldName: UITextField! // 이름 필드
    // 상황에 따라 다른 alert를 줄 때 바꿔줄 문장을 tmpMessage로 설정
    var tmpMessage: String = ""
    
    
    override func viewDidLoad() {
        // 테이블 뷰의 dataSource, delegate 속성 지정
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // 프로필 이미지를 원형으로 설정
        self.profile.layer.cornerRadius = self.profile.frame.width / 2
        self.profile.layer.masksToBounds = true
        
        // 프로필 이미지에 탭 제스처 및 액션 이벤트 설정
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedProfile(_:)))
        self.profile.addGestureRecognizer(gesture)
        self.view.bringSubviewToFront(self.indicatorView) // 인디케이터 뷰를 화면 맨 앞으로
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        // 각 테이블 뷰 셀 모두에 공통으로 적용될 프레임 객체
        let tfFrame = CGRect(x: 20, y: 0, width: cell.bounds.width - 20, height: 37)
        switch indexPath.row {
        case 0 :
            self.fieldAccount = UITextField(frame: tfFrame)
            self.fieldAccount.placeholder = "계정(이메일)"
            self.fieldAccount.borderStyle = .none
            self.fieldAccount.autocapitalizationType = .none
            self.fieldAccount.font = UIFont.systemFont(ofSize: 14)
            cell.addSubview(self.fieldAccount)
        case 1 :
            self.fieldPassword = UITextField(frame: tfFrame)
            self.fieldPassword.placeholder = "비밀번호"
            self.fieldPassword.borderStyle = .none
            self.fieldPassword.isSecureTextEntry = true
            self.fieldPassword.font = UIFont.systemFont(ofSize: 14)
            cell.addSubview(self.fieldPassword)
        case 2 :
            self.fieldName = UITextField(frame: tfFrame)
            self.fieldName.placeholder = "이름"
            self.fieldName.borderStyle = .none
            self.fieldName.font = UIFont.systemFont(ofSize: 14)
            cell.addSubview(self.fieldName)
        default :
            ()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    // 가입완료 버튼액션
    @IBAction func submit(_ sender: Any) {
        
        // 이메일 필드,패스워드에 입력된값 리턴
        guard let fieldAccount = fieldAccount.text else{
            return }
        
        guard let fieldPassword = fieldPassword.text else{
            return }
        
        guard let fieldName = fieldName.text else{
            return }
        
        // id(email)와 password의 이름 형식, 체크후 값이 모두 채워져있을때에만 post실행하기
        if isValidEmailAddress(email: fieldAccount) && isVailedPassword(password: fieldPassword)
            && isVailedName(name: fieldName){
            // 계정과 비번이 이름이 모두 있을 경우에만
            if fieldAccount != ""  && fieldPassword != "" && fieldName != ""{
                //서버요청
                post()

            } else { // 형식은 지켰으나 정의해둔 id(email), password가 아닌 경우
                // 아이디/ 비밀번호가 올바르지 않습니다.
                failedAlert()
            }
        }
        
        // id(email) 형식이 올바르지 않은 경우
        if !isValidEmailAddress(email: fieldAccount) {
            tmpMessage = "이메일을"
            failedAlert()
        }
        
        // password 형식이 올바르지 않은 경우
        if !isVailedPassword(password: fieldPassword) {
            tmpMessage = "패스워드를"
            failedAlert()
        }
        
        // password 형식이 올바르지 않은 경우
        if !isVailedName(name: fieldName) {
            tmpMessage = "닉네임을"
            failedAlert()
        }
    }
    
    
    
    //서버에 요청
    func post(){
        if self.isCalling == true {
            self.alert("진행 중입니다. 잠시만 기다려주세요.")
            return
        } else {
            self.isCalling = true
        }
        
        // 인디케이터 뷰 애니메이션 시작
        self.indicatorView.startAnimating()
        
        // 1. 전달할 값 준비
        // 1-1. 이미지를 Base64 인코딩 처리
//        let profile = self.profile.image!.pngData()?.base64EncodedString()
        
        // 1-2. 전달값을 Parameters 타입의 객체로 정의
        let param: Parameters = [
            "userID" : self.fieldAccount.text!,
            "userPassword" : self.fieldPassword.text!,
            "userName" : self.fieldName.text!
//             ,"profile_image" : profile!
        ]
        
        // 2. API 호출
        let url = "http://3.37.202.166/login/iOS_register.php"
        let call = AF.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default)
        
        // 3. 서버 응답값 처리
        call.responseString { response in
            // 인디케이터 뷰 애니메이션 종료
            self.indicatorView.stopAnimating()
            
            
            switch response.result {
            case .success:
                print("Success")
                self.isCalling = true
                self.alert("가입이 완료되었습니다.")
               
                //                if let jsonObject = try! response.result.get() as? [String: Any] {
                //                    let result_code = jsonObject["result_code"] as? String
                //                    let success = jsonObject["success"] as? String
                //
                print("JSON2 = \(try! response.result.get())")
                //                }
            case .failure(let e):
                print(e)
                self.isCalling = false
                self.alert("가입 실패")
                
            }
            
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @objc func tappedProfile(_ sender: Any) {
        // 전반부) 원하는 소스 타입을 선택할 수 있는 액션 시트 구현
        let msg = "프로필 이미지를 읽어올 곳을 선택하세요."
        let sheet = UIAlertController(title: msg, message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "취소", style: .cancel))
        sheet.addAction(UIAlertAction(title: "저장된 앨범", style: .default) { (_) in
            selectLibrary(src: .savedPhotosAlbum) // 저장된 앨범에서 이미지 선택하기
        })
        sheet.addAction(UIAlertAction(title: "포토 라이브러리", style: .default) { (_) in
            selectLibrary(src: .photoLibrary) // 포토 라이브러리에서 이미지 선택하기
        })
        sheet.addAction(UIAlertAction(title: "카메라", style: .default) { (_) in
            selectLibrary(src: .camera) // 카메라에서 이미지 촬영하기
        })
        self.present(sheet, animated: false)
        
        // 후반부) 전달된 소스 타입에 맞게 이미지 피커 창을 여는 내부 함수
        func selectLibrary(src: UIImagePickerController.SourceType) {
            if UIImagePickerController.isSourceTypeAvailable(src) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = true
                self.present(picker, animated: false)
            } else {
                self.alert("사용할 수 없는 타입입니다.")
            }
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let rawVal = UIImagePickerController.InfoKey.originalImage.rawValue
        if let img = info[UIImagePickerController.InfoKey(rawValue: rawVal)] as? UIImage {
            self.profile.image = img
        }
        self.dismiss(animated: true)
    }
    
    
    // alert 설정
    // 값이 비어있을 경우
    func failedAlert() {
        let alertController = UIAlertController(title: nil, message: "\(tmpMessage) 입력해 주세요.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // 정규표현식을 사용하여 id(email) 형식이 맞는지 검증
    func isValidEmailAddress(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    // 정규표현식을 사용하여 password 형식이 맞는지 검증 (영+숫자 8글자 이상)
    func isVailedPassword(password: String) -> Bool {
        let passwordRegEx = "^[a-zA-Z0-9]{8,}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    // 정규표현식을 사용하여 이름이 맞는지
    func isVailedName(name: String) -> Bool {
        let nameRegEx = "^[a-zA-Z0-9]{3,}$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: name)
    }
    
}
