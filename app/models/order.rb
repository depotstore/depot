class Order < ApplicationRecord
  has_many :line_items, dependent: :destroy
  enum pay_type: {
    'Check' => 0,
    'Credit card' => 1,
  ' Purchase order' => 2
  }
  validates :name, :address, :email, presence: true
  validates :pay_type, inclusion: pay_types.keys
  validate :cc_number_cannot_be_empty_or_contain_non_digit

  before_validation CreditCardsCallbacks.new
  # before_validation :normalize_credit_card_number
  before_validation :nullify_cc_number_for_purchase_order_or_check
  after_create do |order|
    logger.info "Order #{order.id} created"
  end
  # validates :ship_date,  inclusion: { in: ((DateTime.now - 1.minute)..(DateTime.now + 2.minutes)) }
  scope :last_n_days, ->(days){ where('updated_at < ?', (Time.now - days.days))}
  scope :checks, ->{ where(pay_type: 0)}

  encrypt(:name, :email)
  # encrypter = Encrypter.new([:name, :email])
  # before_save encrypter
  # after_save encrypter
  # after_find encrypter

  def add_line_itmes_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  protected
  # def normalize_credit_card_number
  #   self.cc_number.gsub!(/[-\s]/, "") if self.cc_number
  # end

  def cc_number_cannot_be_empty_or_contain_non_digit
    if self.pay_type == 'Credit card'
      if self.cc_number
        if self.cc_number.empty?
          errors.add(:cc_number, 'Credit card number cannot be empty.')
        elsif self.cc_number =~ /\D/
          errors.add(:cc_number, 'Credit card should contain only digits.')
        end
      else
        errors.add(:cc_number, 'Credit card number cannot be nil.')
      end

    end

  end

  def nullify_cc_number_for_purchase_order_or_check
    self.cc_number = nil  unless self.pay_type == 'Credit card'
  end

  # def after_find
  # end

end
