class PurchaseCell < UITableViewCell
  attr_accessor :product_title
  attr_accessor :product_description
  attr_accessor :product_price
  attr_accessor :button_pay


  def initWithStyle(style, reuseIdentifier:cell_identifier)
    super
    
    @product_title = UILabel.alloc.initWithFrame CGRectMake(20, 20, 280, 22)
    self.contentView.addSubview @product_title
    
    @product_description = UILabel.alloc.initWithFrame CGRectMake(15, 50, 290, 22*5)
    self.contentView.addSubview @product_description
    
    @product_price = UILabel.alloc.initWithFrame CGRectMake(15, 155, 290, 22)
    self.contentView.addSubview @product_price
    
    @button_pay = UIButton.buttonWithType UIButtonTypeRoundedRect
    @button_pay.setTitle "Comprar", forState:UIControlStateNormal
    @button_pay.frame = CGRectMake(170, 260, 130, 47)
    self.contentView.addSubview @button_pay
    self
    
  end

end