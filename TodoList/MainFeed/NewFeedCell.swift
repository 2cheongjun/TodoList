//
//  NewFeedCell.swift
//  TodoList
//
//  Created by 이청준 on 2022/04/14.
//

import UIKit

// 셀에서 프로토콜선언 -> 구현은 뷰컨트롤에서
protocol firstTabVCCellDelegate: AnyObject{
//    func didTapButton()
    // 좋아요버튼이 눌릴때, index값과, Bool값을 받아서, 뷰컨에서 실행해줘 // 버튼 클릭메소드를 실행해줘
    func didPressHeart(for index: Int, like: Bool, indexNum: Int)
    // 더보기 버튼
    func report(for index: Int,indexNum: Int)
}


class NewFeedCell: UITableViewCell {
    //델리게이트생성
    weak var delegate: firstTabVCCellDelegate?
    var index: Int? // 셀인덱스
    var indexNum: IndexPath? // 셀클릭시 게시글번호
    
    var feedIdx = 0
    static let identifier = "NewFeedCell"

    static func nib() ->UINib {
        return UINib(nibName: "NewFeedCell", bundle: nil)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
          super.init(style: style, reuseIdentifier: reuseIdentifier)
          // 여기서 버튼에 액션 추가
          self.likeBtn.addTarget(self, action: #selector(didPressedHeart(_:)), for: .touchUpInside)
          // ...버튼
      }
    
    
  
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
       super.setSelected(selected, animated: animated)
    }

    // 더보기버튼(신고하기)
    @IBAction func report(_ sender: Any) {
        guard let idx = index else {
            return
        }
        // 더보기버튼 누를때 게시글인덱스 값 얻기
        delegate?.report(for: idx,indexNum:(indexNum?.row)!)
        print("신고알림창 \(idx) 번째게시글")
    }
    
    
 
    
    
    //좋아요 버튼정의
    @IBOutlet var likeBtn: UIButton!

    // like버튼 작동부분(UI변경, 상태값 변경)***********************************************************
    // 버튼누르면 하트On,Off 하고
    // 델리게이트프토코롤에게 셀인덱스,좋아요상태,게시글번호를 전달해라.
    @IBAction func didPressedHeart(_ sender: UIButton) {
        
        guard let idx = index else {
            return
        }
         print("셀인덱스 idx \(idx)")
         
            sender.isSelected = !sender.isSelected
                        
            // 버튼을 누를때 (눌려져 있을때와, 안눌려져 있을때 버튼클릭 이벤트)
            if sender.isSelected {
                // 메인에서didPressHeart 함수를 실행
                
                // ♥ 이미 눌러져있던 하트 클릭시 //서버에서온 하트 값이 있을때(즉,서버에서 가져온값이 0이상이면, isTouched = true)
                if isTouched == true{ //
                    sender.isSelected = !sender.isSelected
                    // 빈하트로 변경
                    isTouched = false
                    // 델리게이트프토코롤에게 셀인덱스,좋아요상태,게시글번호를 전달해라.
                    delegate?.didPressHeart(for: idx, like: false, indexNum:(indexNum?.row)!)
                    print("\(idx) 번째 게시글 : 버튼 \(isTouched!)")
                }else{
                    // ♡ 하트버튼을 처음누르는 상태
                    isTouched = true
                    /// 델리게이트프토코롤에게 셀인덱스,좋아요상태,게시글번호를 전달해라.
                    delegate?.didPressHeart(for: idx, like: true, indexNum:(indexNum?.row)!)
                    
                    print("\(idx) 번째 게시글 : 버튼 \(isTouched!)")
                }
                
            }else {
                // 빈하트로 변경
                isTouched = false
                // 삭제API 호출
                delegate?.didPressHeart(for: idx, like: false, indexNum:(indexNum?.row)!)
                print("\(idx) 번째 게시글 : 버튼 \(isTouched!)")
            }
            
    }
    
    
    var isTouched: Bool? {
        
           didSet {
               if isTouched == true {
                   likeBtn.setImage(UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
//                   let heart = UIImage(named: "star1.png")
//                   likeBtn.setImage(heart, for: .normal)
                
               }else{
//                   let heart2 = UIImage(named: "star0.png")
//                   likeBtn.setImage(heart2, for: .normal)
                   likeBtn.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
               }
           }
       }
    
    
    @IBOutlet var Img: UIImageView!
    

    // 글번호
    @IBOutlet weak var num: UILabel!
    
    // 댓글수
    @IBOutlet var relpySum: UILabel!
    
    // 상단이름
       @IBOutlet weak var descriptionLabel: UILabel!{
           didSet{
               descriptionLabel.font = .systemFont(ofSize:  12, weight: .bold)
           }
       }
    // 이미지
    @IBOutlet weak var imageViewLabel: UIImageView!
   // 날짜
   @IBOutlet weak var dataLabel: UILabel!{
       didSet{
           dataLabel.font = .systemFont(ofSize: 13, weight: .light)
       }
   }
   
    // 이름
    @IBOutlet var name: UILabel!{
        didSet{
            name.font = .systemFont(ofSize: 14, weight: .bold)
        }
    }
    // 글내용
       @IBOutlet weak var titleLabel: UILabel!{
           didSet{
               titleLabel.font = UIFont.systemFont(ofSize: 14,weight: .light)
           }
       }
    
    // 장소
       @IBOutlet weak var priceLabel: UILabel!{
           didSet{
               priceLabel.font = .systemFont(ofSize: 13, weight: .light)
           }
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // 셀그림자설정
        setupLayout()
    }
    // 셀그림자설정상태
    func setupLayout() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 2
//        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
}

