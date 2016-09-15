module ApplicationHelper
  def hidden_div_if(condition, attributes = {}, &block)
    if condition
      attributes['style'] = 'display: none'
    end
    content_tag('div', attributes, &block)
  end

  def convert_and_display(price)
    converted_price = I18n.locale == :es ? price * 1.12 : price
    number_to_currency(converted_price)
  end
end
