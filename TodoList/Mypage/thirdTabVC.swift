//
//  ThirdTabVC.swift
//  TodoList
//
//  Created by 이청준 on 2022/03/19.
//

import UIKit
//마이페이지
class thirdTabVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let profileImage = UIImageView() //프로필사진이미지
    let tv = UITableView() //프로필목록
    let uinfo = UserInfoManager()//개인정보 관리 매니저(로그인/ 로그아웃정보)/프사저장함...
    
    
    // 저장한 이름 가져오기
    let plist = UserDefaults.standard
    //지정된 값을 꺼내어 각 컨트롤에 설정한다.
    var name = ""
    var email = ""
    
    
    override func viewDidLoad() {
        //1.타이틀레이블 생성
//        let title = UILabel(frame: CGRect(x: 0, y: 100, width: 100, height: 30))
//
//        //2.타이틀 레이블속성설정
//        title.text = "마이페이지"
//        title.textColor = .red
//        title.textAlignment = .center
//        title.font = UIFont.boldSystemFont(ofSize: 16)
//
//        //콘텐츠 내용에 맞게 레이블 크기 변경ㅌ
//        title.sizeToFit()
//
//        //x축의 중앙에 오도록 설정
//        title.center.x = self.view.frame.width / 2
//
//        //수퍼뷰에 추가***************************** 탭설정끝
//        self.view.addSubview(title)
        
        // 뒤로가기 버튼 처리
//        let backBtn = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(close(_:)))
//        self.navigationItem.leftBarButtonItem = backBtn
        
        //1.프로필 사진에 들어갈 기본이미지 (Asset안에 있음) // 기본이미지가 안들어가는 문제..?
        let image = UIImage(named: "profile-bg.png")
//        let image = UIImage(named: "Account.jpg")
        //        let image = self.uinfo.profile
        // 2.프로필 이미지 처리
        self.profileImage.image = image
        self.profileImage.frame.size = CGSize(width: 100, height: 100)
        // 이미지 중앙정렬
        self.profileImage.center = CGPoint(x:self.view.frame.width / 2, y: 240)
        // 3.이미지둥글게
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.layer.borderWidth = 0
        self.profileImage.layer.masksToBounds = true
        // 4.루트뷰에 추가
        self.view.addSubview(self.profileImage)
        
        //배경이미지 설정
        let bg = UIImage(named: "profile-bg.png")
        let bgImg = UIImageView(image: bg)
        bgImg.frame.size = CGSize(width: bgImg.frame.size.width, height: bgImg.frame.size.height)
//        bgImg.frame.size = CGSize(width: bgImg.frame.size.width, height: bgImg.frame.size.height)
        bgImg.center = CGPoint(x: self.view.frame.width / 2, y: 200)
//                bgImg.layer.cornerRadius = bgImg.frame.size.width / 2
//                bgImg.layer.borderWidth = 0
//                bgImg.layer.masksToBounds = true
        self.view.addSubview(bgImg)
//        //프로필 이미지와 테이블뷰 객체를 뷰 계층의 맨앞으로 가져오는 구문
        self.view.bringSubviewToFront(self.tv)
        self.view.bringSubviewToFront(self.profileImage)
        
        
        //테이블뷰의 기본 프로퍼티의 기본 속성을 설정합니다. // 테이블뷰 높이설정
        self.tv.frame = CGRect(x: 0, y: self.profileImage.frame.origin.y + self.profileImage.frame.size.height + 20, width: self.view.frame.width, height:300)
        self.tv.dataSource = self
        self.tv.delegate = self
        
        self.view.addSubview(self.tv)
        //로그인상태에 따라 로그인/로그아웃버튼 출력
        //최초화면 로딩 시 로그인 상태에 따라 적절히 로그인/로그아웃 버튼을 출력한다.
        self.drawBtn()
        
        // 프로필이미지 객체에 탭 제스처를 등록하고, 이를 프로필메소드와 연결한다.*********************************************
        let tap = UITapGestureRecognizer(target: self, action: #selector(profile(_:)))
        self.profileImage.addGestureRecognizer(tap)
        self.profileImage.isUserInteractionEnabled = true //상호반응허락
        self.profileImage.image = self.uinfo.profile// 이미지갱신

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 여기에 셀구현 내용
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        //          cell.accessoryType = .disclosureIndicator
        
        
        //지정된 값을 꺼내어 각 컨트롤에 설정한다.
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "아이디"
            //            cell.detailTextLabel?.text = "해리포터씨"
            cell.detailTextLabel?.text = plist.string(forKey: "name") ?? "Login please"
            // 가져오는 이름값이 없으면 ""을 넣어라.
            name =  plist.string(forKey: "name") ?? ""
        case 1:
            cell.textLabel?.text = "e-mail"
            cell.detailTextLabel?.text = plist.string(forKey: "email") ?? "Login please"
            
        case 2:
            cell.textLabel?.text = "북마크"
//            cell.detailTextLabel?.text = plist.string(forKey: "name") ?? "Login please"
        default:
            ()
        }
        return cell
    }
    
    //      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //          if self.uinfo.isLogin == false {
    //              //로그인 되어있지 않다면 로그인 창을 띄워준다.
    //              self.doLogin(self.tv)
    //          }
    //      }
    
    // 프레젠트메소드방식으로 처리될예정이므로, 닫을때에도 dismiss 메소드를 사용한다.
    @objc func close(_ sender: Any){
        self.presentingViewController?.dismiss(animated: true)
    }
    
    //로그인 알림창
    //      @objc func doLogin(_ sender: Any){
    //          let loginAlert = UIAlertController(title: "LOGIN", message: nil, preferredStyle: .alert)
    //
    //          //알림창에 들어갈 입력폼 추가
    //          loginAlert.addTextField { (tf) in
    //              tf.placeholder = "Your Account"
    //          }
    //          loginAlert.addTextField { (tf) in
    //              tf.placeholder = "Password"
    //              tf.isSecureTextEntry = true
    //          }
    //          //알림창 버튼 추가
    //          loginAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    //          loginAlert.addAction(UIAlertAction(title: "Login", style: .destructive){ (_) in
    //              let account = loginAlert.textFields?[0].text ?? "" //첫번째 필드: 계정
    //              let passwd = loginAlert.textFields?[1].text ?? "" //두번쨰 필드: 비밀번호
    //
    //              if self.uinfo.login(account: account, passwd: passwd){
    //                  //TODO:(로그인 성공시 처리할 내용이 여기에 들어갈 예정입니다.)
    //                  self.tv.reloadData() //테이블뷰를 갱신한다.
    //                  self.profileImage.image = self.uinfo.profile // 이미지 프로필을 갱신한다.
    //                  //로그인상태에 따라 로그인/로그아웃버튼 출력 ****************************************************
    //                  self.drawBtn()
    //              }else{
    //                  let msg = "로그인에 실패하였습니다."
    //                  let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
    //                  alert.addAction(UIAlertAction(title: "OK", style: .cancel))
    //                  self.present(alert, animated: false)
    //              }
    //          })
    //          self.present(loginAlert, animated: false)
    //      }
    //
    //      //로그아웃
    //      @objc func doLogout(_ sender: Any){
    //          let msg = "로그아웃하시겠습니까?"
    //          let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
    //
    //          alert.addAction(UIAlertAction(title: "취소", style: .cancel))
    //          alert.addAction(UIAlertAction(title: "확인", style: .destructive) { (_) in
    //              if self.uinfo.logout(){
    //                  //로그아웃시 처리할 내용이 여기에 들어갈 예정
    //                  // 테이블뷰를 갱신한다.
    //                  self.tv.reloadData()
    //                  self.profileImage.image = self.uinfo.profile //이미지프로필을 갱신한다.
    //                  //로그인상태에 따라 로그인/로그아웃버튼 출력 ****************************************************
    //                  self.drawBtn()
    //              }
    //          })
    //          self.present(alert, animated: false)
    //      }
    //
    //로그인/로그아웃 버튼
    func drawBtn() {
        //버튼을 감쌀 뷰를 정의한다.
        let v = UIView()
        v.frame.size.width = self.view.frame.width
        v.frame.size.height = 40
        v.frame.origin.x = 0
        v.frame.origin.y = self.tv.frame.origin.y + self.tv.frame.height
        v.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        self.view.addSubview(v)
        
        //버튼을 정의한다.
        let btn = UIButton(type:.system)
        btn.frame.size.width = 100
        btn.frame.size.height = 30
        btn.center.x = v.frame.size.width / 2 //중앙정렬
        btn.center.y = v.frame.size.height / 2 //중앙정렬
        
        //로그인 상태일 때는 로그아웃버튼을, 로그아웃 상태일때는 로그인 버튼을 만들어준다.????????????????
        // 가져온이름이 있으면,? 조건작성 무엇????
        //          if self.name !=  {
        btn.setTitle("로그아웃", for: .normal)
        btn.addTarget(self, action: #selector(doLogout(_:)), for: .touchUpInside)
        //          }else {
        //              btn.setTitle("로그인", for: .normal)
        //              btn.addTarget(self, action: #selector(doLogin(_:)), for: .touchUpInside)
        v.addSubview(btn)
    }
    
    //로그아웃버튼 클릭시 로그인화면으로 이동
        @objc func doLogout(_ sender: Any){
            let msg = "로그아웃하시겠습니까?"
            let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            // 로그아웃버튼을 눌렀을때
            alert.addAction(UIAlertAction(title: "확인", style: .destructive) { (_) in
                // 로그인 화면으로 이동시키기
                guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") else {
                    return
                }
                self.navigationController?.pushViewController(uvc, animated: true)
                // 창닫는 방식
//                self.dismiss(animated: true, completion: nil)
                
                
            //uinfo의 logout메소드 사용
//                if self.uinfo.logout(){
//                    //로그아웃시 처리할 내용이 여기에 들어갈 예정
//                    // 테이블뷰를 갱신한다.
//                    self.tv.reloadData()
//                    self.profileImage.image = self.uinfo.profile //이미지프로필을 갱신한다.
//                    //로그인상태에 따라 로그인/로그아웃버튼 출력
//                    self.drawBtn()
//                }
            })
            self.present(alert, animated: false)
        }
    
    
    // 탭바 애니메이션설정
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
    
    // 이미지 피커
    func imgPicker(_ source : UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    // 프로필사진의 소스 타입을 선택하는 액션 메소드
    @objc func profile(_ sender : UIButton){
        // 로그인되어 있지 않을 경우에는 프로필 이미지 등록을 막고 대신 로그인 창을 띄워준다.
        // 계정이 널이 아닌게 아니면? / 로그인창을 띄워준다.
        //            guard self.uinfo.account != nil else {
        //                self.doLogin(self)
        //                return
        //            }
        //
        let alert = UIAlertController(title: nil, message: "사진을 가져올 곳을 선택해주세요",
                                      preferredStyle: .actionSheet)
        
        // 카메라를 사용할 수 있으면
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            alert.addAction(UIAlertAction(title: "카메라", style: .default) { (_) in
                self.imgPicker(.camera)
            })
        }
        
        // 저장된 앨범을 사용할 수 있으면
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            alert.addAction(UIAlertAction(title: "저장된앨범", style: .default) { (_) in
                self.imgPicker(.savedPhotosAlbum)
            })
        }
        // 포토라이브러리를 사용할 수 있으면
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            alert.addAction(UIAlertAction(title: "포토라이브러리", style: .default) { (_) in
                self.imgPicker(.photoLibrary)
            })
        }
        // 취소버튼 추가
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        //액션시트 창 실행
        self.present(alert, animated: true)
    }
    
    // 선택한 이미지를 전달받아 프로필 사진으로 등록할 메소드
    // 이미지를 선택하면 이 메소드가 자동으로 호출된다.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.uinfo.profile = img // 프로필이미지를 uinfo에 저장******************************************
            self.profileImage.image = img //이미지를 이미지뷰에 설정
            
            let image = self.profileImage.image
            
            if let data = image?.pngData() {
                // Create URL
                let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let url = documents.appendingPathComponent("image_name.png")

                do {
                    // Write to Disk
                    try data.write(to: url)

                    // Store URL in User Defaults
                    UserDefaults.standard.set(url, forKey: "image")

                } catch {
                    print("Unable to Write Data to Disk (\(error))")
                }
            }
            
            // userDefault에 저장하기
            
        }
        // 이미지 피커 컨트롤러 창 닫기!! 안해주면 안닫힘
        picker.dismiss(animated: true)
    }
}
