package com.skilrock.longalottoretail

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.ActivityNotFoundException
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log


class BootUpReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, p1: Intent?) {
        if (context != null) {
            restartApp(context)
        };
    }

    private fun restartApp(mContext: Context) {
        try {
            val intents = mContext.packageManager.getLaunchIntentForPackage(mContext.packageName)
            val restartIntent =
                PendingIntent.getActivity(
                    mContext,
                    0,
                    intents,
                    PendingIntent.FLAG_ONE_SHOT or PendingIntent.FLAG_IMMUTABLE
                )
            val mgr = mContext.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                mgr.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    System.currentTimeMillis()-1000 ,
                    restartIntent
                )
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                mgr.setExact(
                    AlarmManager.RTC_WAKEUP,
                    System.currentTimeMillis()-1000 ,
                    restartIntent
                )
            }
        } catch (e: Exception) {
            Log.e("TAG", e.message!!)
        }
    }
}

