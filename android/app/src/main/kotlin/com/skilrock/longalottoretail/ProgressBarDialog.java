package com.skilrock.longalottoretail;

import android.app.Activity;
import android.app.DownloadManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.database.Cursor;
import android.graphics.drawable.ColorDrawable;
import android.os.CountDownTimer;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

import org.jetbrains.annotations.NotNull;

import java.util.Objects;

public class ProgressBarDialog {

    private static ProgressBarDialog progresDialog;
    public android.app.ProgressDialog dialog;
    public Context context;
    int value = 0;
    boolean isCountDown = true;
    private TextView tvTitle;
    private ProgressBarDialog() {
    }

    public static synchronized ProgressBarDialog getProgressDialog() {
        if (progresDialog == null) {
            progresDialog = new ProgressBarDialog();
        }

        return progresDialog;
    }

    public void showProgressWithText(Activity context, String text, long downloadId, DownloadManager downloadManager) {
        this.context = context;
        dismiss();
        isCountDown = false;

        if (countDownTimer != null)
            countDownTimer.cancel();

        /*context.registerReceiver(internetSpeedReceiver, new IntentFilter( "com.skilrock.retailapp.internetspeed"));

        IndicatorServiceHelper.startService(context);*/

        dialog = new android.app.ProgressDialog(context);
        Window window = dialog.getWindow();
        if (window != null)
            window.setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));

        dialog.setIndeterminate(true);
        dialog.setCancelable(false);
        dialog.show();
        dialog.setContentView(R.layout.custom_progress_dialog);
        tvTitle = dialog.findViewById(R.id.tv_text);
        TextView tvProgress = dialog.findViewById(R.id.tv_progress);
        if (tvProgress != null) {
            tvProgress.setVisibility(View.VISIBLE);
            tvProgress.setText(text);
        }

        showProgressInfo(downloadId, downloadManager, tvProgress, context, text);
    }

    private void showProgressInfo(long downloadId, DownloadManager downloadManager, TextView tvTitle, Activity activity, String text){
        try {
            Thread mProgressThread = new Thread(new Runnable() {
                @Override
                public void run() {
                    DownloadManager.Query query = new DownloadManager.Query();
                    query.setFilterById(downloadId);
                    Cursor c;
                    while (true) {
                        c = downloadManager.query(query);
                        if (c != null) {

                            while (c.moveToNext()) {
                                Log.d("currentThread", Thread.currentThread().getName());

                                int sizeIndex = c.getColumnIndex(DownloadManager.COLUMN_TOTAL_SIZE_BYTES);
                                int downloadedIndex = c.getColumnIndex(DownloadManager.COLUMN_BYTES_DOWNLOADED_SO_FAR);
                                long size = c.getInt(sizeIndex);
                                long downloaded = c.getInt(downloadedIndex);
                                double progress = 0.0;
                                if (size != -1)
                                    progress = downloaded * 100.0 / size;
                                Log.d("PERCENTAGE", progress + "");
                                value = (int) progress; // 6

                                activity.runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        tvTitle.setText(text + " " + value + "%");
                                    }
                                });

                            }
                            c.close();
                            if (value == 100) {
                                return;
                            }
                        }
                    }
                }
            });

            mProgressThread.start();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void dismiss() {
        if (internetSpeedReceiver != null && context != null)
            try {
                context.unregisterReceiver(internetSpeedReceiver);
            } catch (Exception e) {
                // already unregistered
            }

//        if (context != null)
//            context.getApplicationContext().stopService(new Intent(context, IndicatorService.class));

        try {
            if (dialog != null && dialog.isShowing()) {
                dialog.dismiss();
                dialog.cancel();
            }
        } catch (Exception e) {
            Log.e("LOG", "dismiss: " + e.getMessage());
        }
    }

    BroadcastReceiver internetSpeedReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, @NotNull Intent intent) {
            String speedText = intent.getStringExtra("speed");
            double totalSpeed = intent.getDoubleExtra("speed_int", 0);
            //setValue(tvSpeed, Data, totalSpeed);
            if (tvTitle != null)
                tvTitle.setText(speedText);
        }
    };

    private CountDownTimer countDownTimer = new CountDownTimer(1000*59, 3200) {

        public void onTick(long millisUntilFinished) {

        }

        public void onFinish() {
            Log.d("PERCENTAGE", "DISMISSED");
            if (isCountDown)
                dismiss();
        }
    };
}