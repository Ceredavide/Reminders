package com.example.moblab

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import es.antonborri.home_widget.HomeWidgetPlugin

data class Task(
    val id: Int,
    val title: String,
    val due: String
)

class HomeWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }
}

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    val widgetData = HomeWidgetPlugin.getData(context)
    val codedTasks = widgetData.getString("tasks", "[]")

    val tasks = codedTasks?.let { decodeTasks(it) }

    val views = RemoteViews(context.packageName, R.layout.widget_layout)

    views.setTextViewText(R.id.appwidget_title, context.getString(R.string.home_widget_title))

    val taskContainerId = R.id.task_container

    views.removeAllViews(taskContainerId)

    tasks?.forEach { task ->
        val taskView = RemoteViews(context.packageName, R.layout.task_item).apply {
            setTextViewText(R.id.task_title, task.title)
            setTextViewText(R.id.task_due, "Due: ${task.due}")
        }

        views.addView(taskContainerId, taskView)
    }

    appWidgetManager.updateAppWidget(appWidgetId, views)
}

fun decodeTasks(json: String): List<Task>? {
    val gson = Gson()
    val taskListType = object : TypeToken<List<Task>>() {}.type
    return gson.fromJson(json, taskListType)
}