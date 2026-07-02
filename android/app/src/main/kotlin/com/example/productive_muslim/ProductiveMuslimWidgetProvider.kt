package com.example.productive_muslim

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class ProductiveMuslimWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
    }

    private fun updateWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        val prefs = HomeWidgetPlugin.getData(context)

        val nextPrayerName  = prefs.getString("nextPrayerName",  "—") ?: "—"
        val nextPrayerTime  = prefs.getString("nextPrayerTime",  "—") ?: "—"
        val timeRemaining   = prefs.getString("timeRemaining",   "—") ?: "—"
        val currentBlock    = prefs.getString("currentBlockTitle","—") ?: "—"

        val views = RemoteViews(context.packageName, R.layout.productive_muslim_widget)
        views.setTextViewText(R.id.tv_next_prayer_name, nextPrayerName)
        views.setTextViewText(R.id.tv_next_prayer_time, nextPrayerTime)
        views.setTextViewText(R.id.tv_time_remaining,   "in $timeRemaining")
        views.setTextViewText(R.id.tv_current_block,    currentBlock)

        // Tapping anywhere on the widget opens the app
        val launchIntent = Intent(context, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            context, 0, launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }
}
