package com.skilrock.longalottoretail
import com.google.gson.annotations.SerializedName

data class SummarizeReportResponse(
    @SerializedName("responseCode")
    val responseCode: Int?,
    @SerializedName("responseData")
    val responseData: ResponseData?,
    @SerializedName("responseMessage")
    val responseMessage: String?
) {
    data class ResponseData(
        @SerializedName("data")
        val `data`: Data?,
        @SerializedName("message")
        val message: String?,
        @SerializedName("statusCode")
        val statusCode: Int?
    ) {
        data class Data(
            @SerializedName("closingBalance")
            val closingBalance: String?,
            @SerializedName("ledgerData")
            val ledgerData: List<LedgerData?>?,
            @SerializedName("openingBalance")
            val openingBalance: String?,
            @SerializedName("rawClosingBalance")
            val rawClosingBalance: Int?,
            @SerializedName("rawOpeningBalance")
            val rawOpeningBalance: Int?
        ) {
            data class LedgerData(
                @SerializedName("key1")
                val key1: String?,
                @SerializedName("key1Name")
                val key1Name: String?,
                @SerializedName("key2")
                val key2: String?,
                @SerializedName("key2Name")
                val key2Name: String?,
                @SerializedName("netAmount")
                val netAmount: String?,
                @SerializedName("rawNetAmount")
                val rawNetAmount: String?,
                @SerializedName("serviceCode")
                val serviceCode: String?,
                @SerializedName("serviceName")
                val serviceName: String?
            )
        }
    }
}