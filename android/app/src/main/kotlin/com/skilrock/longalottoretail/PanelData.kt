package com.skilrock.longalottoretail


import com.google.gson.annotations.SerializedName

class PanelData : ArrayList<PanelData.PanelDataItem>(){
    data class PanelDataItem(
        @SerializedName("amount")
        val amount: Double,
        @SerializedName("betAmountMultiple")
        val betAmountMultiple: Int,
        @SerializedName("betCode")
        val betCode: String,
        @SerializedName("betName")
        val betName: String,
        @SerializedName("colorCode")
        val colorCode: Any,
        @SerializedName("gameName")
        val gameName: String,
        @SerializedName("isMainBet")
        val isMainBet: Boolean,
        @SerializedName("isQpPreGenerated")
        val isQpPreGenerated: Boolean,
        @SerializedName("isQuickPick")
        val isQuickPick: Boolean,
        @SerializedName("numberOfDraws")
        val numberOfDraws: Int,
        @SerializedName("numberOfLines")
        val numberOfLines: Int,
        @SerializedName("pickCode")
        val pickCode: String,
        @SerializedName("PickConfig")
        val pickConfig: String,
        @SerializedName("pickName")
        val pickName: String,
        @SerializedName("pickedValue")
        val pickedValue: String,
        @SerializedName("selectBetAmount")
        val selectBetAmount: Int,
        @SerializedName("sideBetHeader")
        val sideBetHeader: Any,
        @SerializedName("totalNumber")
        val totalNumber: Any,
        @SerializedName("unitPrice")
        val unitPrice: Double,
        @SerializedName("winMode")
        val winMode: String
    )
}