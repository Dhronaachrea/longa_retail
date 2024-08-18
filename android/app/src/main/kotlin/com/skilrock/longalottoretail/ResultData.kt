package com.skilrock.longalottoretail

import com.google.gson.annotations.SerializedName

data class ResultData(
    @SerializedName("drawName")
    val drawName: String,
    @SerializedName("drawTime")
    val drawTime: String,
    @SerializedName("matchInfo")
    val matchInfo: List<MatchInfo>,
    @SerializedName("runTimeFlagInfo")
    val runTimeFlagInfo: Any,
    @SerializedName("sideBetMatchInfo")
    val sideBetMatchInfo: List<SideBetMatchInfo?>?,
    @SerializedName("winningMultiplierInfo")
    val winningMultiplierInfo: WinningMultiplierInfo,
    @SerializedName("winningNo")
    val winningNo: String
) {
    data class MatchInfo(
        @SerializedName("amount")
        val amount: String,
        @SerializedName("match")
        val match: String,
        @SerializedName("mode")
        val mode: String,
        @SerializedName("noOfWinners")
        val noOfWinners: String,
        @SerializedName("prizeRank")
        val prizeRank: Int
    )

    data class SideBetMatchInfo(
        @SerializedName("betCode")
        val betCode: String?,
        @SerializedName("betDisplayName")
        val betDisplayName: String?,
        @SerializedName("pickTypeCode")
        val pickTypeCode: String?,
        @SerializedName("pickTypeName")
        val pickTypeName: String?,
        @SerializedName("rank")
        val rank: Int?,
        @SerializedName("result")
        val result: String?
    )

    data class WinningMultiplierInfo(
        @SerializedName("multiplierCode")
        val multiplierCode: String?,
        @SerializedName("value")
        val value: Double?
    )
}
