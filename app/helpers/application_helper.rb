module ApplicationHelper
  def hidden_div_if(condition, attributes = {}, &block)
    if condition
      attributes[:style] = "display: none"
    end
    content_tag("div", attributes, &block)
  end

  def locale_currency(price)
    price = I18n.locale == :es ? price * 0.8 : price
  end
end
