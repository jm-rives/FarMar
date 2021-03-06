class FarMar::Sale  # can only chain one to another

  attr_reader :id, :sale_amount, :purchase_date, :vendor_id, :product_id 

  def initialize(id, sale_amount, purchase_date, vendor_id, product_id)

    @id = id
    @sale_amount = sale_amount # in cents
    @purchase_date = purchase_date
    #WRONG! should not have to require vendor_id or product_id 
    @vendor_id = vendor_id
    @product_id = product_id

  end
  # these can be re-used with a base class and 
  # a method to read in the files
  # it's called inheritance

  def self.all

    sale_array = []

    CSV.foreach('./support/sales.csv') do |line|
      id = line[0]
      sale_amount = line[1] # in cents
      purchase_date = line[2]
      vendor_id = line[3]
      product_id = line[4]

      sale_array << FarMar::Sale.new(id, sale_amount, purchase_date, vendor_id,product_id)

    end
    return sale_array
  end

  def self.find(id)
    
    found_sale = nil

    all.each do |sale|
      if sale.id == id
        found_sale = sale
        break
      end
    end
    return found_sale
  end

  def get_vendor
    found_vendor = FarMar::Vendor.find(@vendor_id)
    return found_vendor
  end 

  def get_product
    found_product = FarMar::Product.find(@product_id)
    return found_product
  end

  # expects string, returns Sale objects
  def self.between(begin_time, end_time)

    found_sales = []

    start_time = Time.parse(begin_time)
    finish_time = Time.parse(end_time)

    all.each do |sale|

      purchase_date = sale.purchase_date
      sale_time = Time.parse(purchase_date)

      if sale_time >= start_time &&
         sale_time <= finish_time

        found_sales.push(sale)
      end
    end
    return found_sales
  end

end











