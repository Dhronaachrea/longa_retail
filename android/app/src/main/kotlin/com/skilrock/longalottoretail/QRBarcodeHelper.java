package com.skilrock.longalottoretail;

import static android.graphics.Color.BLACK;
import static android.graphics.Color.WHITE;

import android.content.Context;
import android.graphics.Bitmap;
import android.util.Log;

import androidx.annotation.IntRange;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

import java.util.EnumMap;
import java.util.Map;

    public class QRBarcodeHelper {

    private ErrorCorrectionLevel mErrorCorrectionLevel;
    private int mMargin;
    private String mContent;

    public QRBarcodeHelper(Context context) {
        int mHeight = (int) (context.getResources().getDisplayMetrics().heightPixels / 2.4);
        int mWidth = (int) (context.getResources().getDisplayMetrics().widthPixels / 1.3);
        Log.e("Dimension = %s", mHeight + "");
        Log.e("Dimension = %s", mWidth + "");
    }

    public Bitmap getQRCOde() {
        return generate();
    }

    public QRBarcodeHelper setErrorCorrectionLevel(ErrorCorrectionLevel level) {
        mErrorCorrectionLevel = level;
        return this;
    }

    public QRBarcodeHelper setContent(String content) {
        mContent = content;
        return this;
    }

    public QRBarcodeHelper setMargin(@IntRange(from = 0) int margin) {
        mMargin = margin;
        return this;
    }

    private Bitmap generate() {
        Map<EncodeHintType, Object> hintsMap = new EnumMap<>(EncodeHintType.class);
        hintsMap.put(EncodeHintType.CHARACTER_SET, "utf-8");
        hintsMap.put(EncodeHintType.ERROR_CORRECTION, mErrorCorrectionLevel);
        hintsMap.put(EncodeHintType.MARGIN, mMargin);

        try {
            MultiFormatWriter writer = new MultiFormatWriter();
            BitMatrix bitMatrix = writer.encode(mContent, BarcodeFormat.CODE_128, 384, 70, hintsMap);

            BitMatrix result;
            try {
                result = writer.encode(mContent, BarcodeFormat.CODE_128, 400, 70, hintsMap);
            } catch (IllegalArgumentException iae) {
                // Unsupported format
                return null;
            }
            int width = result.getWidth();
            int height = result.getHeight();
            int[] pixels = new int[width * height];
            for (int y = 0; y < height; y++) {
                int offset = y * width;
                for (int x = 0; x < width; x++) {
                    pixels[offset + x] = result.get(x, y) ? BLACK : WHITE;
                }
            }           return Bitmap.createBitmap(pixels, width, height, Bitmap.Config.ARGB_8888);
        } catch (WriterException e) {
            e.printStackTrace();
        }
        return null;
    }

}
