Input_Account = "//*[text()='Customer Account']//following::*[@aria-label='Search' and @role='textbox']"
Select_TestAccount2 = "//*[normalize-space(text())='Test Account 2 (105214)']/parent::*[@role='option']"

Input_Vendor = "//*[text()='Filter By Vendor']//following::*[@role='textbox' and @aria-label='Search']"
Select_Vendor = "//*[text()='Filter By Vendor']//following::*[@role='option']/*[text()='${vendor}']"

History_LoadingIndicator = "//*[contains(text(), 'History')]//*[@id='loading-indicator']"
Search_LoadingIndicator = "//*[contains(text(), 'Search')]//*[@id='loading-indicator']"

EDI_Details = "//*[@id='OrderList']//td[3]/div//following::*[contains(text(),'EDI Details:')][1]"
Filter_Distributor = "//*[text()='Filter By Distributor:']//following::*[@role='option']/*[text()='-- All Distributors --']"
Filter_Location = "//*[text()='Filter By Location:']//following::*[@role='option']/*[text()='-- All Locations --']"

Find_SearchOrder_LoadingIndicator = "//*[contains(text(), 'Search for an Order:')]/following::*[contains(text(), 'Find')]//*[@id='loading-indicator']"

OrderSendMessage = "//*[contains(@class, 'btn-success') and starts-with(@onclick, 'ViewOrderEDIDocumentDetails(')]"
OrderSendMessage_Status = "//*[contains(@class, 'btn-success') and starts-with(@onclick, 'ViewOrderEDIDocumentDetails(')]"
OrderReceivedMessage_Status = "//*[contains(@class, 'btn-success') and starts-with(@onclick, 'EDIDocumentDetailsModal(') and contains(@onclick, "'997'")]"
OrderConfirmationMessage_Status = "//*[contains(@class, 'btn-success') and starts-with(@onclick, 'EDIDocumentDetailsModal(') and contains(@onclick, "'855'")]"
OrderInvoiceMessage_Status= "//*[contains(@class, 'btn-success') and starts-with(@onclick, 'EDIDocumentDetailsModal(') and contains(@onclick, "'810'")]"
OrderShippingMessage_Status = "//*[contains(@class, 'btn-success') and starts-with(@onclick, 'EDIDocumentDetailsModal(') and contains(@onclick, "'856'")]"
OO_ReceiveOrder = "//*[@id='OrderList']//following::*[text()='Receive Order']"
Confirmation = "//*[@id='OrderList']//following::*[contains(@href, '/Order/OrderConfirmation')]"
Invoice = "//*[@id='OrderList']//following::*[contains(@href, '/Invoice/ReconcileInvoice')]"
TrackPackage = "//*[@id='OrderList']//following::*[text()=' Track Package']"

ConfirmationNumber = "//*[@id='ConfirmationNumber']"