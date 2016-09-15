module StoreHelper
  def convert_and_display(price)
    converted_price = I18n.locale == :es ? price * 1.12 : price
    number_to_currency(converted_price)
  end
end
