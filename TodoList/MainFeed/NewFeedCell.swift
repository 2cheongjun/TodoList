//
//  NewFeedCell.swift
//  TodoList
//
//  Created by 이청준 on 2022/04/14.
//

import UIKit

//셀에서프로토콜선언 ->구현은 뷰컨트롤에서
protocol firstTabVCCellDelegate: AnyObject{
//    func didTapButton()
    // 좋아요버튼이 눌릴때, index값과, Bool값을 저장한다.
    func didPressHeart(for index: Int, like: Bool, indexNum: Int)
    
//    func onClickCell(index2: Int)
}


class NewFeedCell: UITableViewCell {
    //델리게이트생성
    weak var delegate: firstTabVCCellDelegate?
    var index: Int? // 좋아요키밸류
    var indexNum: IndexPath? // 게시글인덱스
    
    var feedIdx = 0
    static let identifier = "NewFeedCell"
    

    static func nib() ->UINib {
        return UINib(nibName: "NewFeedCell", bundle: nil)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
          super.init(style: style, reuseIdentifier: reuseIdentifier)
          // 여기서 버튼에 액션 추가
          self.likeBtn.addTarget(self, action: #selector(didPressedHeart(_:)), for: .touchUpInside)
      }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
       super.setSelected(selected, animated: animated)
    }

    //좋아요 버튼정의
    @IBOutlet var likeBtn: UIButton!

    //like버튼 직접연결하는 부분***********************************************************
    @IBAction func didPressedHeart(_ sender: UIButton) {
        
        guard let idx = index else {
            return
        }
           // 게시글 번호가 있을때에만 실행한다.
            print("\(idx) 번째 게시글")
        
            sender.isSelected = !sender.isSelected
      
            if sender.isSelected {
                
                // 메인에서didPressHeart 함수를 실행
//                    delegate?.didPressHeart(for: idx, like: true)
                isTouched = true
                delegate?.didPressHeart(for: idx, like: true, indexNum:(indexNum?.row)!)
                
                // 클릭했을때 게시글 인덱스 가져오기
//                    delegate?.onClickCell(index2:(index2?.row)!)
                
            }else {
                isTouched = false
                delegate?.didPressHeart(for: idx, like: false, indexNum:(indexNum?.row)!)
            }
//        sender.isSelected = !sender.isSelected
    }
    
    
    var isTouched: Bool? {
        
           didSet {
               if isTouched == true {
//                   likeBtn.setImage(UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
                   let heart = UIImage(named: "star1.png")
                   likeBtn.setImage(heart, for: .normal)
                
               }else{
                   let heart2 = UIImage(named: "star0.png")
                   likeBtn.setImage(heart2, for: .normal)
//                   likeBtn.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
               }
           }
       }
    
    
    

    // 글번호
    @IBOutlet weak var num: UILabel!
    
    //댓글수
    @IBOutlet var relpySum: UILabel!
    
    @IBOutlet weak var imageViewLabel: UIImageView!
    // 이름
       @IBOutlet weak var titleLabel: UILabel!{
           didSet{
               titleLabel.font = UIFont.systemFont(ofSize: 24,weight: .medium)
           }
       }
       @IBOutlet weak var dataLabel: UILabel!{
           didSet{
               dataLabel.font = .systemFont(ofSize: 13, weight: .light)
           }
       }
    //글설명
       @IBOutlet weak var descriptionLabel: UILabel!{
           didSet{
               descriptionLabel.font = .systemFont(ofSize: 13, weight: .light)
           }
       }
       @IBOutlet weak var priceLabel: UILabel!{
           didSet{
               priceLabel.font = .systemFont(ofSize: 13, weight: .light)
           }
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
