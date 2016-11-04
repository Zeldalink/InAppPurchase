class InAppPurchases


	def self.check_in_app_purchase
		receiptURL = NSBundle.mainBundle.appStoreReceiptURL
		receiptData = NSData.dataWithContentsOfURL receiptURL
		p receiptData.length
		if receiptData.nil?
			p 'esta vacío'
		else
			p 'estoy lleno'
			e = Pointer.new(:object)
			receiptDictionary = { "receipt-data" => receiptData.base64EncodedStringWithOptions(0), "password" => "1db35e641dc449aab1ce61adbaf9ecfe"}
			requestData = NSJSONSerialization.dataWithJSONObject(receiptDictionary, options: 0, error: e )
			storeURL = NSURL.URLWithString("https://sandbox.itunes.apple.com/verifyReceipt")
			p storeURL.absoluteString
			storeRequest = NSMutableURLRequest.requestWithURL(storeURL)
			storeRequest.HTTPMethod = "POST"
			storeRequest.HTTPBody = requestData
			p storeRequest
			sessionError = Pointer.new(:object)
			session = NSURLSession.sessionWithConfiguration(NSURLSessionConfiguration.defaultSessionConfiguration,delegat: nil, delegateQueue: NSOperationQueue.mainQueue)
			result = NSData.alloc.init
			session.dataTaskWithRequest(storeRequest, completionHandler: ->(data, response, error) {
				p 'splatoon'
			})









		end
	end

   
end