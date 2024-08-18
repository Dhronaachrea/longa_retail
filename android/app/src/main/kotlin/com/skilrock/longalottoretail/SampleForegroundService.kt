package com.skilrock.longalottoretail

import android.annotation.SuppressLint
import android.app.Activity
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationChannelGroup
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.PixelFormat
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import android.view.Gravity
import android.view.MotionEvent
import android.view.ViewGroup
import android.view.WindowManager
import androidx.core.app.NotificationCompat
import com.skilrock.longalottoretail.MainActivity.Companion.ACTION_STOP_FOREGROUND
import java.lang.reflect.InvocationTargetException
import java.lang.reflect.Method
import java.util.Timer
import java.util.TimerTask


class SampleForegroundService : Service() {
    val handler = Handler(Looper.getMainLooper())
    var runnable: Runnable = Runnable { }
    val delay = 100

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private var context: Context? = null

    override fun onCreate() {
        super.onCreate()
        context = this
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action != null && intent.action.equals(
                ACTION_STOP_FOREGROUND, ignoreCase = true
            )
        ) {
            handler.removeCallbacks(runnable)
            stopForeground(true)
            stopSelf()
        }
        //  context?.let { preventStatusBarExpansion(it) }
        onWindowFocusChanged(false)


        runnable = object : Runnable {
            override fun run() {
                collapseNow()
                handler.postDelayed(this, 100)
            }
        }
        handler.postDelayed(runnable, 0)

        generateForegroundNotification()
        //  return START_STICKY
        //Normal Service To test sample service comment the above    generateForegroundNotification() && return START_STICKY
        // Uncomment below return statement And run the app.
        return START_NOT_STICKY
    }

    //Notififcation for ON-going
    private var iconNotification: Bitmap? = null
    private var notification: Notification? = null
    var mNotificationManager: NotificationManager? = null
    private val mNotificationId = 123

    private fun generateForegroundNotification() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val intentMainLanding = Intent(this, MainActivity::class.java)
            val pendingIntent =
                PendingIntent.getActivity(this, 0, intentMainLanding, PendingIntent.FLAG_IMMUTABLE)
            iconNotification = BitmapFactory.decodeResource(resources, R.mipmap.ic_launcher)
            if (mNotificationManager == null) {
                mNotificationManager =
                    this.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                assert(mNotificationManager != null)
                mNotificationManager?.createNotificationChannelGroup(
                    NotificationChannelGroup("chats_group", "Chats")
                )
                val notificationChannel =
                    NotificationChannel(
                        "service_channel", "Service Notifications",
                        NotificationManager.IMPORTANCE_MIN
                    )
                notificationChannel.enableLights(false)
                notificationChannel.lockscreenVisibility = Notification.VISIBILITY_SECRET
                mNotificationManager?.createNotificationChannel(notificationChannel)
            }
            val builder = NotificationCompat.Builder(this, "service_channel")

            builder.setContentTitle(
                StringBuilder(resources.getString(R.string.app_name)).append(" service is running")
                    .toString()
            )
                .setTicker(
                    StringBuilder(resources.getString(R.string.app_name)).append("service is running")
                        .toString()
                )
                .setContentText("Touch to open") //                    , swipe down for more options.
                .setPriority(NotificationCompat.PRIORITY_LOW)
                .setWhen(0)
                .setOnlyAlertOnce(true)
                .setContentIntent(pendingIntent)
                .setOngoing(true)
            if (iconNotification != null) {
                builder.setLargeIcon(Bitmap.createScaledBitmap(iconNotification!!, 128, 128, false))
            }
            notification = builder.build()
            startForeground(mNotificationId, notification)
        }

    }

    fun preventStatusBarExpansion(context: Context) {
        val manager = context.applicationContext
            .getSystemService(WINDOW_SERVICE) as WindowManager
        val activity = context as Activity
        val localLayoutParams = WindowManager.LayoutParams()
        localLayoutParams.type = WindowManager.LayoutParams.TYPE_SYSTEM_ERROR
        localLayoutParams.gravity = Gravity.TOP
        localLayoutParams.flags =
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or  // this is to enable the notification to recieve touch events
                    WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or  // Draws over status bar
                    WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN
        localLayoutParams.width = WindowManager.LayoutParams.MATCH_PARENT
        //https://stackoverflow.com/questions/1016896/get-screen-dimensions-in-pixels
        val resId = activity.resources.getIdentifier("status_bar_height", "dimen", "android")
        var result = 0
        if (resId > 0) {
            result = activity.resources.getDimensionPixelSize(resId)
        }
        localLayoutParams.height = result
        localLayoutParams.format = PixelFormat.TRANSPARENT
        val view = customViewGroup(context)
        manager.addView(view, localLayoutParams)
    }

    class customViewGroup(context: Context?) : ViewGroup(context) {
        override fun onLayout(changed: Boolean, l: Int, t: Int, r: Int, b: Int) {}
        override fun onInterceptTouchEvent(ev: MotionEvent): Boolean {
            Log.v("customViewGroup", "**********Intercepted")
            return true
        }
    }

    @SuppressLint("WrongConstant")
    fun onWindowFocusChanged(hasFocus: Boolean) {
        try {
            if (!hasFocus) {
                val service = getSystemService("statusbar")
                val statusbarManager = Class.forName("android.app.StatusBarManager")
                val collapse =
                    statusbarManager.getMethod(if (Build.VERSION.SDK_INT > 16) "collapsePanels" else "collapse")
                collapse.isAccessible = true
                collapse.invoke(service)
            }
        } catch (ex: Exception) {
        }
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

