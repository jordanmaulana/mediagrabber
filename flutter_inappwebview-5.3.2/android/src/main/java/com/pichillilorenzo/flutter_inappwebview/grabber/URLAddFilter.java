package android.src.main.java.com.pichillilorenzo.flutter_inappwebview.Grabber;

import android.content.Context;


public class URLAddFilter {

    public static boolean IsContainsAdURL(String URL) {
        String urlLowerCase = URL.toLowerCase();
        boolean urlMightAd = false;
        String[] ad_filters = {"taboola.com", "googleadservices.com"};

        for (String filter : ad_filters) {
            if (urlLowerCase.contains(filter)) {
                urlMightAd = true;
                break;
            }
        }
        return urlMightAd;
    }


    public static boolean DoNotCheckIf(Context context, String URL) {
        String urlLowerCase = URL.toLowerCase();
        boolean urlristricted = false;
        String[] url_filters = {"youtube.com", "pornhub.org"};

        for (String filter : url_filters) {
            if (urlLowerCase.contains(filter)) {
                urlristricted = true;
                break;
            }
        }
        return urlristricted;
    }
}
