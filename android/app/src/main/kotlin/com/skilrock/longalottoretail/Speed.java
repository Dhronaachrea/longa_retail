package com.skilrock.longalottoretail;

import android.content.Context;

import java.util.Locale;

final class Speed {
    public long mTotalSpeed = 0;
    public long mDownSpeed = 0;
    public long mUpSpeed = 0;

    HumanSpeed total = new HumanSpeed();
    HumanSpeed down = new HumanSpeed();
    HumanSpeed up = new HumanSpeed();

    private boolean mIsSpeedUnitBits = false;

    private Context mContext;

    Speed(Context context) {
        mContext = context;

        updateHumanSpeeds();
    }

    private void updateHumanSpeeds() {
        total.setSpeed(mTotalSpeed);
        down.setSpeed(mDownSpeed);
        up.setSpeed(mUpSpeed);
    }

    void calcSpeed(long timeTaken, long downBytes, long upBytes) {
        long totalSpeed = 0;
        long downSpeed = 0;
        long upSpeed = 0;

        long totalBytes = downBytes + upBytes;

        if (timeTaken > 0) {
            totalSpeed = totalBytes * 1000 / timeTaken;
            downSpeed = downBytes * 1000 / timeTaken;
            upSpeed = upBytes * 1000 / timeTaken;
        }

        mTotalSpeed = totalSpeed;
        mDownSpeed = downSpeed;
        mUpSpeed = upSpeed;

        updateHumanSpeeds();
    }

    HumanSpeed getHumanSpeed(String name) {
        switch (name) {
            case "up":
                return up;
            case "down":
                return down;
            default:
                return total;
        }
    }

    void setIsSpeedUnitBits(boolean isSpeedUnitBits) {
        mIsSpeedUnitBits = isSpeedUnitBits;
    }

    class HumanSpeed {
        String speedValue;
        String speedUnit;

        private void setSpeed(long speed) {
            if (mContext == null) return;

            if (mIsSpeedUnitBits) {
                speed *= 8;
            }

            if (speed < 1000000) {
                this.speedUnit = "kbps";
                this.speedValue = String.valueOf(speed / 1000);
            } else if (speed >= 1000000) {
                this.speedUnit = "MBps";

                if (speed < 10000000) {
                    this.speedValue = String.format(Locale.ENGLISH, "%.1f", speed / 1000000.0);
                } else if (speed < 100000000) {
                    this.speedValue = String.valueOf(speed / 1000000);
                } else {
                    this.speedValue = "99";
                }
            } else {
                this.speedValue = "-";
                this.speedUnit = "-";
            }
        }
    }
}
