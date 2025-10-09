using Razorpay.Api;
using Razorpay.Api.Errors;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class responseHDFC : System.Web.UI.Page
{
    DBHelper db = new DBHelper();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // 1. Get Parameters from the Query String
            string paymentId = Request.QueryString["pid"];       // razorpay_payment_id
            string orderId = Request.QueryString["oid"];         // razorpay_order_id
            string signature = Request.QueryString["signature"]; // razorpay_signature
            string clientTxnId = Request.QueryString["txnid"];   // Your internal ID
            string amount = Request.QueryString["amount"];   // Your internal ID

            // If any parameter is missing, treat it as a potential failure or cancellation
            if (string.IsNullOrEmpty(paymentId) || string.IsNullOrEmpty(orderId) || string.IsNullOrEmpty(signature))
            {
                string alertScript = "alert('❌ Payment parameters missing or payment was cancelled.');";
                ClientScript.RegisterStartupScript(this.GetType(), "alertMissingParams", alertScript, true);
                return;
            }

            // 2. Retrieve your Keys from configuration (Needed for API call)
            var keySecret = ConfigurationManager.AppSettings["RazorpayKeySecret"];
            var keyId = ConfigurationManager.AppSettings["RazorpayKeyId"];

            try
            {
                // =========================================================
                // MANUAL SIGNATURE VERIFICATION
                // =========================================================

                string expectedSignaturePayload = orderId + "|" + paymentId;
                byte[] keyBytes = Encoding.UTF8.GetBytes(keySecret);
                byte[] payloadBytes = Encoding.UTF8.GetBytes(expectedSignaturePayload);

                using (var hmac = new HMACSHA256(keyBytes))
                {
                    byte[] hashBytes = hmac.ComputeHash(payloadBytes);
                    string generatedSignature = BitConverter.ToString(hashBytes).Replace("-", "").ToLower();

                    // E. Compare the generated signature with the one received from Razorpay
                    if (generatedSignature == signature)
                    {
                      

                        // A. Instantiate the Razorpay Client to make API call
                        RazorpayClient client = new RazorpayClient(keyId, keySecret);

                        // B. Fetch the payment details using the Payment ID
                        Razorpay.Api.Payment payment = client.Payment.Fetch(paymentId);

                        // C. Extract the required details
                        string status = payment.Attributes["status"];
                        string statusdb = "";
                        if(status =="captured")
                        {
                            statusdb = "SUCCESS";
                        }
                        else if (status == "failed")
                        {
                            statusdb = "FAILED";
                        }
                        else if (status == "authorized")
                        {
                            statusdb = "AUTHORIZED";
                        }
                            string bank = payment.Attributes["bank"]; // Bank code (e.g., HDFC)
                        string paymentMode = payment.Attributes["method"];
                        // NEW: Get amount in subunits and calculate standard value
                        long paidAmount = (long)payment.Attributes["amount"];
                        string currency = payment.Attributes["currency"];
                        //decimal paidAmount = amountInSubunits / 100M; // Divide by 100 to get the actual value

                        long createdAtUnix = (long)payment.Attributes["created_at"];
                        DateTime transactionDate = DateTimeOffset.FromUnixTimeSeconds(createdAtUnix).LocalDateTime;
                        string transactionDateString = transactionDate.ToString("dd-MMM-yyyy hh:mm:ss tt"); // Format for display
                        string errorCode = (payment.Attributes["error_code"] as string) ?? string.Empty;

                        // Bank Reference Number/Bank Transaction ID (part of acquirer_data object)
                        string bankTransactionId = "";
                        if (payment.Attributes.ContainsKey("acquirer_data"))
                        {
                            // Accessing nested JSON data as a dictionary
                            Dictionary<string, object> acquirerData = payment.Attributes["acquirer_data"] as Dictionary<string, object>;
                            if (acquirerData != null && acquirerData.ContainsKey("bank_transaction_id"))
                            {
                                bankTransactionId = acquirerData["bank_transaction_id"].ToString();
                            }
                        }

                        lblClientTransId.Text = clientTxnId;
                        lblBankTransId.Text = !string.IsNullOrEmpty(bankTransactionId) ? bankTransactionId : "N/A";
                        lbl_amountpaid.Text = paidAmount.ToString("N2") + " " + currency;
                        lbl_paymentdate.Text = transactionDateString;
                        lblStatus.Text = statusdb;
                        int respayment = 0;
                        respayment = db.UpdateStudentPaymentDetails(clientTxnId, paidAmount.ToString(), statusdb, paymentMode, paymentId, bankTransactionId, transactionDateString, "", "", "", "", "", errorCode, "1");
                        //respayment = db.UpdateStudentPaymentDetails(clientTxnId, paidAmount.ToString(), statusdb, paymentMode, "", bankTransactionId, transactionDateString, "", "", "", "", "", errorCode, "1");


                        // Final Check: Ensure payment status is 'captured'
                        if (respayment == 0 && statusdb.ToUpper() == "SUCCESS")
                        {
                            // **TODO:** Update your database: Mark the order/transaction as 'Paid' 
                            // and store paymentId, bank, method, and bankTransactionId.

                            // Construct and register the success alert
                            imgSuccess.Visible = true;
                            string script = @"
                swal({
                    title: 'Success!',
                    text: 'Payment processed successfully.',
                    icon: 'success',
                    button: 'OK'
                });";
                            ScriptManager.RegisterStartupScript(this, GetType(), "PaymentSuccess", script, true);


                        }
                        else if (respayment == 0 && statusdb.ToUpper() == "FAILED" || statusdb.ToUpper() == "AUTHORIZED")
                        {
                            // Payment failed, was rejected, or is still 'created'
                            imgFailure.Visible = true;
                            string script = @"
                swal({
                    title: 'Payment Failed',
                    text: 'Payment failed as per bank response. Please try again.',
                    icon: 'error',
                    button: 'Retry'
                });";
                            ScriptManager.RegisterStartupScript(this, GetType(), "PaymentFailedBank", script, true);
                        }
                    }
                    else
                    {
                        // FAILURE: SIGNATURE MISMATCH/TAMPERED

                        // **TODO:** DO NOT fulfill the order. Log the security failure.

                        string failureMessage = "❌ Payment Failed Security Check (Signature Mismatch).\\nContact support with Txn ID: " + clientTxnId;
                        string alertScript = "alert('" + failureMessage + "');";
                        ClientScript.RegisterStartupScript(this.GetType(), "alertSignatureFail", alertScript, true);
                    }
                }
            }
            catch (Exception ex)
            {
                // Handle API errors (e.g., if the key is wrong, or paymentId is invalid) or general exceptions
                string errorMessage = "⚠️ An unexpected error occurred: " + ex.Message;
                string alertScript = "alert('" + errorMessage + "');";
                ClientScript.RegisterStartupScript(this.GetType(), "alertGeneralError", alertScript, true);
            }
        }
    }
    }
    
