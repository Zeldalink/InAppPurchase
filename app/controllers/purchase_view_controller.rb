class PurchaseViewController < UIViewController

  def viewDidLoad
    super
    @table_view = UITableView.alloc.initWithFrame(self.view.bounds)
    @table_view.setDataSource self
    @table_view.setDelegate self
    self.view.addSubview @table_view
    @plan_products = NSMutableArray.alloc.init
    get_product_info
  end

  def buy_product_select sender
    payment = SKPayment.paymentWithProduct @plan_products[sender.tag]
    SKPaymentQueue.defaultQueue.addPayment payment
    SKPaymentQueue.defaultQueue.addTransactionObserver self
  end

  def restore_purchase_select sender
    SKPaymentQueue.defaultQueue.restoreCompletedTransactions
  end

  def get_product_info
  	if SKPaymentQueue.canMakePayments
      products = NSSet.setWithObjects("0001","0002","0003",nil)
      request = SKProductsRequest.alloc.initWithProductIdentifiers products
      request.delegate = self
      request.start
  	else
  		App.alert "PURCHASE_ON_SETTINGS_ERROR"
  	end
  end

  def formatter_price price , priceLocale
    numberFormatter = NSNumberFormatter.alloc.init
    numberFormatter.setFormatterBehavior NSNumberFormatterBehavior10_4
    numberFormatter.setNumberStyle NSNumberFormatterCurrencyStyle
    numberFormatter.setLocale priceLocale
    formattedString = numberFormatter.stringFromNumber price
    formattedString
  end

  # SKProductsRequestDelegate 
  def productsRequest(request, didReceiveResponse: response)
		products = response.products
    @plan_products = response.products
    @table_view.reloadData
    products = response.invalidProductIdentifiers
    products.each do |product|
    	p "Product not found #{product}"
    end
  end

  # SKPaymentTransactionObserver
	def paymentQueue(queue, updatedTransactions: transactions)
    transactions.each do |transaction|
      case transaction.transactionState
      when SKPaymentTransactionStatePurchased
        SKPaymentQueue.defaultQueue.finishTransaction transaction
        alert = UIAlertView.alloc.init
        alert.message = "#{transaction.transactionDate}"
        alert.addButtonWithTitle "OK"
        alert.show
			when SKPaymentTransactionStateFailed
        alert = UIAlertView.alloc.init
        alert.message = "#{transaction.error.localizedDescription}"
        alert.addButtonWithTitle "OK"
        alert.show
				SKPaymentQueue.defaultQueue.finishTransaction transaction
			end
		end
  end

  def paymentQueueRestoreCompletedTransactionsFinished queue
    @purchase_founded = false
    queue.transactions.each do |transaction|
      if transaction.payment.productIdentifier == APPLE_ID || transaction.payment.productIdentifier == APPLE_ID_MONTH ||  transaction.payment.productIdentifier == APPLE_ID_YEAR
        @purchase_founded = true
        User.update_suscription @user.token, PLAN_PREMIUM do |response|
          hud.hide true
          if response.nil? 
            App.alert WEB_SERVICE_MESSAGE_ERROR
          else
            json_response = BW::JSON.parse(response)
            if json_response["response"].nil?
              @message = ""
              json_response["errors"].each do |error|
                @message << "#{error}\n"
              end
              App.alert @message
            else
              @user.plan = PLAN_PREMIUM
              @user.save
              purchase_success_controller = PurchaseSuccessViewController.alloc.init
              unless @flow.nil?
                purchase_success_controller.flow = @flow               
              end
              purchase_success_controller.user = @user
              self.navigationController.pushViewController purchase_success_controller, animated:true
            end
          end
        end
      end
    end
    unless @purchase_founded
      hud.hide true
      App.alert "#{PURCHASE_NOT_FOUND_MESSAGE_ERROR}"
    end
  end
  
  def requestDidFinish(request)
    p "The request finished successfully"
    receipt
  end

  def receipt
    p 'xochitl'
    InAppPurchases.check_in_app_purchase
  end
  # DataSource
  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier)
    cell ||= PurchaseCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: @reuseIdentifier)
    product = @plan_products[indexPath.row]
    cell.product_title.text = product.localizedTitle
    cell.product_description.text =  "#{product.localizedDescription}\nAdquiérelo por solo:" 
    cell.product_price.text = formatter_price product.price, product.priceLocale
    cell.button_pay.setTag indexPath.row
    cell.button_pay.addTarget self, action: 'buy_product_select:', forControlEvents:UIControlEventTouchUpInside
    cell
  end


  def tableView(tableView, numberOfRowsInSection: section)
    @plan_products.count
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    329
  end


end