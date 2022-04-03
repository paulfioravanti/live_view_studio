defmodule LiveViewStudio.Licenses do
  @standard_price_max_quantity 5
  @standard_price 20.0
  @discount_price 15.0

  def calculate(seats) do
    if seats <= @standard_price_max_quantity do
      seats * @standard_price
    else
      100 + (seats - @standard_price_max_quantity) * @discount_price
    end
  end
end
