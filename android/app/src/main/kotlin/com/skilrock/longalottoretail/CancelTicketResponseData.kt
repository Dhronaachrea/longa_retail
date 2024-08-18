package com.skilrock.longalottoretail

import com.google.gson.annotations.SerializedName

data class CancelTicketResponseData(
    @SerializedName("responseCode")
    val responseCode: Int,
    @SerializedName("responseData")
    val responseData: ResponseData,
    @SerializedName("responseMessage")
    val responseMessage: String
) {
    data class ResponseData(
        @SerializedName("autoCancel")
        val autoCancel: String,
        @SerializedName("cancelChannel")
        val cancelChannel: String,
        @SerializedName("drawData")
        val drawData: List<DrawData>,
        @SerializedName("enginetxid")
        val enginetxid: String,
        @SerializedName("gameCode")
        val gameCode: String,
        @SerializedName("gameName")
        val gameName: String,
        @SerializedName("isPartiallyCancelled")
        val isPartiallyCancelled: Any,
        @SerializedName("merchantreftxnid")
        val merchantreftxnid: String,
        @SerializedName("refundAmount")
        val refundAmount: String,
        @SerializedName("retailerBalance")
        val retailerBalance: String,
        @SerializedName("ticketNo")
        val ticketNo: String
    ) {
        data class DrawData(
            @SerializedName("drawDate")
            val drawDate: String,
            @SerializedName("drawName")
            val drawName: String,
            @SerializedName("drawTime")
            val drawTime: String
        )
    }
}