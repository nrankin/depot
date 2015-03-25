require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    errors = product.errors
    assert errors[:title].any?
    assert errors[:description].any?
    assert errors[:image_url].any?
    assert errors[:price].any?
  end

  test "product price must be positive" do
    product = Product.new(title: "My book title",
                          description: "yyy",
                          image_url: 'zzz.jpg')

    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
                product.errors[:price]
    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
                 product.errors[:price]

    product.price = 1
    assert product.valid?

  end

  def new_product(image_url)
    Product.new(title: "My book title",
                description: "yyy",
                price: 1,
                image_url: image_url)
  end

  test "image url" do
     ok = %w{ fred.gif fred.jpg fred.png FRED.GIF FRED.jpg http://a.b.c/x/y/z/fred.gif}
    bad = %w{ fred.doc fred.gif/more fred.gif.more}
    ok.each do |name|
      assert new_product(name).valid?, "#{name} should be valid"
    end
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} should'nt be valid"
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title,
                          description: "yyy",
                          price: 1,
                          image_url: "fred.gif")
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end

  # test "product is not valid without a unique title - il8n" do
  #   product = Product.new(title: products(:ruby).title,
  #                         description: "yyy",
  #                         price: 1,
  #                         image_url: "fred.gif")
  #   assert product.invalid?
  #   assert_equal [Il8n.translate('errors.messages.taken')], product.errors[:title]
  # end
end
