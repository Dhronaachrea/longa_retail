package com.skilrock.longalottoretail

import android.annotation.SuppressLint
import android.app.ActivityManager
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.Drawable
import android.os.Build
import android.os.Bundle
import android.os.CountDownTimer
import android.provider.Settings
import android.util.Log
import android.widget.Toast
import android.window.SplashScreenView
import androidx.core.view.WindowCompat
import com.bumptech.glide.Glide
import com.bumptech.glide.request.target.CustomTarget
import com.common.apiutil.CommonException
import com.common.apiutil.TimeoutException
import com.common.apiutil.printer.FontErrorException
import com.common.apiutil.printer.GateOpenException
import com.common.apiutil.printer.LowPowerException
import com.common.apiutil.printer.NoPaperException
import com.common.apiutil.printer.OverHeatException
import com.common.apiutil.printer.PaperCutException
import com.common.apiutil.printer.ThermalPrinter.stop
import com.common.apiutil.printer.UsbThermalPrinter
import com.dcastalia.localappupdate.DownloadApk
import com.google.gson.Gson
import com.sunmi.peripheral.printer.InnerPrinterCallback
import com.sunmi.peripheral.printer.InnerPrinterException
import com.sunmi.peripheral.printer.InnerPrinterManager
import com.sunmi.peripheral.printer.InnerResultCallback
import com.sunmi.peripheral.printer.SunmiPrinterService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.lang.reflect.InvocationTargetException
import java.lang.reflect.Method
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale
import com.common.apiutil.system.SystemApiUtil


class MainActivity : FlutterActivity() {
    private val mChannel = "com.skilrock.longalottoretail/test"
    private val mChannelForPos = "com.skilrock.longalottoretail/notification_panel_swipe"
    private val mChannelForPrint = "com.skilrock.longalottoretail/notification_print"
    private val mChannelForAppUpdate = "com.skilrock.longalottoretail/loader_inner_bg"
    private val mChannelForAppReportPrint = "com.skilrock.longalottoretail/reports_print"
    private val mChannelForAppAfterWithdrawal =
        "com.skilrock.longalottoretail/channel_afterWithdrawal"
    private lateinit var channel: MethodChannel
    private lateinit var channel_pos: MethodChannel
    private lateinit var channel_app_update: MethodChannel
    private lateinit var channel_reports_print: MethodChannel
    private lateinit var channel_afterWithdrawal: MethodChannel
    private lateinit var channel_print: MethodChannel
    private val boldFontEnable = byteArrayOf(0x1B, 0x45, 0x1)
    private val boldFontDisable = byteArrayOf(0x1B, 0x45, 0x0)
    private var mSunmiPrinterService: SunmiPrinterService? = null
    lateinit var downloadController: DownloadController

    private var mDisableClick = false;

    override fun onResume() {
        super.onResume()
        SystemApiUtil(this).showStatusBar()
        //mDisableClick = true
        //stopService(Intent(this@MainActivity, SampleForegroundService::class.java))
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        initializeSunmiPrinter()


        /*Timer().scheduleAtFixedRate(object : TimerTask() {
           override fun run() {
                collapseNow()
            }
        }, 10, 1)*/

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, mChannel)

        channel.setMethodCallHandler { call, result ->
            Log.d("TAg", "configureFlutterEngine: ")
            val argument = call.arguments as Map<*, *>
            val currencyCode = argument["currencyCode"]
            val username = argument["username"]
            val saleResponse = argument["saleResponse"]
            val panelArgData = argument["panelData"]
            val cancelTicketResponse = argument["cancelTicketResponse"]
            val rePrintResponse = argument["rePrint"]
            val resultDataResponse = argument["resultData"]
            val gameName = argument["gameName"]
            val winClaimedResponse = argument["winClaimedResponse"]
            val summarizeReportResponse = argument["summarizeReport"]
            val toAndFromDate = argument["toAndFromDate"]
            val languageCode = argument["languageCode"]
            val resultDate = argument["resultDate"]
            val lastWinningSaleTicketNo = argument["lastWinningSaleTicketNo"]

            //Data for Balance/Invoice Report

            val orgName = argument["orgName"]
            val orgId = argument["orgId"]
            val balanceInvoiceToAndFromDate = argument["toAndFromDate"]
            val balanceInvoiceData = argument["balanceInvoiceData"]
            val reportHeaderName = argument["reportHeaderName"]
            val operationalCashReportData = argument["operationCashReportData"]

            Log.i("TAg", "configureFlutterEngine: >> winClaimedResponse >> $winClaimedResponse")

            android.util.Log.d("TAg", "configureFlutterEngine:username: $username")
            android.util.Log.d(
                "TAg", "configureFlutterEngine to string: ${saleResponse.toString()}"
            )
            android.util.Log.d(
                "TAg", "configureFlutterEngine to string:saleResponse: ${saleResponse.toString()}"
            )
            android.util.Log.d(
                "TAg",
                "configureFlutterEngine to string:cancelTicketResponse: ${cancelTicketResponse.toString()}"
            )
            val saleResponseData =
                Gson().fromJson(saleResponse.toString(), SaleResponseData::class.java)
            android.util.Log.d(
                "TAg",
                "configureFlutterEngine saleResponseData. responseData: ${saleResponseData?.responseData}"
            )
            val panelData = Gson().fromJson(panelArgData.toString(), PanelData::class.java)

            val winClaimedResponseData =
                Gson().fromJson(winClaimedResponse.toString(), WinClaimedResponse::class.java)
            Log.i("TaG", "====================================>${summarizeReportResponse}")
            val summarizeReportResponseData = Gson().fromJson(
                summarizeReportResponse.toString(),
                SummarizeReportResponse::class.java
            )
            val balanceInvoiceResponseReport = Gson().fromJson(
                balanceInvoiceData.toString(),
                BalanceInvoiceReportResponse::class.java
            )
            val cancelTicketResponseData = Gson().fromJson(
                cancelTicketResponse.toString(), CancelTicketResponseData::class.java)

            val operationalCashReport = Gson().fromJson(
                operationalCashReportData.toString(), OperationalCashReportResponse::class.java)

            android.util.Log.d(
                "TAg",
                "configureFlutterEngine cancelTicketResponseData. responseData: ${cancelTicketResponseData?.responseData}"
            )
            android.util.Log.d(
                "TAg",
                "configureFlutterEngine winClaimedResponseData. responseData: ${winClaimedResponseData?.responseData}"
            )
            val resultResponseData =
                Gson().fromJson(resultDataResponse.toString(), ResultData::class.java)

            if (call.method == "buy") {
                val qrCodeHelperObject = QRBarcodeHelper(activity.baseContext)
                qrCodeHelperObject.setContent(saleResponseData.responseData.ticketNumber)

                /*saleResponseData.responseData?.ticketNumber?.let {
                    qrCodeHelperObject.setContent(saleResponseData.responseData.ticketNumber)
                } ?: result.error("-1", "Unable to find printer", "no sunmi or no usb thermal printer")*/

                val bitmap =
                    BitmapFactory.decodeResource(context.resources, R.drawable.longa_lotto_retail)
                val resizedBitmap = Bitmap.createScaledBitmap(bitmap, 280, 70, false)

                mSunmiPrinterService?.run {

                    enterPrinterBuffer(true)
                    setAlignment(1, null)
                    printBitmapCustom(resizedBitmap, 1, null)
                    sendRAWData(boldFontEnable, null)
                    setFontSize(24f, null)
                    printText("\n\n${saleResponseData.responseData.gameName}", null)
                    sendRAWData(boldFontDisable, null)
                    printText(
                        "\n${
                            DrawGameTranslationMapping.getTranslatedDrawGameString(
                                "Purchase Time",
                                languageCode.toString()
                            )
                        }", null
                    )
                    val purchaseDate: String =
                        saleResponseData.responseData.purchaseTime.split(" ")[0]
                    val purchaseTime: String =
                        saleResponseData.responseData.purchaseTime.split(" ")[1]
                    printText(
                        "\n${getFormattedDate(purchaseDate)} ${getFormattedTime(purchaseTime)}",
                        null
                    )
                    printText(
                        "\n${
                            DrawGameTranslationMapping.getTranslatedDrawGameString(
                                "Ticket Number",
                                languageCode.toString()
                            )
                        }", null
                    )
                    printText("\n${saleResponseData.responseData.ticketNumber}", null)
                    printText("\n____________________________", null)
                    printText(
                        "\n${
                            DrawGameTranslationMapping.getTranslatedDrawGameString(
                                "Draw Timing",
                                languageCode.toString()
                            )
                        }", null
                    )
                    for (i in saleResponseData.responseData.drawData) {
                        printText("\n${getFormattedDate(i.drawDate)} ${i.drawTime}", null)
                    }
                    printText("\n____________________________", null)
                    printText(
                        "\n${
                            DrawGameTranslationMapping.getTranslatedDrawGameString(
                                "Bet Details",
                                languageCode.toString()
                            )
                        }", null
                    )
                    var amount = 0.0
                    var numberString: String
                    for (i in 0 until panelData.size) {
                        val isQp =
                            if (saleResponseData.responseData.panelData[i].quickPick) "/QP" else " "
                        if (saleResponseData.responseData.panelData[i].pickConfig.equals(
                                "Number", ignoreCase = true
                            )
                        ) {
                            if (saleResponseData.responseData.panelData[i].pickType.equals(
                                    "Banker", ignoreCase = true
                                )
                            ) {
                                numberString =
                                    saleResponseData.responseData.panelData[i].pickedValues
                                val banker: Array<String> = numberString.split("-").toTypedArray()
                                printText("\nUL - ${banker[0]}", null)
                                printText("\nLL - ${banker[1]}\n", null)
                                if (saleResponseData.responseData.panelData[i].quickPick) {
                                    printColumnsString(
                                        arrayOf(
                                            "${saleResponseData.responseData.panelData[i].betDisplayName}$isQp",
                                            "${(panelData[i].unitPrice * panelData[i].betAmountMultiple * panelData[i].numberOfLines).toInt()} $currencyCode"
                                        ), intArrayOf(
                                            "${saleResponseData.responseData.panelData[i].betDisplayName}$isQp".length,
                                            "${(panelData[i].unitPrice * panelData[i].betAmountMultiple * panelData[i].numberOfLines).toInt()} $currencyCode".length
                                        ), intArrayOf(0, 2), null
                                    )

                                } else {
                                    printColumnsString(
                                        arrayOf(
                                            "${saleResponseData.responseData.panelData[i].pickDisplayName}/${saleResponseData.responseData.panelData[i].betDisplayName}",
                                            "${(panelData[i].unitPrice * panelData[i].betAmountMultiple * panelData[i].numberOfLines).toInt()} $currencyCode"
                                        ), intArrayOf(
                                            "${saleResponseData.responseData.panelData[i].pickDisplayName}/${saleResponseData.responseData.panelData[i].betDisplayName}".length,
                                            "${(panelData[i].unitPrice * panelData[i].betAmountMultiple * panelData[i].numberOfLines).toInt()} $currencyCode".length
                                        ), intArrayOf(0, 2), null
                                    )

                                }
                                /*printColumnsString(
                                    arrayOf("No of lines", "${panelData[i].numberOfLines}"),
                                    intArrayOf(
                                        "No of lines".length, "${panelData[i].numberOfLines}".length
                                    ),
                                    intArrayOf(0, 2),
                                    null
                                )*/

                                printText("\n----------------------------", null)
                                amount += panelData[i].unitPrice * panelData[i].betAmountMultiple * panelData[i].numberOfLines

                            } else {
                                printText("\n${panelData[i].pickedValue}\n", null)
                                if (saleResponseData.responseData.panelData[i].quickPick) {
                                    printColumnsString(
                                        arrayOf(
                                            "${saleResponseData.responseData.panelData[i].betDisplayName}$isQp",
                                            "${(panelData[i].unitPrice * panelData[i].betAmountMultiple * panelData[i].numberOfLines).toInt()} $currencyCode"
                                        ), intArrayOf(
                                            "${saleResponseData.responseData.panelData[i].betDisplayName}$isQp".length,
                                            "${(panelData[i].unitPrice * panelData[i].betAmountMultiple * panelData[i].numberOfLines).toInt()} $currencyCode".length
                                        ), intArrayOf(0, 2), null
                                    )

                                } else {
                                    printColumnsString(
                                        arrayOf(
                                            "${saleResponseData.responseData.panelData[i].pickDisplayName}/${saleResponseData.responseData.panelData[i].betDisplayName}",
                                            "${(panelData[i].unitPrice * panelData[i].betAmountMultiple * panelData[i].numberOfLines).toInt()} $currencyCode"
                                        ), intArrayOf(
                                            "${saleResponseData.responseData.panelData[i].pickDisplayName}/${saleResponseData.responseData.panelData[i].betDisplayName}".length,
                                            "${(panelData[i].unitPrice * panelData[i].betAmountMultiple * panelData[i].numberOfLines).toInt()} $currencyCode".length
                                        ), intArrayOf(0, 2), null
                                    )

                                }
                                /*printColumnsString(
                                    arrayOf("No of lines", "${panelData[i].numberOfLines}"),
                                    intArrayOf(
                                        "No of lines".length, "${panelData[i].numberOfLines}".length
                                    ),
                                    intArrayOf(0, 2),
                                    null
                                )*/
                                printText("\n----------------------------", null)
                                amount += panelData[i].unitPrice * panelData[i].betAmountMultiple * panelData[i].numberOfLines
                            }

                        } else if (saleResponseData.responseData.panelData[i].pickConfig.equals(
                                "Market", ignoreCase = true
                            )
                        ) {
                            printText(
                                "\n${saleResponseData.responseData.panelData[i].betDisplayName}\n",
                                null
                            )
                            printColumnsString(
                                arrayOf(
                                    saleResponseData.responseData.panelData[i].pickDisplayName,
                                    "${(panelData[i].unitPrice * panelData[i].betAmountMultiple * panelData[i].numberOfLines).toInt()} $currencyCode"
                                ), intArrayOf(
                                    saleResponseData.responseData.panelData[i].pickDisplayName.length,
                                    "${(panelData[i].unitPrice * panelData[i].betAmountMultiple * panelData[i].numberOfLines).toInt()} $currencyCode".length
                                ), intArrayOf(0, 2), null
                            )
                            /*printColumnsString(
                                arrayOf("No of lines", "${panelData[i].numberOfLines}"), intArrayOf(
                                    "No of lines".length, "${panelData[i].numberOfLines}".length
                                ), intArrayOf(0, 2), null
                            )*/
                            printText("\n----------------------------", null)
                            amount += panelData[i].unitPrice * panelData[i].betAmountMultiple * panelData[i].numberOfLines
                        }
                    }
                    printText(
                        "\n${
                            DrawGameTranslationMapping.getTranslatedDrawGameString(
                                "Amount",
                                languageCode.toString()
                            )
                        }                  ${amount.toInt()}", null
                    )
                    printText(
                        "\n${
                            DrawGameTranslationMapping.getTranslatedDrawGameString(
                                "No of Draws(s)",
                                languageCode.toString()
                            )
                        }              ${saleResponseData.responseData.drawData.size}",
                        null
                    )
                    sendRAWData(boldFontEnable, null)
                    printText(
                        "\n${
                            DrawGameTranslationMapping.getTranslatedDrawGameString(
                                "TOTAL AMOUNT",
                                languageCode.toString()
                            )
                        }         ${saleResponseData.responseData.totalPurchaseAmount.toInt()} $currencyCode\n\n",
                        null
                    )
                    printBitmapCustom(qrCodeHelperObject.qrcOde, 1, null)
                    sendRAWData(boldFontDisable, null)
                    printText("\n${saleResponseData.responseData.ticketNumber}", null)
                    printText("\n\n$username", null)
                    printText(
                        "\n${
                            DrawGameTranslationMapping.getTranslatedDrawGameString(
                                "Ticket Validity",
                                languageCode.toString()
                            )
                        }: ${saleResponseData.responseData.ticketExpiry}\n\n", null
                    )
                    exitPrinterBufferWithCallback(true, object : InnerResultCallback() {
                        override fun onRunResult(isSuccess: Boolean) {}

                        override fun onReturnString(result: String?) {}

                        override fun onRaiseException(code: Int, msg: String?) {
                            activity.runOnUiThread {
                                Toast.makeText(
                                    activity,
                                    "Something went wrong while printing, Please try again",
                                    Toast.LENGTH_SHORT
                                ).show()
                            }
                            result.error("-1", msg, "Something went wrong while printing")
                        }

                        override fun onPrintResult(code: Int, msg: String?) {
                            if (updatePrinterState() != 1) {
                                activity.runOnUiThread {
                                    Toast.makeText(
                                        activity,
                                        "Something went wrong while printing, Please try again",
                                        Toast.LENGTH_SHORT
                                    ).show()
                                }
                                result.error("-1", msg, "Something went wrong while printing")

                            } else {
                                activity.runOnUiThread {
                                    Toast.makeText(
                                        activity,
                                        DrawGameTranslationMapping.getTranslatedDrawGameString(
                                            "Successfully printed",
                                            languageCode.toString()
                                        ),
                                        Toast.LENGTH_SHORT
                                    ).show()
                                }
                                result.success(true)
                            }
                        }
                    })
                } ?: this.let {
                    val usbThermalPrinter = UsbThermalPrinter(activity.baseContext)
                    if (getDeviceName() == "QUALCOMM M1" || getDeviceModelName()=="m1k_go") {
                        usbThermalPrinter.run {
                            try {
                                reset()
                                start(1)
                                setTextSize(28)
                                addString("")
                                setBold(true)
                                setGray(1)
                                setAlgin(1)
                                printLogo(resizedBitmap, true)
                                addString(saleResponseData.responseData.gameName)
                                setTextSize(22)
                                val purchaseDate: String =
                                    saleResponseData.responseData.purchaseTime.split(" ")[0]
                                val purchaseTime: String =
                                    saleResponseData.responseData.purchaseTime.split(" ")[1]
                                setItalic(true)
                                setBold(false)
                                addString(
                                    DrawGameTranslationMapping.getTranslatedDrawGameString(
                                        "Purchase Time",
                                        languageCode.toString()
                                    )
                                )
                                setItalic(false)
                                setBold(true)
                                setTextSize(24)
                                addString(
                                    "${getFormattedDate(purchaseDate)} ${
                                        getFormattedTime(
                                            purchaseTime
                                        )
                                    }"
                                )
                                setBold(false)
                                addString(printLineStringData(getPaperLength()))
                                setItalic(true)
                                setTextSize(22)
                                addString(
                                    DrawGameTranslationMapping.getTranslatedDrawGameString(
                                        "Ticket Number",
                                        languageCode.toString()
                                    )
                                )
                                setItalic(false)
                                setBold(true)
                                setTextSize(24)
                                addString(saleResponseData.responseData.ticketNumber)
                                setBold(false)
                                addString(printLineStringData(getPaperLength()))
                                setItalic(true)
                                setTextSize(22)
                                addString(
                                    DrawGameTranslationMapping.getTranslatedDrawGameString(
                                        "Draw Timing",
                                        languageCode.toString()
                                    )
                                )
                                setItalic(false)
                                setBold(true)
                                setTextSize(24)
                                for (i in saleResponseData.responseData.drawData) {
                                    addString("${getFormattedDate(i.drawDate)} ${i.drawTime}")

                                }
                                setBold(false)
                                addString(printLineStringData(getPaperLength()))
                                setItalic(true)
                                setTextSize(22)
                                addString(
                                    DrawGameTranslationMapping.getTranslatedDrawGameString(
                                        "Bet Details",
                                        languageCode.toString()
                                    )
                                )
                                setItalic(false)
                                setBold(true)
                                setTextSize(24)
                                var amount = 0.0
                                var numberString: String
                                for (i in 0 until panelData.size) {
                                    val isQp =
                                        if (saleResponseData.responseData.panelData[i].quickPick) "/QP" else " "
                                    if (saleResponseData.responseData.panelData[i].pickConfig.equals(
                                            "Number", ignoreCase = true
                                        )
                                    ) {
                                        if (saleResponseData.responseData.panelData[i].pickType.equals(
                                                "Banker", ignoreCase = true
                                            )
                                        ) {
                                            numberString =
                                                saleResponseData.responseData.panelData[i].pickedValues
                                            val banker: Array<String> =
                                                numberString.split("-").toTypedArray()

                                            addString("UL - ${banker[0]}")
                                            addString("LL - ${banker[1]}")
                                            if (saleResponseData.responseData.panelData[i].quickPick) {
                                                addString(
                                                    printTwoStringStringData(
                                                        "${saleResponseData.responseData.panelData[i].betDisplayName}$isQp",
                                                        "${(panelData[i].unitPrice * panelData[i].betAmountMultiple * panelData[i].numberOfLines).toInt()} $currencyCode"
                                                    )
                                                )

                                            } else {
                                                addString(
                                                    printTwoStringStringData(
                                                        "${
                                                            DrawGameTranslationMapping.getTranslatedDrawGameString(
                                                                "${saleResponseData.responseData.panelData[i].pickDisplayName}",
                                                                languageCode.toString()
                                                            )
                                                        }/${saleResponseData.responseData.panelData[i].betDisplayName}",
                                                        "${(panelData[i].unitPrice * panelData[i].betAmountMultiple * panelData[i].numberOfLines).toInt()} $currencyCode"
                                                    )
                                                )

                                            }
                                            /*addString(
                                                printTwoStringStringData(
                                                    "No of lines", "${panelData[i].numberOfLines}"
                                                )
                                            )*/
                                            addString(printDashStringData(getPaperLength()))
                                            amount += panelData[i].unitPrice * panelData[i].betAmountMultiple * panelData[i].numberOfLines

                                        } else {
                                            addString(panelData[i].pickedValue)
                                            if (saleResponseData.responseData.panelData[i].quickPick) {
                                                addString(
                                                    printTwoStringStringData(
                                                        "${saleResponseData.responseData.panelData[i].betDisplayName}$isQp",
                                                        "${(panelData[i].unitPrice * panelData[i].betAmountMultiple * panelData[i].numberOfLines).toInt()} $currencyCode"
                                                    )
                                                )

                                            } else {
                                                addString(
                                                    printTwoStringStringData(
                                                        "${
                                                            DrawGameTranslationMapping.getTranslatedDrawGameString(
                                                                "${saleResponseData.responseData.panelData[i].pickDisplayName}",
                                                                languageCode.toString()
                                                            )
                                                        }/${saleResponseData.responseData.panelData[i].betDisplayName}",
                                                        "${(panelData[i].unitPrice * panelData[i].betAmountMultiple * panelData[i].numberOfLines).toInt()} $currencyCode"
                                                    )
                                                )

                                            }
                                            /*addString(
                                                printTwoStringStringData(
                                                    "No of lines", "${panelData[i].numberOfLines}"
                                                )
                                            )*/
                                            if (i != panelData.size - 1) addString(
                                                printDashStringData(getPaperLength())
                                            )
                                            amount += panelData[i].unitPrice * panelData[i].betAmountMultiple * panelData[i].numberOfLines
                                        }

                                    } else if (saleResponseData.responseData.panelData[i].pickConfig.equals(
                                            "Market", ignoreCase = true
                                        )
                                    ) {
                                        addString(saleResponseData.responseData.panelData[i].betDisplayName)
                                        addString(
                                            printTwoStringStringData(
                                                "${
                                                    DrawGameTranslationMapping.getTranslatedDrawGameString(
                                                        "${saleResponseData.responseData.panelData[i].pickDisplayName}",
                                                        languageCode.toString()
                                                    )
                                                }",
                                                "${(panelData[i].unitPrice * panelData[i].betAmountMultiple * panelData[i].numberOfLines).toInt()} $currencyCode"
                                            )
                                        )
                                        /*addString(
                                            printTwoStringStringData(
                                                "No of lines", "${panelData[i].numberOfLines}"
                                            )
                                        )*/
                                        if (i != panelData.size - 1) addString(
                                            printDashStringData(
                                                getPaperLength()
                                            )
                                        )
                                        amount += panelData[i].unitPrice * panelData[i].betAmountMultiple * panelData[i].numberOfLines
                                    }
                                }
                                setBold(true)
                                addString(printLineStringData(getPaperLength()))
                                setTextSize(24)
                                addString(
                                    printTwoStringStringData(
                                        DrawGameTranslationMapping.getTranslatedDrawGameString(
                                            "Amount",
                                            languageCode.toString()
                                        ), "${amount.toInt()}"
                                    )
                                )
                                addString(
                                    printTwoStringStringData(
                                        DrawGameTranslationMapping.getTranslatedDrawGameString(
                                            "No of Draws(s)",
                                            languageCode.toString()
                                        ), "${saleResponseData.responseData.drawData.size}"
                                    )
                                )
                                addString(printDashStringData(getPaperLength()))
                                addString(
                                    printTwoStringStringData(
                                        DrawGameTranslationMapping.getTranslatedDrawGameString(
                                            "TOTAL AMOUNT",
                                            languageCode.toString()
                                        ),
                                        "${saleResponseData.responseData.totalPurchaseAmount.toInt()} $currencyCode"
                                    )
                                )
                                addString(" ")
                                printLogo(qrCodeHelperObject.qrcOde, true)
                                addString(saleResponseData.responseData.ticketNumber)
                                addString(" ")
                                addString("$username")
                                addString(
                                    "${
                                        DrawGameTranslationMapping.getTranslatedDrawGameString(
                                            "Ticket Validity",
                                            languageCode.toString()
                                        )
                                    }: ${saleResponseData.responseData.ticketExpiry}"
                                )
                                addString("\n\n")
                                printString()
                                activity.runOnUiThread {
                                    Toast.makeText(
                                        activity,
                                        DrawGameTranslationMapping.getTranslatedDrawGameString(
                                            "Successfully printed",
                                            languageCode.toString()
                                        ),
                                        Toast.LENGTH_SHORT
                                    ).show()
                                }
                                result.success(true)

                            } catch (e: java.lang.Exception) {
                                showMsgAccordingToException(e as CommonException, result)
                                stop()
                                e.printStackTrace()
                            }
                        }

                    } else {
                        android.util.Log.d("TAg", "configureFlutterEngine: no printer")
                        result.error(
                            "-1", "Unable to find printer", "no sunmi or no usb thermal printer"
                        )
                    }
                }
            }
            else if (call.method == "dgeCancelTicket") {
                android.util.Log.i("TAg", "configureFlutterEngine: dgeCancelTicket")
                val bitmap =
                    BitmapFactory.decodeResource(context.resources, R.drawable.longa_lotto_retail)
                val resizedBitmap = Bitmap.createScaledBitmap(bitmap, 280, 70, false)

                mSunmiPrinterService?.run {

                    enterPrinterBuffer(true)
                    setAlignment(1, null)
                    printBitmapCustom(resizedBitmap, 1, null)// logo
                    sendRAWData(boldFontEnable, null)
                    setFontSize(24f, null)
                    printText("\n\n${cancelTicketResponseData.responseData.gameName}", null)
                    sendRAWData(boldFontDisable, null)
                    printText("\nTicket Number", null)
                    printText("\n${cancelTicketResponseData.responseData.ticketNo}", null)
                    printText("\n____________________________\n", null)
                    sendRAWData(boldFontEnable, null)
                    printText("Ticket Cancelled\n", null)
                    sendRAWData(boldFontDisable, null)
                    printColumnsString(
                        arrayOf<String>(
                            "Refund Amount :",
                            "${cancelTicketResponseData.responseData.refundAmount.toDouble().toInt()} ${currencyCode}"
                        ), intArrayOf(
                            "Refund Amount :".length,
                            "${cancelTicketResponseData.responseData.refundAmount.toDouble().toInt()} ${currencyCode}".length
                        ), intArrayOf(0, 2), null
                    )
                    printText("\n\n$username\n\n", null)
                    exitPrinterBufferWithCallback(true, object : InnerResultCallback() {
                        override fun onRunResult(isSuccess: Boolean) {}

                        override fun onReturnString(result: String?) {}

                        override fun onRaiseException(code: Int, msg: String?) {
                            activity.runOnUiThread {
                                Toast.makeText(
                                    activity,
                                    "Something went wrong while printing, Please try again",
                                    Toast.LENGTH_SHORT
                                ).show()
                            }
                            result.error("-1", msg, "Something went wrong while printing")
                        }

                        override fun onPrintResult(code: Int, msg: String?) {
                            if (updatePrinterState() != 1) {
                                activity.runOnUiThread {
                                    Toast.makeText(
                                        activity,
                                        "Something went wrong while printing, Please try again",
                                        Toast.LENGTH_SHORT
                                    ).show()
                                }
                                result.error("-1", msg, "Something went wrong while printing")

                            } else {
                                activity.runOnUiThread {
                                    Toast.makeText(
                                        activity,
                                        DrawGameTranslationMapping.getTranslatedDrawGameString(
                                            "Successfully printed",
                                            languageCode.toString()
                                        ),
                                        Toast.LENGTH_SHORT
                                    ).show()
                                }
                                result.success(true)
                            }
                        }
                    })
                } ?: this.let {
                    val usbThermalPrinter = UsbThermalPrinter(activity.baseContext)
                    if (getDeviceName() == "QUALCOMM M1" || getDeviceModelName()=="m1k_go") {
                        usbThermalPrinter.run {
                            try {
                                reset()
                                start(1)
                                setTextSize(28)
                                addString("")
                                setBold(true)
                                setGray(1)
                                setAlgin(1)
                                printLogo(resizedBitmap, true)
                                addString(cancelTicketResponseData.responseData.gameName)
                                setItalic(true)
                                setTextSize(22)
                                addString(
                                    DrawGameTranslationMapping.getTranslatedDrawGameString(
                                        "Ticket Number",
                                        languageCode.toString()
                                    )
                                )
                                setItalic(false)
                                setBold(true)
                                setTextSize(24)
                                addString(cancelTicketResponseData.responseData.ticketNo)
                                setBold(true)
                                addString(printLineStringData(getPaperLength()))
                                setTextSize(24)
                                addString(
                                    DrawGameTranslationMapping.getTranslatedDrawGameString(
                                        "Ticket Cancelled",
                                        languageCode.toString()
                                    )
                                )
                                setBold(false)
                                addString(
                                    printTwoStringStringData(
                                        "${
                                            DrawGameTranslationMapping.getTranslatedDrawGameString(
                                                "Refund Amount",
                                                languageCode.toString()
                                            )
                                        } :",
                                        "${cancelTicketResponseData.responseData.refundAmount.toDouble().toInt()} ${currencyCode}"
                                    )
                                )
                                addString("\n\n")
                                printString()
                                activity.runOnUiThread {
                                    Toast.makeText(
                                        activity,
                                        DrawGameTranslationMapping.getTranslatedDrawGameString(
                                            "Successfully printed",
                                            languageCode.toString()
                                        ),
                                        Toast.LENGTH_SHORT
                                    ).show()
                                }
                                result.success(true)

                            } catch (e: java.lang.Exception) {
                                showMsgAccordingToException(e as CommonException, result)
                                stop()
                                e.printStackTrace()
                            }
                        }

                    } else {
                        result.error(
                            "-1", "Unable to find printer", "no sunmi or no usb thermal printer"
                        )
                    }
                }
            }

            else if (call.method == "dgeReprint") {
                val qrCodeHelperObject = QRBarcodeHelper(activity.baseContext)
                qrCodeHelperObject.setContent(saleResponseData.responseData.ticketNumber)
                val bitmap =
                    BitmapFactory.decodeResource(context.resources, R.drawable.longa_lotto_retail)
                val resizedBitmap = Bitmap.createScaledBitmap(bitmap, 280, 70, false)

                mSunmiPrinterService?.run {

                    enterPrinterBuffer(true)
                    setAlignment(1, null)
                    printBitmapCustom(resizedBitmap, 1, null)
                    sendRAWData(boldFontEnable, null)
                    setFontSize(24f, null)
                    printText("\n\n${saleResponseData.responseData.gameName}", null)
                    sendRAWData(boldFontDisable, null)
                    printText("\nPurchase Time", null)
                    val purchaseDate: String =
                        saleResponseData.responseData.purchaseTime.split(" ")[0]
                    val purchaseTime: String =
                        saleResponseData.responseData.purchaseTime.split(" ")[1]
                    printText(
                        "\n${getFormattedDate(purchaseDate)} ${getFormattedTime(purchaseTime)}",
                        null
                    )
                    printText("\nTicket Number", null)
                    printText("\n${saleResponseData.responseData.ticketNumber}", null)
                    printText("\n____________________________", null)
                    printText("\nDraw Timing", null)
                    for (i in saleResponseData.responseData.drawData) {
                        printText("\n${getFormattedDate(i.drawDate)} ${i.drawTime}", null)
                    }
                    printText("\n____________________________", null)
                    printText("\nBet Details", null)
                    var amount = 0.0
                    var numberString: String
                    for (i in 0 until panelData.size) {
                        val isQp =
                            if (saleResponseData.responseData.panelData[i].quickPick) "/QP" else " "
                        if (saleResponseData.responseData.panelData[i].pickConfig.equals(
                                "Number", ignoreCase = true
                            )
                        ) {
                            if (saleResponseData.responseData.panelData[i].pickType.equals(
                                    "Banker", ignoreCase = true
                                )
                            ) {
                                numberString =
                                    saleResponseData.responseData.panelData[i].pickedValues
                                val banker: Array<String> = numberString.split("-").toTypedArray()
                                printText("\nUL - ${banker[0]}", null)
                                printText("\nLL - ${banker[1]}\n", null)
                                if (saleResponseData.responseData.panelData[i].quickPick) {
                                    printColumnsString(
                                        arrayOf(
                                            "${saleResponseData.responseData.panelData[i].betDisplayName}$isQp",
                                            "${(saleResponseData.responseData.panelData[i].unitCost * saleResponseData.responseData.panelData[i].betAmountMultiple * saleResponseData.responseData.panelData[i].numberOfLines).toInt()} $currencyCode"
                                        ), intArrayOf(
                                            "${saleResponseData.responseData.panelData[i].betDisplayName}$isQp".length,
                                            "${(saleResponseData.responseData.panelData[i].unitCost * saleResponseData.responseData.panelData[i].betAmountMultiple * saleResponseData.responseData.panelData[i].numberOfLines).toInt()} $currencyCode".length
                                        ), intArrayOf(0, 2), null
                                    )

                                } else {
                                    printColumnsString(
                                        arrayOf(
                                            "${saleResponseData.responseData.panelData[i].pickDisplayName}/${saleResponseData.responseData.panelData[i].betDisplayName}",
                                            "${(saleResponseData.responseData.panelData[i].unitCost * saleResponseData.responseData.panelData[i].betAmountMultiple * saleResponseData.responseData.panelData[i].numberOfLines).toInt()} $currencyCode"
                                        ), intArrayOf(
                                            "${saleResponseData.responseData.panelData[i].pickDisplayName}/${saleResponseData.responseData.panelData[i].betDisplayName}".length,
                                            "${(saleResponseData.responseData.panelData[i].unitCost * saleResponseData.responseData.panelData[i].betAmountMultiple * saleResponseData.responseData.panelData[i].numberOfLines).toInt()} $currencyCode".length
                                        ), intArrayOf(0, 2), null
                                    )
                                }
                                /*printColumnsString(
                                    arrayOf("No of lines", "${panelData[i].numberOfLines}"),
                                    intArrayOf(
                                        "No of lines".length, "${panelData[i].numberOfLines}".length
                                    ),
                                    intArrayOf(0, 2),
                                    null
                                )*/

                                printText("\n----------------------------", null)
                                amount += saleResponseData.responseData.panelData[i].unitCost.toInt() * saleResponseData.responseData.panelData[i].betAmountMultiple * saleResponseData.responseData.panelData[i].numberOfLines

                            } else {
                                printText(
                                    "\n${saleResponseData.responseData.panelData[i].pickedValues}\n",
                                    null
                                )
                                if (saleResponseData.responseData.panelData[i].quickPick) {
                                    printColumnsString(
                                        arrayOf(
                                            "${saleResponseData.responseData.panelData[i].betDisplayName}$isQp",
                                            "${(saleResponseData.responseData.panelData[i].unitCost * saleResponseData.responseData.panelData[i].betAmountMultiple * saleResponseData.responseData.panelData[i].numberOfLines).toInt()} $currencyCode"
                                        ), intArrayOf(
                                            "${saleResponseData.responseData.panelData[i].betDisplayName}$isQp".length,
                                            "${(saleResponseData.responseData.panelData[i].unitCost * saleResponseData.responseData.panelData[i].betAmountMultiple * saleResponseData.responseData.panelData[i].numberOfLines).toInt()} $currencyCode".length
                                        ), intArrayOf(0, 2), null
                                    )

                                } else {
                                    printColumnsString(
                                        arrayOf(
                                            "${saleResponseData.responseData.panelData[i].pickDisplayName}/${saleResponseData.responseData.panelData[i].betDisplayName}",
                                            "${(saleResponseData.responseData.panelData[i].unitCost * saleResponseData.responseData.panelData[i].betAmountMultiple * saleResponseData.responseData.panelData[i].numberOfLines).toInt()} $currencyCode"
                                        ), intArrayOf(
                                            "${saleResponseData.responseData.panelData[i].pickDisplayName}/${saleResponseData.responseData.panelData[i].betDisplayName}".length,
                                            "${(saleResponseData.responseData.panelData[i].unitCost * saleResponseData.responseData.panelData[i].betAmountMultiple * saleResponseData.responseData.panelData[i].numberOfLines).toInt()} $currencyCode".length
                                        ), intArrayOf(0, 2), null
                                    )

                                }
                                /*printColumnsString(
                                    arrayOf(
                                        "No of lines",
                                        "${saleResponseData.responseData.panelData[i].numberOfLines}"
                                    ), intArrayOf(
                                        "No of lines".length,
                                        "${saleResponseData.responseData.panelData[i].numberOfLines}".length
                                    ), intArrayOf(0, 2), null
                                )*/
                                printText("\n----------------------------", null)
                                amount += saleResponseData.responseData.panelData[i].unitCost.toInt() * saleResponseData.responseData.panelData[i].betAmountMultiple * saleResponseData.responseData.panelData[i].numberOfLines
                            }

                        } else if (saleResponseData.responseData.panelData[i].pickConfig.equals(
                                "Market", ignoreCase = true
                            )
                        ) {
                            printText(
                                "\n${saleResponseData.responseData.panelData[i].betDisplayName}\n",
                                null
                            )
                            printColumnsString(
                                arrayOf(
                                    saleResponseData.responseData.panelData[i].pickDisplayName,
                                    "${(saleResponseData.responseData.panelData[i].unitCost * saleResponseData.responseData.panelData[i].betAmountMultiple * saleResponseData.responseData.panelData[i].numberOfLines).toInt()} $currencyCode"
                                ), intArrayOf(
                                    saleResponseData.responseData.panelData[i].pickDisplayName.length,
                                    "${(saleResponseData.responseData.panelData[i].unitCost * saleResponseData.responseData.panelData[i].betAmountMultiple * saleResponseData.responseData.panelData[i].numberOfLines).toInt()} $currencyCode".length
                                ), intArrayOf(0, 2), null
                            )
                            /*printColumnsString(
                                arrayOf(
                                    "No of lines",
                                    "${saleResponseData.responseData.panelData[i].numberOfLines}"
                                ), intArrayOf(
                                    "No of lines".length,
                                    "${saleResponseData.responseData.panelData[i].numberOfLines}".length
                                ), intArrayOf(0, 2), null
                            )*/
                            printText("\n----------------------------", null)
                            amount += saleResponseData.responseData.panelData[i].unitCost.toInt() * saleResponseData.responseData.panelData[i].betAmountMultiple * saleResponseData.responseData.panelData[i].numberOfLines
                        }
                    }
                    printText("\nAmount                  ${amount.toInt()}", null)
                    printText(
                        "\nNo of Draws(s)              ${saleResponseData.responseData.drawData.size}",
                        null
                    )
                    sendRAWData(boldFontEnable, null)
                    printText(
                        "\nTOTAL AMOUNT         ${saleResponseData.responseData.totalPurchaseAmount.toInt()} $currencyCode\n\n",
                        null
                    )
                    printBitmapCustom(qrCodeHelperObject.qrcOde, 1, null)
                    sendRAWData(boldFontDisable, null)
                    printText("\n${saleResponseData.responseData.ticketNumber}", null)
                    printText("\n\n$username", null)
                    printText(
                        "\nTicket Validity: ${saleResponseData.responseData.ticketExpiry}\n\n", null
                    )
                    exitPrinterBufferWithCallback(true, object : InnerResultCallback() {
                        override fun onRunResult(isSuccess: Boolean) {}

                        override fun onReturnString(result: String?) {}

                        override fun onRaiseException(code: Int, msg: String?) {
                            activity.runOnUiThread {
                                Toast.makeText(
                                    activity,
                                    "Something went wrong while printing, Please try again",
                                    Toast.LENGTH_SHORT
                                ).show()
                            }
                            result.error("-1", msg, "Something went wrong while printing")
                        }

                        override fun onPrintResult(code: Int, msg: String?) {
                            if (updatePrinterState() != 1) {
                                activity.runOnUiThread {
                                    Toast.makeText(
                                        activity,
                                        "Something went wrong while printing, Please try again",
                                        Toast.LENGTH_SHORT
                                    ).show()
                                }
                                result.error("-1", msg, "Something went wrong while printing")

                            } else {
                                activity.runOnUiThread {
                                    Toast.makeText(
                                        activity,
                                        DrawGameTranslationMapping.getTranslatedDrawGameString(
                                            "Successfully printed",
                                            languageCode.toString()
                                        ),
                                        Toast.LENGTH_SHORT
                                    ).show()
                                }
                                result.success(true)
                            }
                        }
                    })
                } ?: this.let {
                    val usbThermalPrinter = UsbThermalPrinter(activity.baseContext)
                    if (getDeviceName() == "QUALCOMM M1" || getDeviceModelName()=="m1k_go") {
                        usbThermalPrinter.run {
                            try {
                                reset()
                                start(1)
                                setTextSize(28)
                                addString("")
                                setBold(true)
                                setGray(1)
                                setAlgin(1)
                                printLogo(resizedBitmap, true)
                                addString(saleResponseData.responseData.gameName)
                                setTextSize(22)
                                val purchaseDate: String =
                                    saleResponseData.responseData.purchaseTime.split(" ")[0]
                                val purchaseTime: String =
                                    saleResponseData.responseData.purchaseTime.split(" ")[1]
                                setItalic(true)
                                setBold(false)
                                addString(
                                    DrawGameTranslationMapping.getTranslatedDrawGameString(
                                        "Purchase Time",
                                        languageCode.toString()
                                    )
                                )
                                setItalic(false)
                                setBold(true)
                                setTextSize(24)
                                addString(
                                    "${getFormattedDate(purchaseDate)} ${
                                        getFormattedTime(
                                            purchaseTime
                                        )
                                    }"
                                )
                                setBold(false)
                                addString(printLineStringData(getPaperLength()))
                                setItalic(true)
                                setTextSize(22)
                                addString(
                                    DrawGameTranslationMapping.getTranslatedDrawGameString(
                                        "Ticket Number",
                                        languageCode.toString()
                                    )
                                )
                                setItalic(false)
                                setBold(true)
                                setTextSize(24)
                                addString(saleResponseData.responseData.ticketNumber)
                                setBold(false)
                                addString(printLineStringData(getPaperLength()))
                                setItalic(true)
                                setTextSize(22)
                                addString(
                                    DrawGameTranslationMapping.getTranslatedDrawGameString(
                                        "Draw Timing",
                                        languageCode.toString()
                                    )
                                )
                                setItalic(false)
                                setBold(true)
                                setTextSize(24)
                                for (i in saleResponseData.responseData.drawData) {
                                    addString("${getFormattedDate(i.drawDate)} ${i.drawTime}")

                                }
                                setBold(false)
                                addString(printLineStringData(getPaperLength()))
                                setItalic(true)
                                setTextSize(22)
                                addString(
                                    DrawGameTranslationMapping.getTranslatedDrawGameString(
                                        "Bet Details",
                                        languageCode.toString()
                                    )
                                )
                                setItalic(false)
                                setBold(true)
                                setTextSize(24)
                                var amount = 0.0
                                var numberString: String
                                for (i in 0 until panelData.size) {
                                    val isQp =
                                        if (saleResponseData.responseData.panelData[i].quickPick) "/QP" else " "
                                    if (saleResponseData.responseData.panelData[i].pickConfig.equals(
                                            "Number", ignoreCase = true
                                        )
                                    ) {
                                        if (saleResponseData.responseData.panelData[i].pickType.equals(
                                                "Banker", ignoreCase = true
                                            )
                                        ) {
                                            numberString =
                                                saleResponseData.responseData.panelData[i].pickedValues
                                            val banker: Array<String> =
                                                numberString.split("-").toTypedArray()

                                            addString("UL - ${banker[0]}")
                                            addString("LL - ${banker[1]}")
                                            if (saleResponseData.responseData.panelData[i].quickPick) {
                                                addString(
                                                    printTwoStringStringData(
                                                        "${saleResponseData.responseData.panelData[i].betDisplayName}$isQp",
                                                        "${(saleResponseData.responseData.panelData[i].unitCost * saleResponseData.responseData.panelData[i].betAmountMultiple * saleResponseData.responseData.panelData[i].numberOfLines).toInt()} $currencyCode"
                                                    )
                                                )

                                            } else {
                                                addString(
                                                    printTwoStringStringData(
                                                        "${
                                                            DrawGameTranslationMapping.getTranslatedDrawGameString(
                                                                "${saleResponseData.responseData.panelData[i].pickDisplayName}",
                                                                languageCode.toString()
                                                            )
                                                        }/${saleResponseData.responseData.panelData[i].betDisplayName}",
                                                        "${(saleResponseData.responseData.panelData[i].unitCost * saleResponseData.responseData.panelData[i].betAmountMultiple * saleResponseData.responseData.panelData[i].numberOfLines).toInt()} $currencyCode"
                                                    )
                                                )

                                            }
                                            /*addString(
                                                printTwoStringStringData(
                                                    "No of lines",
                                                    "${saleResponseData.responseData.panelData[i].numberOfLines}"
                                                )
                                            )*/
                                            addString(printDashStringData(getPaperLength()))
                                            amount += saleResponseData.responseData.panelData[i].unitCost.toInt() * saleResponseData.responseData.panelData[i].betAmountMultiple * saleResponseData.responseData.panelData[i].numberOfLines

                                        } else {
                                            addString(saleResponseData.responseData.panelData[i].pickedValues)
                                            if (saleResponseData.responseData.panelData[i].quickPick) {
                                                addString(
                                                    printTwoStringStringData(
                                                        "${saleResponseData.responseData.panelData[i].betDisplayName}$isQp",
                                                        "${(saleResponseData.responseData.panelData[i].unitCost * saleResponseData.responseData.panelData[i].betAmountMultiple * saleResponseData.responseData.panelData[i].numberOfLines).toInt()} $currencyCode"
                                                    )
                                                )

                                            } else {
                                                addString(
                                                    printTwoStringStringData(
                                                        "${
                                                            DrawGameTranslationMapping.getTranslatedDrawGameString(
                                                                "${saleResponseData.responseData.panelData[i].pickDisplayName}",
                                                                languageCode.toString()
                                                            )
                                                        }/${saleResponseData.responseData.panelData[i].betDisplayName}",
                                                        "${(saleResponseData.responseData.panelData[i].unitCost * saleResponseData.responseData.panelData[i].betAmountMultiple * saleResponseData.responseData.panelData[i].numberOfLines).toInt()} $currencyCode"
                                                    )
                                                )

                                            }
                                            /*addString(
                                                printTwoStringStringData(
                                                    "No of lines",
                                                    "${saleResponseData.responseData.panelData[i].numberOfLines}"
                                                )
                                            )*/
                                            if (i != panelData.size - 1) addString(
                                                printDashStringData(getPaperLength())
                                            )
                                            amount += saleResponseData.responseData.panelData[i].unitCost.toInt() * saleResponseData.responseData.panelData[i].betAmountMultiple * saleResponseData.responseData.panelData[i].numberOfLines
                                        }

                                    } else if (saleResponseData.responseData.panelData[i].pickConfig.equals(
                                            "Market", ignoreCase = true
                                        )
                                    ) {
                                        addString(saleResponseData.responseData.panelData[i].betDisplayName)
                                        addString(
                                            printTwoStringStringData(
                                                "${
                                                    DrawGameTranslationMapping.getTranslatedDrawGameString(
                                                        "${saleResponseData.responseData.panelData[i].pickDisplayName}",
                                                        languageCode.toString()
                                                    )
                                                }",
                                                "${(saleResponseData.responseData.panelData[i].unitCost * saleResponseData.responseData.panelData[i].betAmountMultiple * saleResponseData.responseData.panelData[i].numberOfLines).toInt()} $currencyCode"
                                            )
                                        )
                                        /*addString(
                                            printTwoStringStringData(
                                                "No of lines",
                                                "${saleResponseData.responseData.panelData[i].numberOfLines}"
                                            )
                                        )*/
                                        if (i != panelData.size - 1) addString(
                                            printDashStringData(
                                                getPaperLength()
                                            )
                                        )
                                        amount += saleResponseData.responseData.panelData[i].unitCost.toInt() * saleResponseData.responseData.panelData[i].betAmountMultiple * saleResponseData.responseData.panelData[i].numberOfLines
                                    }
                                }
                                setBold(true)
                                addString(printLineStringData(getPaperLength()))
                                setTextSize(24)
                                addString(
                                    printTwoStringStringData(
                                        DrawGameTranslationMapping.getTranslatedDrawGameString(
                                            "Amount",
                                            languageCode.toString()
                                        ), "${amount.toInt()}"
                                    )
                                )
                                addString(
                                    printTwoStringStringData(
                                        DrawGameTranslationMapping.getTranslatedDrawGameString(
                                            "No of Draws(s)",
                                            languageCode.toString()
                                        ),
                                        "${saleResponseData.responseData.drawData.size}"
                                    )
                                )
                                addString(printDashStringData(getPaperLength()))
                                addString(
                                    printTwoStringStringData(
                                        DrawGameTranslationMapping.getTranslatedDrawGameString(
                                            "TOTAL AMOUNT",
                                            languageCode.toString()
                                        ),
                                        "${saleResponseData.responseData.totalPurchaseAmount.toInt()} $currencyCode"
                                    )
                                )
                                addString(" ")
                                printLogo(qrCodeHelperObject.qrcOde, true)
                                addString(saleResponseData.responseData.ticketNumber)
                                addString(" ")
                                addString("$username")
                                addString(
                                    "${
                                        DrawGameTranslationMapping.getTranslatedDrawGameString(
                                            "Ticket Validity",
                                            languageCode.toString()
                                        )
                                    }: ${saleResponseData.responseData.ticketExpiry}"
                                )
                                addString(
                                    "\n- - ${
                                        DrawGameTranslationMapping.getTranslatedDrawGameString(
                                            "Reprint Ticket",
                                            languageCode.toString()
                                        )
                                    } - -\n"
                                )
                                addString("\n\n")
                                printString()
                                activity.runOnUiThread {
                                    Toast.makeText(
                                        activity,
                                        DrawGameTranslationMapping.getTranslatedDrawGameString(
                                            "Successfully printed",
                                            languageCode.toString()
                                        ),
                                        Toast.LENGTH_SHORT
                                    ).show()
                                }
                                result.success(true)

                            } catch (e: java.lang.Exception) {
                                showMsgAccordingToException(e as CommonException, result)
                                stop()
                                e.printStackTrace()
                            }
                        }

                    } else {
                        result.error(
                            "-1", "Unable to find printer", "no sunmi or no usb thermal printer"
                        )
                    }
                }
            }
            else if (call.method == "dgeLastResult") {
                val bitmap =
                    BitmapFactory.decodeResource(context.resources, R.drawable.longa_lotto_retail)
                val resizedBitmap = Bitmap.createScaledBitmap(bitmap, 280, 70, false)
                Log.i("TaG", "resultResponseData------->${resultResponseData}")
                mSunmiPrinterService?.run {

                    enterPrinterBuffer(true)
                    setAlignment(1, null)
                    printBitmapCustom(resizedBitmap, 1, null)
                    sendRAWData(boldFontEnable, null)
                    setFontSize(24f, null)
                    printText("\n\n${resultResponseData.drawName}", null)
                    sendRAWData(boldFontDisable, null)
                    printText("\nDraw Time", null)/*val purchaseDate: String = resultResponseData.drawTime.split(" ")[0]
                    val purchaseTime: String = resultResponseData.drawTime.split(" ")[1]*/
                    printText("\n${resultResponseData.drawTime}", null)
                    printText("\n____________________________", null)
                    printText("\nResult", null)
                    printText("\n${resultResponseData.winningNo}", null)
                    printText("\n____________________________", null)
                    if (resultResponseData?.sideBetMatchInfo != null && resultResponseData.sideBetMatchInfo.isNotEmpty()) {
                        printText("\nSide Bet\n", null)
                        var amount = 0.0
                        var numberString: String
                        for (i in 0 until resultResponseData.sideBetMatchInfo.size) {
                            printColumnsString(
                                arrayOf<String>(
                                    "${resultResponseData.sideBetMatchInfo[i]?.betDisplayName}",
                                    "${resultResponseData.sideBetMatchInfo[i]?.pickTypeName}"
                                ), intArrayOf(
                                    "${resultResponseData.sideBetMatchInfo[i]?.betDisplayName}".length,
                                    "${resultResponseData.sideBetMatchInfo[i]?.pickTypeName}".length
                                ), intArrayOf(0, 2), null
                            )
                            printText("\n____________________________\n", null)
                        }
                    }

                    sendRAWData(boldFontEnable, null)

                    if (resultResponseData.winningMultiplierInfo != null) {
                        printColumnsString(
                            arrayOf<String>(
                                "Winning Multiplier",
                                "${resultResponseData.winningMultiplierInfo.multiplierCode} (${resultResponseData.winningMultiplierInfo?.value})"
                            ), intArrayOf(
                                "Winning Multiplier".length,
                                "${resultResponseData.winningMultiplierInfo.multiplierCode} (${resultResponseData.winningMultiplierInfo?.value})".length
                            ), intArrayOf(0, 2), null
                        )
                    }

                    sendRAWData(boldFontDisable, null)
                    printText("\n\n", null)
                    exitPrinterBufferWithCallback(true, object : InnerResultCallback() {
                        override fun onRunResult(isSuccess: Boolean) {}

                        override fun onReturnString(result: String?) {}

                        override fun onRaiseException(code: Int, msg: String?) {
                            activity.runOnUiThread {
                                Toast.makeText(
                                    activity,
                                    "Something went wrong while printing, Please try again",
                                    Toast.LENGTH_SHORT
                                ).show()
                            }
                            result.error("-1", msg, "Something went wrong while printing")
                        }

                        override fun onPrintResult(code: Int, msg: String?) {
                            if (updatePrinterState() != 1) {
                                activity.runOnUiThread {
                                    Toast.makeText(
                                        activity,
                                        "Something went wrong while printing, Please try again",
                                        Toast.LENGTH_SHORT
                                    ).show()
                                }
                                result.error("-1", msg, "Something went wrong while printing")

                            } else {
                                activity.runOnUiThread {
                                    Toast.makeText(
                                        activity,
                                        DrawGameTranslationMapping.getTranslatedDrawGameString(
                                            "Successfully printed",
                                            languageCode.toString()
                                        ),
                                        Toast.LENGTH_SHORT
                                    ).show()
                                }
                                result.success(true)
                            }
                        }
                    })
                } ?: this.let {
                    if (getDeviceName() == "QUALCOMM M1" || getDeviceModelName()=="m1k_go") {
                        val usbThermalPrinter = UsbThermalPrinter(activity.baseContext)
                        usbThermalPrinter.run {
                            try {
                                reset()
                                start(1)
                                setTextSize(28)
                                addString("")
                                setBold(true)
                                setGray(1)
                                setAlgin(1)
                                printLogo(resizedBitmap, true)
                                addString(gameName.toString())
                                setTextSize(22)
                                addString(printDashStringData(getPaperLength()))
                                addString(
                                    DrawGameTranslationMapping.getTranslatedDrawGameString(
                                        "Draw Time",
                                        languageCode.toString()
                                    )
                                )
                                addString("$resultDate ${resultResponseData.drawTime}")
                                addString(printDashStringData(getPaperLength()))
                                addString(
                                    DrawGameTranslationMapping.getTranslatedDrawGameString(
                                        "Result",
                                        languageCode.toString()
                                    )
                                )
                                addString("${resultResponseData.winningNo}")
                                addString(printDashStringData(getPaperLength()))
                                if (resultResponseData?.sideBetMatchInfo != null && resultResponseData.sideBetMatchInfo.isNotEmpty()) {
                                    addString(
                                        DrawGameTranslationMapping.getTranslatedDrawGameString(
                                            "Side Bet",
                                            languageCode.toString()
                                        )
                                    )
                                    var amount = 0.0
                                    var numberString: String
                                    for (i in 0 until resultResponseData.sideBetMatchInfo.size) {
                                        addString(
                                            printTwoStringStringData(
                                                "${resultResponseData.sideBetMatchInfo[i]?.betDisplayName}",
                                                "${resultResponseData.sideBetMatchInfo[i]?.pickTypeName}"
                                            )
                                        )
                                        addString(printDashStringData(getPaperLength()))
                                    }
                                }

                                /*val purchaseDate: String = resultResponseData.drawTime.split(" ")[0]
                                val purchaseTime: String = resultResponseData.drawTime.split(" ")[1]*/
                                addString(printDashStringData(getPaperLength()))
                                resultResponseData.winningMultiplierInfo?.let {
                                    addString(
                                        printTwoStringStringData(
                                            DrawGameTranslationMapping.getTranslatedDrawGameString(
                                                "Winning Multiplier",
                                                languageCode.toString()
                                            ),
                                            "${resultResponseData.winningMultiplierInfo.multiplierCode} (${resultResponseData.winningMultiplierInfo.value})"
                                        )
                                    )
                                    addString(printDashStringData(getPaperLength()))
                                    addString("\n")
                                }
                                addString("\n\n")
                                printString()
                                activity.runOnUiThread {
                                    Toast.makeText(
                                        activity,
                                        DrawGameTranslationMapping.getTranslatedDrawGameString(
                                            "Successfully printed",
                                            languageCode.toString()
                                        ),
                                        Toast.LENGTH_SHORT
                                    ).show()
                                }
                                result.success(true)
                            } catch (e: java.lang.Exception) {
                                showMsgAccordingToException(e as CommonException, result)
                                stop()
                                e.printStackTrace()
                            }
                        }

                    } else {
                        result.error(
                            "-1", "Unable to find printer", "no sunmi or no usb thermal printer"
                        )
                    }

                }
            }
            else if (call.method == "winClaim") {
                val qrCodeHelperObject = QRBarcodeHelper(activity.baseContext)
                qrCodeHelperObject.setContent(winClaimedResponseData.responseData.ticketNumber)
                val bitmap =
                    BitmapFactory.decodeResource(context.resources, R.drawable.longa_lotto_retail)
                val resizedBitmap = Bitmap.createScaledBitmap(bitmap, 280, 70, false)
                var isReprint = false;
                mSunmiPrinterService?.run {
                    android.util.Log.d(
                        "TAg",
                        "point 0000000000000000000000000000000000000000"
                    )
                    enterPrinterBuffer(true)
                    setAlignment(1, null)
                    printBitmapCustom(resizedBitmap, 1, null)
                    sendRAWData(boldFontEnable, null)
                    setFontSize(24f, null)
                    printText("\n\n${winClaimedResponseData.responseData.gameName}", null)
                    printText("\n____________________________\n", null)
                    sendRAWData(boldFontDisable, null)
                    printText("\nTicket Number", null)
                    printText("\n${winClaimedResponseData.responseData.ticketNumber}", null)
                    printText("\n____________________________", null)
                    printText("\nDraw Timing", null)
                    for (i in winClaimedResponseData.responseData.drawData) {
                        printText("\n${getFormattedDate(i.drawDate)} ${i.drawTime}", null)
                    }
                    printText("\n____________________________\n", null)
                    sendRAWData(boldFontDisable, null)
                    android.util.Log.d(
                        "TAg",
                        "point 11111111111111111111111111111111111111111"
                    )
                    for (i in winClaimedResponseData.responseData.drawData) {
                        printColumnsString(
                            arrayOf("Draw Date", getFormattedDateForWinClaim(i.drawDate)),
                            intArrayOf(
                                "Draw Date".length,
                                getFormattedDateForWinClaim(i.drawDate).length
                            ),
                            intArrayOf(0, 2), null
                        )
                        printColumnsString(
                            arrayOf("Draw Time", i.drawTime),
                            intArrayOf("Draw Time".length, i.drawTime.length),
                            intArrayOf(0, 2), null
                        )
                        printColumnsString(
                            arrayOf("Win Status", i.winStatus),
                            intArrayOf("Win Status".length, i.winStatus.length),
                            intArrayOf(0, 2), null
                        )
                        printColumnsString(
                            arrayOf("Winning Amount", "${i.winningAmount.toDouble().toInt()} ${currencyCode}"),
                            intArrayOf(
                                "Winning Amount".length,
                                "${i.winningAmount.toDouble().toInt()} ${currencyCode}".length
                            ),
                            intArrayOf(0, 2), null
                        )
                        printText("____________________________\n\n", null)
                        if (i.winStatus.equals("RESULT AWAITED", true)) {
                            isReprint = true
                        }
                    }
                    printText("\n", null)
                    sendRAWData(boldFontEnable, null)
                    android.util.Log.d(
                        "TAg",
                        "point 1a1a1a1a1a1a1a1a1a1a1a1a1"
                    )

                    if (isReprint) {
                        printText("Reprint Ticket\n__________________\n", null)
                        sendRAWData(boldFontDisable, null)
                        var amount = 0.0
                        var numberString: String
                        if (winClaimedResponseData.responseData.gameCode == "ThaiLottery") {
                            for (i in 0 until winClaimedResponseData.responseData.panelData.size) {
                                if (winClaimedResponseData.responseData.panelData[i].pickConfig.equals(
                                        "Number",
                                        ignoreCase = true
                                    )
                                ) {
                                    printText(
                                        "\n${winClaimedResponseData.responseData.panelData[i].pickedValues}\n",
                                        null
                                    )
                                    printColumnsString(
                                        arrayOf(
                                            "${winClaimedResponseData.responseData.panelData[i].pickDisplayName} : ${winClaimedResponseData.responseData.panelData[i].betDisplayName}",
                                            "${winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * saleResponseData.responseData.panelData[i].betAmountMultiple * saleResponseData.responseData.panelData[i].numberOfLines} $currencyCode"
                                        ),
                                        intArrayOf(
                                            "${winClaimedResponseData.responseData.panelData[i].pickDisplayName} : ${winClaimedResponseData.responseData.panelData[i].betDisplayName}".length,
                                            "${winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * winClaimedResponseData.responseData.panelData[i].betAmountMultiple * winClaimedResponseData.responseData.panelData[i].numberOfLines} $currencyCode".length
                                        ),
                                        intArrayOf(0, 2), null
                                    )
                                    /*printColumnsString(
                                        arrayOf(
                                            "No of lines",
                                            "${winClaimedResponseData.responseData.panelData[i].numberOfLines}"
                                        ),
                                        intArrayOf(
                                            "No of lines".length,
                                            "${winClaimedResponseData.responseData.panelData[i].numberOfLines}".length
                                        ),
                                        intArrayOf(0, 2), null
                                    )*/
                                    printText("\n----------------------------", null)
                                    amount += winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * winClaimedResponseData.responseData.panelData[i].betAmountMultiple * winClaimedResponseData.responseData.panelData[i].numberOfLines
                                }
                            }
                        } else {
                            val panelDataList = winClaimedResponseData.responseData.panelData;
                            panelDataList.let { mPanelData ->
                                for (i in 0 until mPanelData.size) {
                                    val isQp =
                                        if (winClaimedResponseData.responseData.panelData[i].quickPick) "/QP" else " "
                                    if (winClaimedResponseData.responseData.panelData[i].pickConfig.equals(
                                            "Number",
                                            ignoreCase = true
                                        )
                                    ) {
                                        if (winClaimedResponseData.responseData.panelData[i].pickType.equals(
                                                "Banker",
                                                ignoreCase = true
                                            )
                                        ) {
                                            numberString =
                                                winClaimedResponseData.responseData.panelData[i].pickedValues
                                            val banker: Array<String> =
                                                numberString.split("-").toTypedArray()
                                            printText("\nUL - ${banker[0]}", null)
                                            printText("\nLL - ${banker[1]}\n", null)
                                            if (winClaimedResponseData.responseData.panelData[i].quickPick) {
                                                printColumnsString(
                                                    arrayOf(
                                                        "${winClaimedResponseData.responseData.panelData[i].betDisplayName}$isQp",
                                                        "${winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * panelData[i].betAmountMultiple * panelData[i].numberOfLines} $currencyCode"
                                                    ),
                                                    intArrayOf(
                                                        "${winClaimedResponseData.responseData.panelData[i].betDisplayName}$isQp".length,
                                                        "${winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * panelData[i].betAmountMultiple * panelData[i].numberOfLines} $currencyCode".length
                                                    ),
                                                    intArrayOf(0, 2), null
                                                )

                                            } else {
                                                printColumnsString(
                                                    arrayOf(
                                                        "${winClaimedResponseData.responseData.panelData[i].pickDisplayName}/${winClaimedResponseData.responseData.panelData[i].betDisplayName}",
                                                        "${winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * panelData[i].betAmountMultiple * panelData[i].numberOfLines} $currencyCode"
                                                    ),
                                                    intArrayOf(
                                                        "${winClaimedResponseData.responseData.panelData[i].pickDisplayName}/${winClaimedResponseData.responseData.panelData[i].betDisplayName}".length,
                                                        "${winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * panelData[i].betAmountMultiple * panelData[i].numberOfLines} $currencyCode".length
                                                    ),
                                                    intArrayOf(0, 2), null
                                                )

                                            }
                                            /*printColumnsString(
                                                arrayOf(
                                                    "No of lines",
                                                    "${winClaimedResponseData.responseData.panelData[i].numberOfLines}"
                                                ),
                                                intArrayOf(
                                                    "No of lines".length,
                                                    "${winClaimedResponseData.responseData.panelData[i].numberOfLines}".length
                                                ),
                                                intArrayOf(0, 2), null
                                            )*/

                                            printText("\n----------------------------", null)
                                            amount += winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * winClaimedResponseData.responseData.panelData[i].betAmountMultiple * winClaimedResponseData.responseData.panelData[i].numberOfLines

                                        } else {
                                            printText(
                                                "\n${winClaimedResponseData.responseData.panelData[i].pickedValues}\n",
                                                null
                                            )
                                            if (winClaimedResponseData.responseData.panelData[i].quickPick) {
                                                printColumnsString(
                                                    arrayOf(
                                                        "${winClaimedResponseData.responseData.panelData[i].betDisplayName}$isQp",
                                                        "${winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * panelData[i].betAmountMultiple * panelData[i].numberOfLines} $currencyCode"
                                                    ),
                                                    intArrayOf(
                                                        "${winClaimedResponseData.responseData.panelData[i].betDisplayName}$isQp".length,
                                                        "${winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * panelData[i].betAmountMultiple * panelData[i].numberOfLines} $currencyCode".length
                                                    ),
                                                    intArrayOf(0, 2), null
                                                )

                                            } else {
                                                printColumnsString(
                                                    arrayOf(
                                                        "${winClaimedResponseData.responseData.panelData[i].pickDisplayName}/${winClaimedResponseData.responseData.panelData[i].betDisplayName}",
                                                        "${winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * winClaimedResponseData.responseData.panelData[i].betAmountMultiple * winClaimedResponseData.responseData.panelData[i].numberOfLines} $currencyCode"
                                                    ),
                                                    intArrayOf(
                                                        "${winClaimedResponseData.responseData.panelData[i].pickDisplayName}/${winClaimedResponseData.responseData.panelData[i].betDisplayName}".length,
                                                        "${winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * winClaimedResponseData.responseData.panelData[i].betAmountMultiple * winClaimedResponseData.responseData.panelData[i].numberOfLines} $currencyCode".length
                                                    ),
                                                    intArrayOf(0, 2), null
                                                )

                                            }
                                            /*printColumnsString(
                                                arrayOf(
                                                    "No of lines",
                                                    "${winClaimedResponseData.responseData.panelData[i].numberOfLines}"
                                                ),
                                                intArrayOf(
                                                    "No of lines".length,
                                                    "${winClaimedResponseData.responseData.panelData[i].numberOfLines}".length
                                                ),
                                                intArrayOf(0, 2), null
                                            )*/
                                            printText("\n----------------------------", null)
                                            amount += winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * winClaimedResponseData.responseData.panelData[i].betAmountMultiple * winClaimedResponseData.responseData.panelData[i].numberOfLines
                                        }

                                    } else if (winClaimedResponseData.responseData.panelData[i].pickConfig.equals(
                                            "Market",
                                            ignoreCase = true
                                        )
                                    ) {
                                        printText(
                                            "\n${winClaimedResponseData.responseData.panelData[i].betDisplayName}\n",
                                            null
                                        )
                                        printColumnsString(
                                            arrayOf(
                                                winClaimedResponseData.responseData.panelData[i].pickDisplayName,
                                                "${winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * panelData[i].betAmountMultiple * panelData[i].numberOfLines} $currencyCode"
                                            ),
                                            intArrayOf(
                                                winClaimedResponseData.responseData.panelData[i].pickDisplayName.length,
                                                "${winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * panelData[i].betAmountMultiple * panelData[i].numberOfLines} $currencyCode".length
                                            ),
                                            intArrayOf(0, 2), null
                                        )
                                        /*printColumnsString(
                                            arrayOf("No of lines", "${panelData[i].numberOfLines}"),
                                            intArrayOf(
                                                "No of lines".length,
                                                "${panelData[i].numberOfLines}".length
                                            ),
                                            intArrayOf(0, 2), null
                                        )*/
                                        printText("\n----------------------------", null)
                                        amount += winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * winClaimedResponseData.responseData.panelData[i].betAmountMultiple * winClaimedResponseData.responseData.panelData[i].numberOfLines
                                    }
                                }
                            }
                        }

                        Log.i(
                            "TaG",
                            "---------------->${winClaimedResponseData.responseData.panelData.size}"
                        )
                        setAlignment(0, null)
                        printText("\n", null)
                        printColumnsString(
                            arrayOf("Amount", "${amount.toInt()}"),
                            intArrayOf("Amount".length, "${amount.toInt()}".length),
                            intArrayOf(0, 2), null
                        )
                        printColumnsString(
                            arrayOf(
                                "No of Draws(s)",
                                "${winClaimedResponseData.responseData.drawData.size}"
                            ),
                            intArrayOf(
                                "No of Draws(s)".length,
                                "${winClaimedResponseData.responseData.drawData.size}".length
                            ),
                            intArrayOf(0, 2), null
                        )
                        sendRAWData(boldFontEnable, null)
                        printColumnsString(
                            arrayOf(
                                "TOTAL AMOUNT",
                                "${winClaimedResponseData.responseData.totalPurchaseAmount.toInt()} $currencyCode"
                            ),
                            intArrayOf(
                                "TOTAL AMOUNT".length,
                                "${winClaimedResponseData.responseData.totalPurchaseAmount.toInt()} $currencyCode".length
                            ),
                            intArrayOf(0, 2), null
                        )
                        printText("\n", null)
                        setAlignment(1, null)
                        printBitmapCustom(qrCodeHelperObject.qrcOde, 1, null)
                        sendRAWData(boldFontDisable, null)
                        printText("\n${winClaimedResponseData.responseData.ticketNumber}", null)
                        printText("\n$username\n", null)
                    }

                    android.util.Log.d("TAg", "point 222222222222222222222222222222222")
                    exitPrinterBufferWithCallback(true, object : InnerResultCallback() {
                        override fun onRunResult(isSuccess: Boolean) {}

                        override fun onReturnString(result: String?) {}

                        override fun onRaiseException(code: Int, msg: String?) {
                            activity.runOnUiThread {
                                Toast.makeText(
                                    activity,
                                    "Something went wrong while printing, Please try again",
                                    Toast.LENGTH_SHORT
                                ).show()
                            }
                            result.error("-1", msg, "Something went wrong while printing")
                        }

                        override fun onPrintResult(code: Int, msg: String?) {
                            if (updatePrinterState() != 1) {
                                activity.runOnUiThread {
                                    Toast.makeText(
                                        activity,
                                        "Something went wrong while printing, Please try again",
                                        Toast.LENGTH_SHORT
                                    ).show()
                                }
                                result.error("-1", msg, "Something went wrong while printing")

                            } else {
                                activity.runOnUiThread {
                                    Toast.makeText(
                                        activity,
                                        DrawGameTranslationMapping.getTranslatedDrawGameString(
                                            "Successfully printed",
                                            languageCode.toString()
                                        ),
                                        Toast.LENGTH_SHORT
                                    ).show()
                                }
                                result.success(true)
                            }
                        }
                    })


                } ?: this.let {
                    val usbThermalPrinter = UsbThermalPrinter(activity.baseContext)
                    if (getDeviceName() == "QUALCOMM M1" || getDeviceModelName()=="m1k_go") {
                        var isReprint = false;

                        usbThermalPrinter.run {
                            try {
                                val winClaimedData: List<WinClaimedResponse.ResponseData.DrawData> =
                                    winClaimedResponseData.responseData.drawData
                                reset()
                                start(1)
                                setTextSize(28)
                                addString("")
                                setBold(true)
                                setGray(1)
                                setAlgin(1)
                                printLogo(resizedBitmap, true)
                                addString(winClaimedResponseData.responseData.gameName)
                                setTextSize(22)
                                addString(printDashStringData(getPaperLength()))
                                setBold(true)
                                setItalic(true)
                                addString(
                                    DrawGameTranslationMapping.getTranslatedDrawGameString(
                                        "Ticket Number",
                                        languageCode.toString()
                                    )
                                )
                                setItalic(false)
                                setBold(true)
                                setTextSize(24)
                                addString(lastWinningSaleTicketNo.toString())
                                setTextSize(22)
                                setBold(false)
                                addString(printLineStringData(getPaperLength()))
                                addString("                                     ")
                                //setItalic(true)
                                setAlgin(0)
                                setTextSize(22)
                                for (i in winClaimedResponseData.responseData.drawData) {
                                    addString(
                                        printTwoStringStringData(
                                            DrawGameTranslationMapping.getTranslatedDrawGameString(
                                                "Draw Date",
                                                languageCode.toString()
                                            ),
                                            getFormattedDateForWinClaim(i.drawDate)
                                        )
                                    )
                                    addString(
                                        printTwoStringStringData(
                                            DrawGameTranslationMapping.getTranslatedDrawGameString(
                                                "Draw Time",
                                                languageCode.toString()
                                            ), i.drawTime
                                        )
                                    )
                                    addString(
                                        printTwoStringStringData(
                                            DrawGameTranslationMapping.getTranslatedDrawGameString(
                                                "Win Status",
                                                languageCode.toString()
                                            ), i.winStatus
                                        )
                                    )
                                    addString(
                                        printTwoStringStringData(
                                            DrawGameTranslationMapping.getTranslatedDrawGameString(
                                                "Winning Amount",
                                                languageCode.toString()
                                            ),
                                            "${i.winningAmount.toDouble().toInt()} ${currencyCode}"
                                        )
                                    )
                                    var status = "UNCLAIMED"
                                    for (panelWinData in i.panelWinList) {
                                        if (panelWinData.status == "CLAIMED") {
                                            status = "CLAIMED"
                                            break
                                        }
                                    }
                                    addString(
                                        printTwoStringStringData(
                                            DrawGameTranslationMapping.getTranslatedDrawGameString(
                                                "Claim Status",
                                                languageCode.toString()
                                            ),
                                            "$status"
                                        )
                                    )
                                    addString(printLineStringData(getPaperLength()))
                                    addString("\n")
                                    if (i.winStatus.equals("RESULT AWAITED", true)) {
                                        isReprint = true
                                    }
                                }
                                setAlgin(1)
                                setBold(false)
                                Log.d("TAg", "isReprint: $isReprint")
                                if (isReprint) {
                                    setBold(true)
                                    setTextSize(24)
                                    setAlgin(1)
                                    addString(
                                        DrawGameTranslationMapping.getTranslatedDrawGameString(
                                            "Reprint Ticket",
                                            languageCode.toString()
                                        )
                                    )
                                    addString("__________________")
                                    addString("")
                                    var amount = 0.0
                                    var numberString: String
                                    if (winClaimedResponseData.responseData.gameCode == "ThaiLottery") {
                                        for (i in 0 until winClaimedResponseData.responseData.panelData.size) {
                                            if (winClaimedResponseData.responseData.panelData[i].pickConfig.equals(
                                                    "Number",
                                                    ignoreCase = true
                                                )
                                            ) {
                                                addString(winClaimedResponseData.responseData.panelData[i].pickedValues)
                                                addString(
                                                    printTwoStringStringData(
                                                        "${winClaimedResponseData.responseData.panelData[i].pickDisplayName} : ${winClaimedResponseData.responseData.panelData[i].betDisplayName}",
                                                        "${winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * winClaimedResponseData.responseData.panelData[i].betAmountMultiple * winClaimedResponseData.responseData.panelData[i].numberOfLines} $currencyCode"
                                                    )
                                                )
                                                /*addString(
                                                    printTwoStringStringData(
                                                        "No of lines",
                                                        "${winClaimedResponseData.responseData.panelData[i].numberOfLines}"
                                                    )
                                                )*/
                                                if (i != winClaimedResponseData.responseData.panelData.size - 1) addString(
                                                    printDashStringData(getPaperLength())
                                                )
                                                amount += winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * winClaimedResponseData.responseData.panelData[i].betAmountMultiple * winClaimedResponseData.responseData.panelData[i].numberOfLines
                                            }
                                        }
                                    } else {
                                        val panelDataList =
                                            winClaimedResponseData.responseData.panelData;
                                        Log.i(
                                            "Rajneesh",
                                            "configureFlutterEngine:panelDataList -> $panelDataList"
                                        )
                                        panelDataList.let { mPanelData ->
                                            for (i in 0 until mPanelData.size) {
                                                val isQp =
                                                    if (winClaimedResponseData.responseData.panelData[i].quickPick) "/QP" else " "
                                                if (winClaimedResponseData.responseData.panelData[i].pickConfig.equals(
                                                        "Number",
                                                        ignoreCase = true
                                                    )
                                                ) {
                                                    if (winClaimedResponseData.responseData.panelData[i].pickType.equals(
                                                            "Banker",
                                                            ignoreCase = true
                                                        )
                                                    ) {
                                                        numberString =
                                                            winClaimedResponseData.responseData.panelData[i].pickedValues
                                                        val banker: Array<String> =
                                                            numberString.split("-").toTypedArray()

                                                        addString("UL - ${banker[0]}")
                                                        addString("LL - ${banker[1]}")
                                                        if (winClaimedResponseData.responseData.panelData[i].quickPick) {
                                                            addString(
                                                                printTwoStringStringData(
                                                                    "${winClaimedResponseData.responseData.panelData[i].betDisplayName}$isQp",
                                                                    "${mPanelData[i].unitCost.toInt() * mPanelData[i].betAmountMultiple * mPanelData[i].numberOfLines} $currencyCode"
                                                                )
                                                            )

                                                        } else {
                                                            addString(
                                                                printTwoStringStringData(
                                                                    "${winClaimedResponseData.responseData.panelData[i].pickDisplayName}/${winClaimedResponseData.responseData.panelData[i].betDisplayName}",
                                                                    "${mPanelData[i].unitCost.toInt() * mPanelData[i].betAmountMultiple * mPanelData[i].numberOfLines} $currencyCode"
                                                                )
                                                            )

                                                        }
                                                        /*addString(
                                                            printTwoStringStringData(
                                                                "No of lines",
                                                                "${mPanelData[i].numberOfLines}"
                                                            )
                                                        )*/
                                                        addString(printDashStringData(getPaperLength()))
                                                        amount += mPanelData[i].unitCost.toInt() * mPanelData[i].betAmountMultiple * mPanelData[i].numberOfLines

                                                    } else {
                                                        addString(mPanelData[i].pickedValues)
                                                        if (winClaimedResponseData.responseData.panelData[i].quickPick) {
                                                            addString(
                                                                printTwoStringStringData(
                                                                    "${winClaimedResponseData.responseData.panelData[i].betDisplayName}$isQp",
                                                                    "${mPanelData[i].unitCost.toInt() * mPanelData[i].betAmountMultiple * mPanelData[i].numberOfLines} $currencyCode"
                                                                )
                                                            )

                                                        } else {
                                                            addString(
                                                                printTwoStringStringData(
                                                                    "${winClaimedResponseData.responseData.panelData[i].pickDisplayName}/${winClaimedResponseData.responseData.panelData[i].betDisplayName}",
                                                                    "${mPanelData[i].unitCost.toInt() * mPanelData[i].betAmountMultiple * mPanelData[i].numberOfLines} $currencyCode"
                                                                )
                                                            )

                                                        }
                                                        /*addString(
                                                            printTwoStringStringData(
                                                                "No of lines",
                                                                "${mPanelData[i].numberOfLines}"
                                                            )
                                                        )*/
                                                        if (i != mPanelData.size - 1) addString(
                                                            printDashStringData(getPaperLength())
                                                        )
                                                        amount += mPanelData[i].unitCost.toInt() * mPanelData[i].betAmountMultiple * mPanelData[i].numberOfLines
                                                    }

                                                } else if (winClaimedResponseData.responseData.panelData[i].pickConfig.equals(
                                                        "Market",
                                                        ignoreCase = true
                                                    )
                                                ) {
                                                    addString(winClaimedResponseData.responseData.panelData[i].betDisplayName)
                                                    addString(
                                                        printTwoStringStringData(
                                                            winClaimedResponseData.responseData.panelData[i].pickDisplayName,
                                                            "${mPanelData[i].unitCost.toInt() * mPanelData[i].betAmountMultiple * mPanelData[i].numberOfLines} $currencyCode"
                                                        )
                                                    )
                                                    /*addString(
                                                        printTwoStringStringData(
                                                            "No of lines",
                                                            "${mPanelData[i].numberOfLines}"
                                                        )
                                                    )*/
                                                    if (i != mPanelData.size - 1) addString(
                                                        printDashStringData(getPaperLength())
                                                    )
                                                    amount += mPanelData[i].unitCost.toInt() * mPanelData[i].betAmountMultiple * mPanelData[i].numberOfLines
                                                }
                                            }
                                        }
                                    }
                                    addString(printLineStringData(getPaperLength()))
                                    setTextSize(24)
                                    setAlgin(1)
                                    addString(
                                        printTwoStringStringData(
                                            DrawGameTranslationMapping.getTranslatedDrawGameString(
                                                "Amount",
                                                languageCode.toString()
                                            ), "${amount.toInt()}"
                                        )
                                    )
                                    addString(
                                        printTwoStringStringData(
                                            DrawGameTranslationMapping.getTranslatedDrawGameString(
                                                "No of Draws(s)",
                                                languageCode.toString()
                                            ),
                                            "${winClaimedResponseData.responseData.drawData.size}"
                                        )
                                    )
                                    setBold(true)
                                    addString(
                                        printTwoStringStringData(
                                            DrawGameTranslationMapping.getTranslatedDrawGameString(
                                                "TOTAL AMOUNT",
                                                languageCode.toString()
                                            ),
                                            "${winClaimedResponseData.responseData.totalPurchaseAmount.toInt()} $currencyCode"
                                        )
                                    )
                                    setBold(false)
                                    addString(" ")
                                    setAlgin(1)
                                    printLogo(qrCodeHelperObject.qrcOde, true)
                                    addString(winClaimedResponseData.responseData.ticketNumber)
                                    addString("")
                                    addString("$username")
                                    addString(
                                        "${
                                            DrawGameTranslationMapping.getTranslatedDrawGameString(
                                                "Ticket Validity",
                                                languageCode.toString()
                                            )
                                        }: ${winClaimedResponseData.responseData.ticketExpiry}"
                                    )
                                    addString("\n\n")

                                } /*else {
                                    addString("You claimed successfully\n\n")
                                }*/
                                printString()
                                activity.runOnUiThread {
                                    Toast.makeText(
                                        activity,
                                        DrawGameTranslationMapping.getTranslatedDrawGameString(
                                            "Successfully printed",
                                            languageCode.toString()
                                        ),
                                        Toast.LENGTH_SHORT
                                    ).show()
                                }
                                result.success(true)

                            } catch (e: java.lang.Exception) {
                                showMsgAccordingToException(e as CommonException, result)
                                stop()
                                e.printStackTrace()
                            }
                        }

                    } else {
                        result.error(
                            "-1",
                            "Unable to find printer",
                            "no sunmi or no usb thermal printer"
                        )
                    }
                }
            }
            else if (call.method == "summarizeReport") {

                val bitmap =
                    BitmapFactory.decodeResource(context.resources, R.drawable.longa_lotto_retail)
                val resizedBitmap = Bitmap.createScaledBitmap(bitmap, 280, 70, false)

                mSunmiPrinterService?.run {
                    /*android.util.Log.d(
                        "TAg",
                        "point 00000000000000000 Summarizer report 00000000000000000000000"
                    )
                    enterPrinterBuffer(true)
                    setAlignment(1, null)
                    printBitmapCustom(resizedBitmap, 1, null)
                    sendRAWData(boldFontEnable, null)
                    setFontSize(24f, null)
                    printText("\n\n${winClaimedResponseData.responseData.gameName}", null)
                    printText("\n____________________________\n", null)
                    sendRAWData(boldFontDisable, null)
                    printText("\nTicket Number", null)
                    printText("\n${winClaimedResponseData.responseData.ticketNumber}", null)
                    printText("\n____________________________", null)
                    printText("\nDraw Timing", null)
                    for (i in winClaimedResponseData.responseData.drawData) {
                        printText("\n${getFormattedDate(i.drawDate)} ${i.drawTime}", null)
                    }
                    printText("\n____________________________\n", null)
                    sendRAWData(boldFontDisable, null)
                    android.util.Log.d(
                        "TAg",
                        "point 11111111111111111111111111111111111111111"
                    )
                    for (i in winClaimedResponseData.responseData.drawData) {
                        printColumnsString(
                            arrayOf("Draw Date", getFormattedDateForWinClaim(i.drawDate)),
                            intArrayOf(
                                "Draw Date".length,
                                getFormattedDateForWinClaim(i.drawDate).length
                            ),
                            intArrayOf(0, 2), null
                        )
                        printColumnsString(
                            arrayOf("Draw Time", i.drawTime),
                            intArrayOf("Draw Time".length, i.drawTime.length),
                            intArrayOf(0, 2), null
                        )
                        printColumnsString(
                            arrayOf("Win Status", i.winStatus),
                            intArrayOf("Win Status".length, i.winStatus.length),
                            intArrayOf(0, 2), null
                        )
                        printColumnsString(
                            arrayOf("Winning Amount", "${i.winningAmount.toDouble().toInt()} ${currencyCode}"),
                            intArrayOf(
                                "Winning Amount".length,
                                "${i.winningAmount.toDouble().toInt()} ${currencyCode}".length
                            ),
                            intArrayOf(0, 2), null
                        )
                        printText("____________________________\n\n", null)
                        if (i.winStatus.equals("RESULT AWAITED", true)) {
                            isReprint = true
                        }
                    }
                    printText("\n", null)
                    sendRAWData(boldFontEnable, null)
                    android.util.Log.d(
                        "TAg",
                        "point 1a1a1a1a1a1a1a1a1a1a1a1a1"
                    )

                    if (isReprint) {
                        printText("Reprint Ticket\n__________________\n", null)
                        sendRAWData(boldFontDisable, null)
                        var amount = 0.0
                        var numberString: String
                        if (winClaimedResponseData.responseData.gameCode == "ThaiLottery") {
                            for (i in 0 until winClaimedResponseData.responseData.panelData.size) {
                                if (winClaimedResponseData.responseData.panelData[i].pickConfig.equals(
                                        "Number",
                                        ignoreCase = true
                                    )
                                ) {
                                    printText(
                                        "\n${winClaimedResponseData.responseData.panelData[i].pickedValues}\n",
                                        null
                                    )
                                    printColumnsString(
                                        arrayOf(
                                            "${winClaimedResponseData.responseData.panelData[i].pickDisplayName} : ${winClaimedResponseData.responseData.panelData[i].betDisplayName}",
                                            "${winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * saleResponseData.responseData.panelData[i].betAmountMultiple * saleResponseData.responseData.panelData[i].numberOfLines} $currencyCode"
                                        ),
                                        intArrayOf(
                                            "${winClaimedResponseData.responseData.panelData[i].pickDisplayName} : ${winClaimedResponseData.responseData.panelData[i].betDisplayName}".length,
                                            "${winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * winClaimedResponseData.responseData.panelData[i].betAmountMultiple * winClaimedResponseData.responseData.panelData[i].numberOfLines} $currencyCode".length
                                        ),
                                        intArrayOf(0, 2), null
                                    )
                                    printColumnsString(
                                        arrayOf(
                                            "No of lines",
                                            "${winClaimedResponseData.responseData.panelData[i].numberOfLines}"
                                        ),
                                        intArrayOf(
                                            "No of lines".length,
                                            "${winClaimedResponseData.responseData.panelData[i].numberOfLines}".length
                                        ),
                                        intArrayOf(0, 2), null
                                    )
                                    printText("\n----------------------------", null)
                                    amount += winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * winClaimedResponseData.responseData.panelData[i].betAmountMultiple * winClaimedResponseData.responseData.panelData[i].numberOfLines
                                }
                            }
                        } else {
                            val panelDataList = winClaimedResponseData.responseData.panelData;
                            panelDataList.let { mPanelData ->
                                for (i in 0 until mPanelData.size) {
                                    val isQp =
                                        if (winClaimedResponseData.responseData.panelData[i].quickPick) "/QP" else " "
                                    if (winClaimedResponseData.responseData.panelData[i].pickConfig.equals(
                                            "Number",
                                            ignoreCase = true
                                        )
                                    ) {
                                        if (winClaimedResponseData.responseData.panelData[i].pickType.equals(
                                                "Banker",
                                                ignoreCase = true
                                            )
                                        ) {
                                            numberString =
                                                winClaimedResponseData.responseData.panelData[i].pickedValues
                                            val banker: Array<String> =
                                                numberString.split("-").toTypedArray()
                                            printText("\nUL - ${banker[0]}", null)
                                            printText("\nLL - ${banker[1]}\n", null)
                                            if (winClaimedResponseData.responseData.panelData[i].quickPick) {
                                                printColumnsString(
                                                    arrayOf(
                                                        "${winClaimedResponseData.responseData.panelData[i].betDisplayName}$isQp",
                                                        "${winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * panelData[i].betAmountMultiple * panelData[i].numberOfLines} $currencyCode"
                                                    ),
                                                    intArrayOf(
                                                        "${winClaimedResponseData.responseData.panelData[i].betDisplayName}$isQp".length,
                                                        "${winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * panelData[i].betAmountMultiple * panelData[i].numberOfLines} $currencyCode".length
                                                    ),
                                                    intArrayOf(0, 2), null
                                                )

                                            } else {
                                                printColumnsString(
                                                    arrayOf(
                                                        "${winClaimedResponseData.responseData.panelData[i].pickDisplayName}/${winClaimedResponseData.responseData.panelData[i].betDisplayName}",
                                                        "${winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * panelData[i].betAmountMultiple * panelData[i].numberOfLines} $currencyCode"
                                                    ),
                                                    intArrayOf(
                                                        "${winClaimedResponseData.responseData.panelData[i].pickDisplayName}/${winClaimedResponseData.responseData.panelData[i].betDisplayName}".length,
                                                        "${winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * panelData[i].betAmountMultiple * panelData[i].numberOfLines} $currencyCode".length
                                                    ),
                                                    intArrayOf(0, 2), null
                                                )

                                            }
                                            printColumnsString(
                                                arrayOf(
                                                    "No of lines",
                                                    "${winClaimedResponseData.responseData.panelData[i].numberOfLines}"
                                                ),
                                                intArrayOf(
                                                    "No of lines".length,
                                                    "${winClaimedResponseData.responseData.panelData[i].numberOfLines}".length
                                                ),
                                                intArrayOf(0, 2), null
                                            )

                                            printText("\n----------------------------", null)
                                            amount += winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * winClaimedResponseData.responseData.panelData[i].betAmountMultiple * winClaimedResponseData.responseData.panelData[i].numberOfLines

                                        } else {
                                            printText(
                                                "\n${winClaimedResponseData.responseData.panelData[i].pickedValues}\n",
                                                null
                                            )
                                            if (winClaimedResponseData.responseData.panelData[i].quickPick) {
                                                printColumnsString(
                                                    arrayOf(
                                                        "${winClaimedResponseData.responseData.panelData[i].betDisplayName}$isQp",
                                                        "${winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * panelData[i].betAmountMultiple * panelData[i].numberOfLines} $currencyCode"
                                                    ),
                                                    intArrayOf(
                                                        "${winClaimedResponseData.responseData.panelData[i].betDisplayName}$isQp".length,
                                                        "${winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * panelData[i].betAmountMultiple * panelData[i].numberOfLines} $currencyCode".length
                                                    ),
                                                    intArrayOf(0, 2), null
                                                )

                                            } else {
                                                printColumnsString(
                                                    arrayOf(
                                                        "${winClaimedResponseData.responseData.panelData[i].pickDisplayName}/${winClaimedResponseData.responseData.panelData[i].betDisplayName}",
                                                        "${winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * winClaimedResponseData.responseData.panelData[i].betAmountMultiple * winClaimedResponseData.responseData.panelData[i].numberOfLines} $currencyCode"
                                                    ),
                                                    intArrayOf(
                                                        "${winClaimedResponseData.responseData.panelData[i].pickDisplayName}/${winClaimedResponseData.responseData.panelData[i].betDisplayName}".length,
                                                        "${winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * winClaimedResponseData.responseData.panelData[i].betAmountMultiple * winClaimedResponseData.responseData.panelData[i].numberOfLines} $currencyCode".length
                                                    ),
                                                    intArrayOf(0, 2), null
                                                )

                                            }
                                            printColumnsString(
                                                arrayOf(
                                                    "No of lines",
                                                    "${winClaimedResponseData.responseData.panelData[i].numberOfLines}"
                                                ),
                                                intArrayOf(
                                                    "No of lines".length,
                                                    "${winClaimedResponseData.responseData.panelData[i].numberOfLines}".length
                                                ),
                                                intArrayOf(0, 2), null
                                            )
                                            printText("\n----------------------------", null)
                                            amount += winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * winClaimedResponseData.responseData.panelData[i].betAmountMultiple * winClaimedResponseData.responseData.panelData[i].numberOfLines
                                        }

                                    } else if (winClaimedResponseData.responseData.panelData[i].pickConfig.equals(
                                            "Market",
                                            ignoreCase = true
                                        )
                                    ) {
                                        printText(
                                            "\n${winClaimedResponseData.responseData.panelData[i].betDisplayName}\n",
                                            null
                                        )
                                        printColumnsString(
                                            arrayOf(
                                                winClaimedResponseData.responseData.panelData[i].pickDisplayName,
                                                "${winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * panelData[i].betAmountMultiple * panelData[i].numberOfLines} $currencyCode"
                                            ),
                                            intArrayOf(
                                                winClaimedResponseData.responseData.panelData[i].pickDisplayName.length,
                                                "${winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * panelData[i].betAmountMultiple * panelData[i].numberOfLines} $currencyCode".length
                                            ),
                                            intArrayOf(0, 2), null
                                        )
                                        printColumnsString(
                                            arrayOf("No of lines", "${panelData[i].numberOfLines}"),
                                            intArrayOf(
                                                "No of lines".length,
                                                "${panelData[i].numberOfLines}".length
                                            ),
                                            intArrayOf(0, 2), null
                                        )
                                        printText("\n----------------------------", null)
                                        amount += winClaimedResponseData.responseData.panelData[i].unitCost.toInt() * winClaimedResponseData.responseData.panelData[i].betAmountMultiple * winClaimedResponseData.responseData.panelData[i].numberOfLines
                                    }
                                }
                            }
                        }

                        Log.i(
                            "TaG",
                            "---------------->${winClaimedResponseData.responseData.panelData.size}"
                        )
                        setAlignment(0, null)
                        printText("\n", null)
                        printColumnsString(
                            arrayOf("Amount", "${amount.toInt()}"),
                            intArrayOf("Amount".length, "${amount.toInt()}".length),
                            intArrayOf(0, 2), null
                        )
                        printColumnsString(
                            arrayOf(
                                "No of Draws(s)",
                                "${winClaimedResponseData.responseData.drawData.size}"
                            ),
                            intArrayOf(
                                "No of Draws(s)".length,
                                "${winClaimedResponseData.responseData.drawData.size}".length
                            ),
                            intArrayOf(0, 2), null
                        )
                        sendRAWData(boldFontEnable, null)
                        printColumnsString(
                            arrayOf(
                                "TOTAL AMOUNT",
                                "${winClaimedResponseData.responseData.totalPurchaseAmount.toInt()} $currencyCode"
                            ),
                            intArrayOf(
                                "TOTAL AMOUNT".length,
                                "${winClaimedResponseData.responseData.totalPurchaseAmount.toInt()} $currencyCode".length
                            ),
                            intArrayOf(0, 2), null
                        )
                        printText("\n", null)
                        setAlignment(1, null)
                        printBitmapCustom(qrCodeHelperObject.qrcOde, 1, null)
                        sendRAWData(boldFontDisable, null)
                        printText("\n${winClaimedResponseData.responseData.ticketNumber}", null)
                        printText("\n$username\n", null)
                    }

                    android.util.Log.d("TAg", "point 222222222222222222222222222222222")
                    exitPrinterBufferWithCallback(true, object : InnerResultCallback() {
                        override fun onRunResult(isSuccess: Boolean) {}

                        override fun onReturnString(result: String?) {}

                        override fun onRaiseException(code: Int, msg: String?) {
                            activity.runOnUiThread {
                                Toast.makeText(
                                    activity,
                                    "Something went wrong while printing, Please try again",
                                    Toast.LENGTH_SHORT
                                ).show()
                            }
                            result.error("-1", msg, "Something went wrong while printing")
                        }

                        override fun onPrintResult(code: Int, msg: String?) {
                            if (updatePrinterState() != 1) {
                                activity.runOnUiThread {
                                    Toast.makeText(
                                        activity,
                                        "Something went wrong while printing, Please try again",
                                        Toast.LENGTH_SHORT
                                    ).show()
                                }
                                result.error("-1", msg, "Something went wrong while printing")

                            } else {
                                activity.runOnUiThread {
                                    Toast.makeText(
                                        activity,
                                        "Successfully printed",
                                        Toast.LENGTH_SHORT
                                    ).show()
                                }
                                result.success(true)
                            }
                        }
                    })*/


                } ?: this.let {
                    val usbThermalPrinter = UsbThermalPrinter(activity.baseContext)
                    if (getDeviceName() == "QUALCOMM M1" || getDeviceModelName()=="m1k_go") {

                        usbThermalPrinter.run {
                            Log.i("TaG", "${summarizeReportResponseData}")
                            try {
                                reset()
                                start(1)
                                setTextSize(28)
                                addString("")
                                setBold(true)
                                setGray(1)
                                setAlgin(1)
                                printLogo(resizedBitmap, true)
                                addString(
                                    ReportTranslationMapping.getTranslatedReportString(
                                        "Summarize Ledger Report",
                                        languageCode.toString().toString()
                                    )
                                )
                                setTextSize(22)
                                addString(printDashStringData(getPaperLength()))
                                setBold(true)
                                setItalic(true)
                                addString(toAndFromDate.toString())
                                setItalic(false)
                                setBold(true)
                                addString("  ")
                                setTextSize(22)
                                setAlgin(0)
                                addString(
                                    printTwoStringStringData(
                                        "${
                                            ReportTranslationMapping.getTranslatedReportString(
                                                "Opening Balance",
                                                languageCode.toString().toString()
                                            )
                                        }  ",
                                        summarizeReportResponseData?.responseData?.data?.openingBalance.toString()
                                    )
                                )
                                addString(
                                    printTwoStringStringData(
                                        "${
                                            ReportTranslationMapping.getTranslatedReportString(
                                                "Closing Balance",
                                                languageCode.toString().toString()
                                            )
                                        }  ",
                                        summarizeReportResponseData?.responseData?.data?.closingBalance.toString()
                                    )
                                )
                                //addString(winClaimedResponseData.responseData.ticketNumber)
                                setTextSize(22)
                                setBold(false)
                                setItalic(true)
                                setAlgin(0)
                                setTextSize(22)
                                addString(printLineStringData(getPaperLength()))
                                val dataList =
                                    summarizeReportResponseData?.responseData?.data?.ledgerData
                                dataList?.forEach { i ->
                                    setBold(true)
                                    addString(
                                        ReportTranslationMapping.getTranslatedReportString(
                                            i?.serviceName ?: "", languageCode.toString().toString()
                                        )
                                    )
                                    setBold(false)
                                    addString("  ")
                                    addString(
                                        printTwoStringStringData(
                                            ReportTranslationMapping.getTranslatedReportString(
                                                i?.key1Name ?: "",
                                                languageCode.toString().toString()
                                            ), i?.key1.toString()
                                        )
                                    )
                                    addString(
                                        printTwoStringStringData(
                                            ReportTranslationMapping.getTranslatedReportString(
                                                i?.key2Name ?: "",
                                                languageCode.toString().toString()
                                            ), i?.key2.toString()
                                        )
                                    )
                                    addString(
                                        printTwoStringStringData(
                                            ReportTranslationMapping.getTranslatedReportString(
                                                "Net Amount",
                                                languageCode.toString().toString()
                                            ), "${i?.netAmount} ${currencyCode}"
                                        )
                                    )
                                    addString(printLineStringData(getPaperLength()))
                                    addString("\n")
                                }

                                setAlgin(1)
                                setBold(false)

                                printString()
                                activity.runOnUiThread {
                                    Toast.makeText(
                                        activity,
                                        DrawGameTranslationMapping.getTranslatedDrawGameString(
                                            "Successfully printed",
                                            languageCode.toString()
                                        ),
                                        Toast.LENGTH_SHORT
                                    ).show()
                                }
                                result.success(true)

                            } catch (e: java.lang.Exception) {
                                showMsgAccordingToException(e as CommonException, result)
                                stop()
                                e.printStackTrace()
                            }
                        }

                    } else {
                        result.error(
                            "-1",
                            "Unable to find printer",
                            "no sunmi or no usb thermal printer"
                        )
                    }
                }
            }
            else if (call.method == "balanceInvoiceReport") {

                val bitmap =
                    BitmapFactory.decodeResource(context.resources, R.drawable.longa_lotto_retail)
                val resizedBitmap = Bitmap.createScaledBitmap(bitmap, 280, 70, false)

                this.let {
                    val usbThermalPrinter = UsbThermalPrinter(activity.baseContext)


                    if (getDeviceName() == "QUALCOMM M1" || getDeviceModelName()=="m1k_go") {
                        usbThermalPrinter.run {
                            Log.i("TaG", "${summarizeReportResponseData}")
                            try {
                                reset()
                                start(1)
                                setTextSize(22)
                                setBold(true)
                                setGray(1)
                                setAlgin(1)
                                printLogo(resizedBitmap, true)
                                addString(" ")
                                addString(
                                    ReportTranslationMapping.getTranslatedReportString(
                                        "Balance/Invoice Report",
                                        languageCode.toString().toString()
                                    )
                                )
                                setBold(true)
                                setItalic(true)
                                addString(balanceInvoiceToAndFromDate.toString())
                                setItalic(false)
                                setBold(false)
                                setTextSize(24)
                                addString(printDashStringData(getPaperLength()))
                                setBold(false)
                                setAlgin(0)
                                setTextSize(20)
                                addString(
                                    "${
                                        ReportTranslationMapping.getTranslatedReportString(
                                            "Org Id : ",
                                            languageCode.toString().toString()
                                        ) + orgId.toString()
                                    }"
                                )
                                addString(
                                    "${
                                        ReportTranslationMapping.getTranslatedReportString(
                                            "Organization Name : ",
                                            languageCode.toString().toString()
                                        ) + orgName.toString()
                                    }"
                                )
                                setTextSize(24)
                                setAlgin(0)
                                addString(printDashStringData(getPaperLength()))
                                setTextSize(22)
                                addString(
                                    printTwoStringStringData(
                                        "${
                                            ReportTranslationMapping.getTranslatedReportString(
                                                "Opening Balance",
                                                languageCode.toString().toString()
                                            )
                                        }",
                                        balanceInvoiceResponseReport?.openingBalance.toString()
                                    )
                                )
                                addString(
                                    printTwoStringStringData(
                                        "${
                                            ReportTranslationMapping.getTranslatedReportString(
                                                "Closing Balance",
                                                languageCode.toString().toString()
                                            )
                                        }",
                                        balanceInvoiceResponseReport?.closingBalance.toString()
                                    )
                                )
                                setBold(false)
                                setItalic(false)
                                setAlgin(0)
                                setTextSize(24)
                                addString(printDashStringData(getPaperLength()))
                                setBold(false)
                                setTextSize(22)
                                addString( printTwoStringStringData(
                                    ReportTranslationMapping.getTranslatedReportString(
                                        "Sales",
                                        languageCode.toString()
                                    ),
                                    balanceInvoiceResponseReport?.sales.toString()

                                ))
                                addString(  printTwoStringStringData(
                                    ReportTranslationMapping.getTranslatedReportString(
                                        "Claims",
                                        languageCode.toString()
                                    ),
                                    balanceInvoiceResponseReport?.claims.toString()

                                ))
                                addString(  printTwoStringStringData(
                                    ReportTranslationMapping.getTranslatedReportString(
                                        "Claim Tax",
                                        languageCode.toString()
                                    ),
                                    balanceInvoiceResponseReport?.claimTax.toString()

                                ))
                                addString(  printTwoStringStringData(
                                    ReportTranslationMapping.getTranslatedReportString(
                                        "Commission Sales",
                                        languageCode.toString()
                                    ),
                                    balanceInvoiceResponseReport?.salesCommission.toString()

                                ))

                                addString( printTwoStringStringData(
                                    ReportTranslationMapping.getTranslatedReportString(
                                        "Commission Winnings",
                                        languageCode.toString()
                                    ),
                                    balanceInvoiceResponseReport?.winningsCommission.toString()

                                ))

                                addString(  printTwoStringStringData(
                                    ReportTranslationMapping.getTranslatedReportString(
                                        "Payments",
                                        languageCode.toString()
                                    ),
                                    balanceInvoiceResponseReport?.payments.toString()

                                ))

                                addString(printTwoStringStringData(
                                    ReportTranslationMapping.getTranslatedReportString(
                                        "Debit/Credit txn",
                                        languageCode.toString()
                                    ),
                                    balanceInvoiceResponseReport?.creditDebitTxn.toString()

                                ))
                                setTextSize(24)
                                addString(printLineStringData(getPaperLength()))
                                addString(" ")
                                printString()
                                activity.runOnUiThread {
                                    Toast.makeText(
                                        activity,
                                        DrawGameTranslationMapping.getTranslatedDrawGameString(
                                            "Successfully printed",
                                            languageCode.toString()
                                        ),
                                        Toast.LENGTH_SHORT
                                    ).show()
                                }
                                result.success(true)

                            } catch (e: java.lang.Exception) {
                                showMsgAccordingToException(e as CommonException, result)
                                stop()
                                e.printStackTrace()
                            }
                        }

                    }
                    else {
                        result.error(
                            "-1",
                            "Unable to find printer",
                            "no sunmi or no usb thermal printer"
                        )
                    }
                }
            }
            /*
                        else if (call.method == "operationalCashReport") {

                            val bitmap =
                                BitmapFactory.decodeResource(context.resources, R.drawable.longa_lotto_retail)
                            val resizedBitmap = Bitmap.createScaledBitmap(bitmap, 280, 70, false)

                            this.let {
                                val usbThermalPrinter = UsbThermalPrinter(activity.baseContext)


                                if (getDeviceName() == "QUALCOMM M1" || getDeviceModelName()=="m1k_go") {
                                    usbThermalPrinter.run {
                                        Log.i("TaG", "${summarizeReportResponseData}")
                                        try {
                                            reset()
                                            start(1)
                                            setTextSize(22)
                                            setBold(true)
                                            setGray(1)
                                            setAlgin(1)
                                            printLogo(resizedBitmap, true)
                                            addString(" ")
                                            addString(
                                                ReportTranslationMapping.getTranslatedReportString(
                                                    "Balance/Invoice Report",
                                                    languageCode.toString().toString()
                                                )
                                            )
                                            setBold(true)
                                            setItalic(true)
                                            addString(balanceInvoiceToAndFromDate.toString())
                                            setItalic(false)
                                            setBold(false)
                                            setTextSize(24)
                                            addString(printDashStringData(getPaperLength()))
                                            setBold(false)
                                            setAlgin(0)
                                            setTextSize(20)
                                            addString(
                                                "${
                                                    ReportTranslationMapping.getTranslatedReportString(
                                                        "Org Id : ",
                                                        languageCode.toString().toString()
                                                    ) + orgId.toString()
                                                }"
                                            )
                                            addString(
                                                "${
                                                    ReportTranslationMapping.getTranslatedReportString(
                                                        "Organization Name : ",
                                                        languageCode.toString().toString()
                                                    ) + orgName.toString()
                                                }"
                                            )
                                            setTextSize(24)
                                            setAlgin(0)
                                            addString(printDashStringData(getPaperLength()))
                                            setTextSize(24)
                                            setAlgin(1)
                                            for (data in operationalCashReport.gameWiseData) {
                                                setBold(true)
                                                addString(data.gameName)
                                                setBold(false)

                                            }

                                            setBold(false)
                                            setItalic(false)
                                            setAlgin(0)
                                            setTextSize(24)
                                            addString(printDashStringData(getPaperLength()))
                                            setBold(false)
                                            setTextSize(22)
                                            addString( printTwoStringStringData(
                                                ReportTranslationMapping.getTranslatedReportString(
                                                    "Sales",
                                                    languageCode.toString()
                                                ),
                                                balanceInvoiceResponseReport?.sales.toString()

                                            ))
                                            addString(  printTwoStringStringData(
                                                ReportTranslationMapping.getTranslatedReportString(
                                                    "Claims",
                                                    languageCode.toString()
                                                ),
                                                balanceInvoiceResponseReport?.claims.toString()

                                            ))
                                            addString(  printTwoStringStringData(
                                                ReportTranslationMapping.getTranslatedReportString(
                                                    "Claim Tax",
                                                    languageCode.toString()
                                                ),
                                                balanceInvoiceResponseReport?.claimTax.toString()

                                            ))
                                            addString(  printTwoStringStringData(
                                                ReportTranslationMapping.getTranslatedReportString(
                                                    "Commission Sales",
                                                    languageCode.toString()
                                                ),
                                                balanceInvoiceResponseReport?.salesCommission.toString()

                                            ))

                                            addString( printTwoStringStringData(
                                                ReportTranslationMapping.getTranslatedReportString(
                                                    "Commission Winnings",
                                                    languageCode.toString()
                                                ),
                                                balanceInvoiceResponseReport?.winningsCommission.toString()

                                            ))

                                            addString(  printTwoStringStringData(
                                                ReportTranslationMapping.getTranslatedReportString(
                                                    "Payments",
                                                    languageCode.toString()
                                                ),
                                                balanceInvoiceResponseReport?.payments.toString()

                                            ))

                                            addString(printTwoStringStringData(
                                                ReportTranslationMapping.getTranslatedReportString(
                                                    "Debit/Credit txn",
                                                    languageCode.toString()
                                                ),
                                                balanceInvoiceResponseReport?.creditDebitTxn.toString()

                                            ))
                                            setTextSize(24)
                                            addString(printLineStringData(getPaperLength()))
                                            addString(" ")
                                            printString()
                                            activity.runOnUiThread {
                                                Toast.makeText(
                                                    activity,
                                                    DrawGameTranslationMapping.getTranslatedDrawGameString(
                                                        "Successfully printed",
                                                        languageCode.toString()
                                                    ),
                                                    Toast.LENGTH_SHORT
                                                ).show()
                                            }
                                            result.success(true)

                                        } catch (e: java.lang.Exception) {
                                            showMsgAccordingToException(e as CommonException, result)
                                            stop()
                                            e.printStackTrace()
                                        }
                                    }

                                }
                                else {
                                    result.error(
                                        "-1",
                                        "Unable to find printer",
                                        "no sunmi or no usb thermal printer"
                                    )
                                }
                            }
                        }
            */
        }

        channel_pos = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, mChannelForPos)

        channel_pos.setMethodCallHandler { call, result ->

            if (!Settings.canDrawOverlays(applicationContext)) {
                startActivity(Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION));
            }

            mDisableClick = false

            startService(Intent(this, SampleForegroundService::class.java))

            val am = getSystemService(ACTIVITY_SERVICE) as ActivityManager
            if (am != null) {
                val tasks = am.appTasks
                if (tasks != null && tasks.size > 0) {
                    tasks[0].setExcludeFromRecents(true)
                }
            }

            object : CountDownTimer(60000, 1000) {
                override fun onTick(millisUntilFinished: Long) {
                }

                override fun onFinish() {
                    mDisableClick = true

                    val activityManager =
                        applicationContext.getSystemService(ACTIVITY_SERVICE) as ActivityManager
                    activityManager.moveTaskToFront(taskId, 0)

                    val intent = Intent(this@MainActivity, this@MainActivity.javaClass)
                    startActivity(intent)

                    stopService(Intent(this@MainActivity, SampleForegroundService::class.java))

                }
            }.start()
            startActivity(Intent(Settings.ACTION_WIRELESS_SETTINGS))
        }


        channel_print = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, mChannelForPrint)

        channel_print.setMethodCallHandler { call, result ->

            val argument = call.arguments as Map<*, *>
            val userName = argument["userName"]
            val userId = argument["userId"]
            val couponCode = argument["couponCode"]
            val currencyCode = argument["currencyCode"]
            val amount = argument["Amount"]
            val url = argument["url"]

            val bitmap =
                BitmapFactory.decodeResource(context.resources, R.drawable.longa_lotto_retail)
            val logo = Bitmap.createScaledBitmap(bitmap, 280, 70, false)

            val bitmapEighteenPlus =
                BitmapFactory.decodeResource(context.resources, R.drawable.eighteen_plus_new)
            val logoEighteenPlus = Bitmap.createScaledBitmap(bitmapEighteenPlus, 80, 80, false)

            if (call.method == "notificationPrint") {
                Log.d("TAg", "configureFlutterEngine: notificationPrint method")
                Glide.with(context).asBitmap().load(url).into(object : CustomTarget<Bitmap>() {
                    override fun onResourceReady(
                        resource: Bitmap,
                        transition: com.bumptech.glide.request.transition.Transition<in Bitmap>?
                    ) {
                        val recreatedQrBitmap = Bitmap.createScaledBitmap(resource, 370, 370, true)
                        mSunmiPrinterService?.run {
                            enterPrinterBuffer(true)
                            setAlignment(1, null)
                            sendRAWData(boldFontEnable, null)
                            setFontSize(32f, null)
                            printText("\n---- ${userName} -----", null)
                            sendRAWData(boldFontDisable, null)
                            setFontSize(27f, null)
                            printText("\n${if (userId != 0) "ID : ${userId}" else ""}", null)
                            sendRAWData(boldFontEnable, null)
                            setFontSize(27f, null)
                            printText("\n\n\n----- Amount: ${amount} -----", null)
                            sendRAWData(boldFontDisable, null)
                            printBitmapCustom(recreatedQrBitmap, 0, null)
                            printText("\n-------------------------\n", null)
                            sendRAWData(boldFontEnable, null)
                            setFontSize(23f, null)
                            setAlignment(0, null)
                            printText(
                                "*Note : Please do not fold and\n" + "always keep this receipt with \n you when you want" + " cash out \n your remaining game" + " balance. Go to game portal for " + "initiate withdrawal.",
                                null
                            )
                            printText(" Go to game portal for \ninitiate withdrawal.", null)
                            sendRAWData(boldFontDisable, null)
                            setAlignment(1, null)
                            printText("\n--------------------------\n", null)
                            printText("\nn\n", null)
                            exitPrinterBufferWithCallback(true, object : InnerResultCallback() {
                                override fun onRunResult(isSuccess: Boolean) {}

                                override fun onReturnString(result: String?) {}

                                override fun onRaiseException(code: Int, msg: String?) {
                                    activity.runOnUiThread {
                                        Toast.makeText(
                                            activity,
                                            "Something went wrong while printing, Please try again",
                                            Toast.LENGTH_SHORT
                                        ).show()
                                    }
                                    result.error("-1", msg, "Something went wrong while printing")
                                }

                                override fun onPrintResult(code: Int, msg: String?) {
                                    if (updatePrinterState() != 1) {
                                        activity.runOnUiThread {
                                            Toast.makeText(
                                                activity,
                                                "Something went wrong while printing, Please try again",
                                                Toast.LENGTH_SHORT
                                            ).show()
                                        }
                                        result.error(
                                            "-1",
                                            msg,
                                            "Something went wrong while printing"
                                        )

                                    } else {
                                        activity.runOnUiThread {
                                            Toast.makeText(
                                                activity, "Impression réussie", Toast.LENGTH_SHORT
                                            ).show()
                                        }
                                        result.success(true)
                                    }
                                }
                            })

                        } ?: this.let {

                            val usbThermalPrinter = UsbThermalPrinter(activity.baseContext)
                            if (getDeviceName() == "QUALCOMM M1" || getDeviceModelName()=="m1k_go" ) {
                                try {
                                    usbThermalPrinter.run {
                                        reset()
                                        start(1)
                                        setGray(1)
                                        setAlgin(1)
                                        printLogo(logo, true)
                                        setTextSize(32)
                                        setBold(true)
                                        setAlgin(1)
                                        setTextSize(27)
                                        addString("---- $userName -----")
                                        setTextSize(22)
                                        setAlgin(1)
                                        addString("Ticket: $couponCode")
                                        setAlgin(1)
                                        setTextSize(34)
                                        addString("Montant: $currencyCode ${amount}")
                                        setGray(0)
                                        printLogo(recreatedQrBitmap, true)
                                        setTextSize(22)
                                        setBold(true)
                                        addString("Date : ${getCurrentDateTime()}")
                                        setBold(false)
                                        setTextSize(20)
                                        //addString("*Note :  Please do not fold and\n" +"always keep this receipt with \n you when you want" + " cash out \n your remaining game" + " balance. Go to game portal for " + "initiate withdrawal.")
                                        addString(
                                            "*NB :  La validité de ce ticket est de 7 jours ; passé ce délai,le\n" + "ticket perd sa valeur.Longa Games\n" + " décline toute responsabilité liée à la " + "dégradation ou perte du ticket."
                                        )
                                        addString(
                                            "VEUILLEZ PRESENTER CE TICKET A LA CAISSE POUR LE " + "RETRAIT DU SOLDE DE\nVOTRE BALANCE DE JEUX"
                                        )
                                        setAlgin(1)
                                        printLogo(logoEighteenPlus, true)
                                        setTextSize(24)
                                        addString(printDashStringData(getPaperLength()))
                                        addString("\n")
                                        printString()

                                        activity.runOnUiThread {
                                            Toast.makeText(
                                                activity, "Impression réussie", Toast.LENGTH_SHORT
                                            ).show()
                                        }
                                        result.success(true)
                                    }


                                } catch (e: java.lang.Exception) {
                                    showMsgAccordingToException(e as CommonException, result)
                                    stop()
                                    e.printStackTrace()
                                }
                            } else {
                                android.util.Log.d("TAg", "configureFlutterEngine: no printer")
                                result.error(
                                    "-1",
                                    "Unable to find printer",
                                    "no sunmi or no usb thermal printer"
                                )
                            }
                        }
                    }

                    override fun onLoadCleared(placeholder: Drawable?) {

                    }

                });
            }
        }

        channel_app_update =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, mChannelForAppUpdate)

        channel_app_update.setMethodCallHandler { call, result ->
            val argument = call.arguments!! as Map<*, *>;
            val downloadUrl = argument["url"]
            downloadController = DownloadController(activity, downloadUrl.toString())

            if (call.method == "_downloadUpdatedAPK") {
                Log.d("TaG", "url----->$downloadUrl")
                val downloadApk = DownloadApk(activity)
                downloadApk.startDownloadingApk(
                    downloadUrl.toString(),
                    "longa_lotto_retail_updated" + System.currentTimeMillis() + ".apk"
                )
                //downloadController.enqueueDownload()
                //val downloadController = downloadController.enqueueDownload()
                /*if (downloadController) {
                    result.error("-1", "Unable to download, Please try after some time.", "")
                }*/
            }
        }

        channel_reports_print =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, mChannelForAppReportPrint)

        channel_reports_print.setMethodCallHandler { call, result ->
            val argument = call.arguments!! as Map<*, *>;
            val downloadUrl = argument["url"]
            if (call.method == "summarizeLedgerReport") {

                Log.d("TaG", "<-- summarizeLedgerReport -->")
                val bitmap =
                    BitmapFactory.decodeResource(context.resources, R.drawable.longa_lotto_retail)
                val resizedBitmap = Bitmap.createScaledBitmap(bitmap, 280, 70, false)

                mSunmiPrinterService?.run {

                    enterPrinterBuffer(true)
                    setAlignment(1, null)
                    printBitmapCustom(resizedBitmap, 1, null)
                    sendRAWData(boldFontEnable, null)
                    setFontSize(24f, null)
                    printText("\n\nSummarized Ledger Report", null)
                    sendRAWData(boldFontDisable, null)
                    printText("\nPurchase Time", null)
                    val purchaseDate: String = "24/ 09/ 2023"
                    val purchaseTime: String = "30/ 09/ 2023"
                    printText(
                        "\n${getFormattedDate(purchaseDate)} ${getFormattedTime(purchaseTime)}",
                        null
                    )
                    sendRAWData(boldFontEnable, null)
                    printText("\n\n", null)
                    exitPrinterBufferWithCallback(true, object : InnerResultCallback() {
                        override fun onRunResult(isSuccess: Boolean) {}

                        override fun onReturnString(result: String?) {}

                        override fun onRaiseException(code: Int, msg: String?) {
                            activity.runOnUiThread {
                                Toast.makeText(
                                    activity,
                                    "Something went wrong while printing, Please try again",
                                    Toast.LENGTH_SHORT
                                ).show()
                            }
                            result.error("-1", msg, "Something went wrong while printing")
                        }

                        override fun onPrintResult(code: Int, msg: String?) {
                            if (updatePrinterState() != 1) {
                                activity.runOnUiThread {
                                    Toast.makeText(
                                        activity,
                                        "Something went wrong while printing, Please try again",
                                        Toast.LENGTH_SHORT
                                    ).show()
                                }
                                result.error("-1", msg, "Something went wrong while printing")

                            } else {
                                activity.runOnUiThread {
                                    Toast.makeText(
                                        activity, "Impression réussie", Toast.LENGTH_SHORT
                                    ).show()
                                }
                                result.success(true)
                            }
                        }
                    })
                } ?: this.let {
                    val usbThermalPrinter = UsbThermalPrinter(activity.baseContext)
                    if (getDeviceName() == "QUALCOMM M1" || getDeviceModelName()=="m1k_go") {
                        usbThermalPrinter.run {
                            try {
                                reset()
                                start(1)
                                setTextSize(28)
                                addString("")
                                setBold(true)
                                setGray(1)
                                setAlgin(1)
                                printLogo(resizedBitmap, true)
                                addString("")
                                setTextSize(22)
                                val purchaseDate: String = "24/ 09/ 2023"
                                val purchaseTime: String = "30/ 09/ 2023"
                                setItalic(true)
                                setBold(true)
                                addString(printDashStringData(getPaperLength()))
                                addString("\n\n")
                                printString()
                                activity.runOnUiThread {
                                    Toast.makeText(
                                        activity, "Impression réussie", Toast.LENGTH_SHORT
                                    ).show()
                                }
                                result.success(true)

                            } catch (e: java.lang.Exception) {
                                showMsgAccordingToException(e as CommonException, result)
                                stop()
                                e.printStackTrace()
                            }
                        }

                    } else {
                        android.util.Log.d("TAg", "configureFlutterEngine: no printer")
                        result.error(
                            "-1", "Unable to find printer", "no sunmi or no usb thermal printer"
                        )
                    }
                }
            }
        }

        channel_afterWithdrawal =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, mChannelForAppAfterWithdrawal)

        channel_afterWithdrawal.setMethodCallHandler { call, result ->
            val argument = call.arguments!! as Map<*, *>;
            val username = argument["username"]
            val withdrawalAmt = argument["withdrawalAmt"]


            if (call.method == "afterWithdrawal") {
                Log.d("TaG", "<-- afterWithdrawal -->")
                val bitmap =
                    BitmapFactory.decodeResource(context.resources, R.drawable.longa_lotto_retail)
                val resizedBitmap = Bitmap.createScaledBitmap(bitmap, 280, 70, false)

                mSunmiPrinterService?.run {

                    enterPrinterBuffer(true)
                    setAlignment(1, null)
                    printBitmapCustom(resizedBitmap, 1, null)
                    sendRAWData(boldFontEnable, null)
                    setFontSize(24f, null)
                    printText("\n\nWithdrawal Confirmation", null)
                    sendRAWData(boldFontDisable, null)
                    printText("\nPurchase Time", null)
                    val purchaseDate: String = "24/ 09/ 2023"
                    val purchaseTime: String = "30/ 09/ 2023"
                    printText(
                        "\n${getFormattedDate(purchaseDate)} ${getFormattedTime(purchaseTime)}",
                        null
                    )
                    sendRAWData(boldFontEnable, null)
                    printText("\n\n", null)
                    exitPrinterBufferWithCallback(true, object : InnerResultCallback() {
                        override fun onRunResult(isSuccess: Boolean) {}

                        override fun onReturnString(result: String?) {}

                        override fun onRaiseException(code: Int, msg: String?) {
                            activity.runOnUiThread {
                                Toast.makeText(
                                    activity,
                                    "Something went wrong while printing, Please try again",
                                    Toast.LENGTH_SHORT
                                ).show()
                            }
                            result.error("-1", msg, "Something went wrong while printing")
                        }

                        override fun onPrintResult(code: Int, msg: String?) {
                            if (updatePrinterState() != 1) {
                                activity.runOnUiThread {
                                    Toast.makeText(
                                        activity,
                                        "Something went wrong while printing, Please try again",
                                        Toast.LENGTH_SHORT
                                    ).show()
                                }
                                result.error("-1", msg, "Something went wrong while printing")

                            } else {
                                activity.runOnUiThread {
                                    Toast.makeText(
                                        activity, "Impression réussie", Toast.LENGTH_SHORT
                                    ).show()
                                }
                                result.success(true)
                            }
                        }
                    })
                } ?: this.let {
                    val usbThermalPrinter = UsbThermalPrinter(activity.baseContext)
                    if (getDeviceName() == "QUALCOMM M1" || getDeviceModelName()=="m1k_go") {
                        usbThermalPrinter.run {
                            try {
                                reset()
                                start(1)
                                setTextSize(28)
                                setBold(false)
                                setGray(1)
                                setAlgin(1)
                                printLogo(resizedBitmap, true)
                                addString("---- $username -----")
                                setBold(true)
                                setTextSize(20)
                                addString("Date : ${getCurrentDateTime()}")
                                setTextSize(22)
                                addString("Montant du retrait : $withdrawalAmt")
                                setTextSize(22)
                                setItalic(true)
                                addString("-------* * *-------")
                                addString("\n")
                                printString()
                                activity.runOnUiThread {
                                    Toast.makeText(
                                        activity, "Impression réussie", Toast.LENGTH_SHORT
                                    ).show()
                                }
                                result.success(true)

                            } catch (e: java.lang.Exception) {
                                showMsgAccordingToException(e as CommonException, result)
                                stop()
                                e.printStackTrace()
                            }
                        }

                    } else {
                        android.util.Log.d("TAg", "configureFlutterEngine: no printer")
                        result.error(
                            "-1", "Unable to find printer", "no sunmi or no usb thermal printer"
                        )
                    }
                }
            }
        }
    }

    private fun showMsgAccordingToException(
        exception: CommonException, result: MethodChannel.Result
    ) {

        when (exception) {
            is NoPaperException -> result.error(
                "-1", "Please insert the paper before printing", "${exception.message}"
            )

            is OverHeatException -> result.error(
                "-2", "Device overheated, Please try after some time.", "${exception.message}"
            )

            is GateOpenException -> result.error(
                "-3", "Something went wrong while printing", "${exception.message}"
            )

            is PaperCutException -> result.error(
                "-3", "Something went wrong while printing", "${exception.message}"
            )

            is TimeoutException -> result.error(
                "-4", "Unable to print, Please try after some time.", "${exception.message}"
            )

            is FontErrorException -> result.error(
                "-3", "Something went wrong while printing", "${exception.message}"
            )

            is LowPowerException -> result.error(
                "-5", "Low battery, Please charge the device !", "${exception.message}"
            )

            else -> result.error(
                "-3", "Something went wrong while printing", "${exception.message}"
            )

        }
    }

    private fun capitalize(s: String?): String {
        if (s == null || s.isEmpty()) {
            return ""
        }
        val first = s[0]
        return if (Character.isUpperCase(first)) {
            s
        } else {
            first.uppercaseChar().toString() + s.substring(1)
        }
    }

    private fun getDeviceName(): String {
        val manufacturer = Build.MANUFACTURER
        val model = Build.MODEL
        return if (model.lowercase(Locale.getDefault()).startsWith(
                manufacturer.lowercase(
                    Locale.getDefault()
                )
            )
        ) {
            capitalize(model)
        } else {
            if (model.equals(
                    "T2mini_s", ignoreCase = true
                )
            ) capitalize(manufacturer) + " T2mini" else capitalize(manufacturer) + " " + model
        }
    }

    private fun getDeviceModelName(): String {
        return Build.MODEL.toString().toLowerCase();
    }

    private fun initializeSunmiPrinter() {
        try {
            InnerPrinterManager.getInstance().bindService(this, innerPrinterCallback)
        } catch (e: InnerPrinterException) {
            e.printStackTrace()
        }
    }

    private var innerPrinterCallback: InnerPrinterCallback = object : InnerPrinterCallback() {
        override fun onConnected(sunmiPrinterService: SunmiPrinterService) {
            mSunmiPrinterService = sunmiPrinterService
        }

        override fun onDisconnected() {}
    }

    @SuppressLint("SimpleDateFormat")
    fun getFormattedDate(sourceDate: String): String {
        val input = SimpleDateFormat("dd-MM-yyyy")
        val output = SimpleDateFormat("MMM dd, yyyy")
        try {
            input.parse(sourceDate)?.let {
                return output.format(it)
            }
        } catch (e: Exception) {
            Log.e("log", "Date parsing error: ${e.message}")
        }
        return sourceDate
    }

    fun getFormattedDateForWinClaim(sourceDate: String): String {
        val input = SimpleDateFormat("yyyy-MM-dd")
        val output = SimpleDateFormat("MMM dd, yyyy")
        try {
            input.parse(sourceDate)?.let {
                return output.format(it)
            }
        } catch (e: Exception) {
            Log.e("log", "Date parsing error: ${e.message}")
        }
        return sourceDate
    }

    @SuppressLint("SimpleDateFormat")
    fun getFormattedTime(sourceTime: String): String {
        val input = SimpleDateFormat("HH:mm:ss")
        val output = SimpleDateFormat("HH:mm:ss")
        try {
            input.parse(sourceTime)?.let {
                return output.format(it)
            }
        } catch (e: Exception) {
            Log.e("log", "Date parsing error: ${e.message}")
        }
        return sourceTime
    }

    private fun getPaperLength(): Int {
        return "--------------------------".length
    }

    private fun printDashStringData(length: Int): String {
        val str = StringBuffer()
        for (i in 0..length) {
            str.append("-")
        }
        return str.toString()
    }

    private fun printLineStringData(length: Int): String {
        val str = StringBuffer()
        for (i in 0..length) {
            str.append("_")
        }
        return str.toString()
    }

    private fun printTwoStringStringData(one: String, two: String): String {
        val str = StringBuffer()
        val spaceInBetween = getPaperLength() - (one.length + two.length)
        Log.d("TAg", "printTwoStringStringData: $spaceInBetween")
        str.append(one)
        for (i in 0..spaceInBetween) {
            str.append("  ")
        }
        str.append(two)
        return str.toString()
    }

    fun getCurrentDateTime(): String {
        val calendar = Calendar.getInstance()
        val year = calendar.get(Calendar.YEAR)
        val month = calendar.get(Calendar.MONTH) + 1 // Month is 0-based, so add 1
        val day = calendar.get(Calendar.DAY_OF_MONTH)
        val hour = calendar.get(Calendar.HOUR_OF_DAY) // 24-hour format
        val minute = calendar.get(Calendar.MINUTE)
        val second = calendar.get(Calendar.SECOND)

        val dateTime = "$day/$month/$year $hour:$minute:$second"
        return dateTime
    }

 /*   override fun onBackPressed() {

    }*/

    override fun onPause() {
        super.onPause()
        /*if (mDisableClick) {
            val activityManager =
                applicationContext.getSystemService(ACTIVITY_SERVICE) as ActivityManager
            activityManager.moveTaskToFront(taskId, 0)
        }*/
    }


    override fun onStop() {
        super.onStop()
        /*if (mDisableClick) {
            val activityManager =
                applicationContext.getSystemService(ACTIVITY_SERVICE) as ActivityManager
            activityManager.moveTaskToFront(taskId, 0)
        }*/
    }


    companion object {
        const val ACTION_STOP_FOREGROUND = "com.example.myapplication.stopforeground"
    }

    @SuppressLint("WrongConstant")
    fun collapseNow() {

        // Use reflection to trigger a method from 'StatusBarManager'
        val statusBarService = getSystemService("statusbar")
        var statusBarManager: Class<*>? = null
        try {
            statusBarManager = Class.forName("android.app.StatusBarManager")
        } catch (e: ClassNotFoundException) {
            e.printStackTrace()
        }
        var collapseStatusBar: Method? = null
        try {

            // Prior to API 17, the method to call is 'collapse()'
            // API 17 onwards, the method to call is `collapsePanels()`
            collapseStatusBar = if (Build.VERSION.SDK_INT > 16) {
                statusBarManager!!.getMethod("collapsePanels")
            } else {
                statusBarManager!!.getMethod("collapse")
            }
        } catch (e: NoSuchMethodException) {
            e.printStackTrace()
        }
        collapseStatusBar!!.isAccessible = true
        try {
            collapseStatusBar.invoke(statusBarService)
        } catch (e: IllegalArgumentException) {
            e.printStackTrace()
        } catch (e: IllegalAccessException) {
            e.printStackTrace()
        } catch (e: InvocationTargetException) {
            e.printStackTrace()
        }
    }


}
