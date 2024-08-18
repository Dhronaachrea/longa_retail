package com.skilrock.longalottoretail

data class BalanceInvoiceReportResponse(
    val claimTax: String,
    val claims: String,
    val closingBalance: String,
    val commission: String,
    val creditDebitTxn: String,
    val openingBalance: String,
    val payments: String,
    val sales: String,
    val salesCommission: String,
    val winningsCommission: String
)