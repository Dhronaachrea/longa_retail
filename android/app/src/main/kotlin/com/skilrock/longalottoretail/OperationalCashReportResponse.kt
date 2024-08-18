package com.skilrock.longalottoretail

data class OperationalCashReportResponse(
    val gameWiseData: List<GameWiseData>,
    val salesCommision: String,
    val totalCashOnHand: String,
    val totalClaim: String,
    val totalClaimTax: String,
    val totalCommision: String,
    val totalSale: String,
    val winningsCommision: String
) {
    data class GameWiseData(
        val claimTax: String,
        val claims: String,
        val gameName: String,
        val sales: String,
        val salesKeyForInternalUse: Double
    )
}