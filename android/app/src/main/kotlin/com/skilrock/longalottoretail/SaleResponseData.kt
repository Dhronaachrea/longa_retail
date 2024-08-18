package com.skilrock.longalottoretail


import androidx.annotation.Keep
import com.google.gson.annotations.SerializedName

@Keep
data class SaleResponseData(
    @SerializedName("responseCode")
    val responseCode: Int,    @SerializedName("responseData")
    val responseData: ResponseData,
    @SerializedName("responseMessage")
    val responseMessage: String
) {
    data class ResponseData(
        @SerializedName("availableBal")
        val availableBal: String,
        @SerializedName("channel")
        val channel: String,
        @SerializedName("currencyCode")
        val currencyCode: String,
        @SerializedName("drawData")
        val drawData: List<DrawData>,
        @SerializedName("gameCode")
        val gameCode: String,
        @SerializedName("gameId")
        val gameId: Int,
        @SerializedName("gameName")
        val gameName: String,
        @SerializedName("merchantCode")
        val merchantCode: String,
        @SerializedName("noOfDraws")
        val noOfDraws: Int,
        @SerializedName("panelData")
        val panelData: List<PanelData>,
        @SerializedName("partyType")
        val partyType: String,
        @SerializedName("playerPurchaseAmount")
        val playerPurchaseAmount: Double,
        @SerializedName("purchaseTime")
        val purchaseTime: String,
        @SerializedName("ticketExpiry")
        val ticketExpiry: String,
        @SerializedName("ticketNumber")
        val ticketNumber: String,
        @SerializedName("totalPurchaseAmount")
        val totalPurchaseAmount: Double,
        @SerializedName("validationCode")
        val validationCode: String
    ) {
        data class DrawData(
            @SerializedName("drawDate")
            val drawDate: String,
            @SerializedName("drawName")
            val drawName: String,
            @SerializedName("drawTime")
            val drawTime: String
        )

        data class PanelData(
            @SerializedName("betAmountMultiple")
            val betAmountMultiple: Int,
            @SerializedName("betDisplayName")
            val betDisplayName: String,
            @SerializedName("betType")
            val betType: String,
            @SerializedName("numberOfLines")
            val numberOfLines: Int,
            @SerializedName("panelPrice")
            val panelPrice: Double,
            @SerializedName("pickConfig")
            val pickConfig: String,
            @SerializedName("pickDisplayName")
            val pickDisplayName: String,
            @SerializedName("pickType")
            val pickType: String,
            @SerializedName("pickedValues")
            val pickedValues: String,
            @SerializedName("playerPanelPrice")
            val playerPanelPrice: Double,
            @SerializedName("qpPreGenerated")
            val qpPreGenerated: Boolean,
            @SerializedName("quickPick")
            val quickPick: Boolean,
            @SerializedName("unitCost")
            val unitCost: Double
        )
    }
}