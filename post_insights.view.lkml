view: post_insights {
  sql_table_name: FB.SOCIAL_INSIGHTS_POST ;;

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.ID ;;
  }

  dimension: date {
    type: string
    sql: to_varchar(${TABLE}.DATE) ;;
  }

  dimension: end_time {
    type: string
    sql: ${TABLE}.END_TIME ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.NAME ;;
  }

  dimension: page_id {
    type: string
    sql: ${TABLE}.PAGE_ID ;;
  }

  dimension: caption {
    type: string
    sql: ${TABLE}.CAPTION ;;
  }

  dimension: created_time {
    type: string
    sql: ${TABLE}.CREATED_TIME ;;
  }

  # Created date. Used to filter out rows where 'date' is less than date actually created.

  dimension: created_date {
    type: date
    sql: to_date(left(${created_time},10)) ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.DESCRIPTION ;;
  }

  dimension: message {
    type: string
    sql: ${TABLE}.MESSAGE ;;
  }

  dimension: shares_count {
    type: number
    sql: ${TABLE}.SHARES_COUNT ;;
  }

  dimension: status_type {
    type: string
    sql: ${TABLE}.STATUS_TYPE ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.TYPE ;;
    drill_fields: [status_type]
  }

  measure: post_consumptions_link_clicks {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_CONSUMPTIONS_BY_TYPE_LINK_CLICKS_LIFETIME ;;
  }

  measure: post_consumptions_other_clicks {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_CONSUMPTIONS_BY_TYPE_OTHER_CLICKS_LIFETIME ;;
  }

  measure: post_consumptions_unique_link_clicks {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_CONSUMPTIONS_BY_TYPE_UNIQUE_LINK_CLICKS_LIFETIME ;;
  }

  measure: post_consumptions_unique_other_clicks {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_CONSUMPTIONS_BY_TYPE_UNIQUE_OTHER_CLICKS_LIFETIME ;;
  }

  measure: post_consumptions {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_CONSUMPTIONS_LIFETIME ;;
  }

  measure: post_consumptions_unique {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_CONSUMPTIONS_UNIQUE_LIFETIME ;;
  }

  measure: post_engaged_fan {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_ENGAGED_FAN_LIFETIME ;;
  }

  measure: post_engaged_users {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_ENGAGED_USERS_LIFETIME ;;
  }

  measure: post_fan_reach {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_FAN_REACH_LIFETIME ;;
  }

  measure: post_impressions_other {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_IMPRESSIONS_BY_STORY_TYPE_OTHER_LIFETIME ;;
  }

  measure: post_reach_other {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_IMPRESSIONS_BY_STORY_TYPE_UNIQUE_OTHER_LIFETIME ;;
  }

  measure: post_impressions_fan {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_IMPRESSIONS_FAN_LIFETIME ;;
  }

  measure: post_impressions_fan_paid {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_IMPRESSIONS_FAN_PAID_LIFETIME ;;
  }

  measure: post_reach_fan_paid {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_IMPRESSIONS_FAN_PAID_UNIQUE_LIFETIME ;;
  }

  measure: post_reach_fan {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_IMPRESSIONS_FAN_UNIQUE_LIFETIME ;;
  }

  measure: post_impressions {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_IMPRESSIONS_LIFETIME ;;
  }

  measure: post_impressions_nonviral {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_IMPRESSIONS_NONVIRAL_LIFETIME ;;
  }

  measure: post_reach_nonviral {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_IMPRESSIONS_NONVIRAL_UNIQUE_LIFETIME ;;
  }

  measure: post_impressions_organic {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_IMPRESSIONS_ORGANIC_LIFETIME ;;
  }

  measure: post_reach_organic {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_IMPRESSIONS_ORGANIC_UNIQUE_LIFETIME ;;
  }

  measure: post_impressions_paid {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_IMPRESSIONS_PAID_LIFETIME ;;
  }

  measure: post_reach_paid {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_IMPRESSIONS_PAID_UNIQUE_LIFETIME ;;
  }

  measure: post_reach {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_IMPRESSIONS_UNIQUE_LIFETIME ;;
  }

  measure: post_impressions_viral {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_IMPRESSIONS_VIRAL_LIFETIME ;;
  }

  measure: post_reach_viral {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_IMPRESSIONS_VIRAL_UNIQUE_LIFETIME ;;
  }

  measure: post_negative_feedback {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_NEGATIVE_FEEDBACK_LIFETIME ;;
  }

  measure: post_negative_feedback_unique {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_NEGATIVE_FEEDBACK_UNIQUE_LIFETIME ;;
  }

#   measure: post_reactions_anger_total {
#     type: sum_distinct
#     sql_distinct_key: ${TABLE}.ID ;;
#     sql: ${TABLE}.POST_REACTIONS_ANGER_TOTAL_LIFETIME ;;
#   }
#
#   measure: post_reactions_by_type_total_anger {
#     type: sum_distinct
#     sql_distinct_key: ${TABLE}.ID ;;
#     sql: ${TABLE}.POST_REACTIONS_BY_TYPE_TOTAL_ANGER_LIFETIME ;;
#   }
#
#   measure: post_reactions_by_type_total_haha {
#     type: sum_distinct
#     sql_distinct_key: ${TABLE}.ID ;;
#     sql: ${TABLE}.POST_REACTIONS_BY_TYPE_TOTAL_HAHA_LIFETIME ;;
#   }
#
#   measure: post_reactions_by_type_total_like {
#     type: sum_distinct
#     sql_distinct_key: ${TABLE}.ID ;;
#     sql: ${TABLE}.POST_REACTIONS_BY_TYPE_TOTAL_LIKE_LIFETIME ;;
#   }
#
#   measure: post_reactions_by_type_total_love {
#     type: sum_distinct
#     sql_distinct_key: ${TABLE}.ID ;;
#     sql: ${TABLE}.POST_REACTIONS_BY_TYPE_TOTAL_LOVE_LIFETIME ;;
#   }
#
#   measure: post_reactions_by_type_total_sorry {
#     type: sum_distinct
#     sql_distinct_key: ${TABLE}.ID ;;
#     sql: ${TABLE}.POST_REACTIONS_BY_TYPE_TOTAL_SORRY_LIFETIME ;;
#   }
#
#   measure: post_reactions_by_type_total_wow {
#     type: sum_distinct
#     sql_distinct_key: ${TABLE}.ID ;;
#     sql: ${TABLE}.POST_REACTIONS_BY_TYPE_TOTAL_WOW_LIFETIME ;;
#   }

  measure: post_reactions_haha {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_REACTIONS_HAHA_TOTAL_LIFETIME ;;
  }

  measure: post_reactions_like {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_REACTIONS_LIKE_TOTAL_LIFETIME ;;
  }

  measure: post_reactions_love {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_REACTIONS_LOVE_TOTAL_LIFETIME ;;
  }

  measure: post_reactions_sorry {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_REACTIONS_SORRY_TOTAL_LIFETIME ;;
  }

  measure: post_reactions_wow {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_REACTIONS_WOW_TOTAL_LIFETIME ;;
  }

  measure: post_stories_likes {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_STORIES_BY_ACTION_TYPE_LIKE_LIFETIME ;;
  }

  measure: post_stories_shares {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_STORIES_BY_ACTION_TYPE_SHARE_LIFETIME ;;
  }

  measure: post_stories {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_STORIES_LIFETIME ;;
  }

  measure: post_story_adds_likes {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_STORY_ADDS_BY_ACTION_TYPE_LIKE_LIFETIME ;;
  }

  measure: post_story_adds_shares {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_STORY_ADDS_BY_ACTION_TYPE_SHARE_LIFETIME ;;
  }

  measure: post_story_adds_unique_likes {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_STORY_ADDS_BY_ACTION_TYPE_UNIQUE_LIKE_LIFETIME ;;
  }

  measure: post_story_adds_unique_shares {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_STORY_ADDS_BY_ACTION_TYPE_UNIQUE_SHARE_LIFETIME ;;
  }

  measure: post_story_adds {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_STORY_ADDS_LIFETIME ;;
  }

  measure: post_story_adds_unique {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_STORY_ADDS_UNIQUE_LIFETIME ;;
  }

  measure: post_storytellers_likes {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_STORYTELLERS_BY_ACTION_TYPE_LIKE_LIFETIME ;;
  }

  measure: post_storytellers_shares {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_STORYTELLERS_BY_ACTION_TYPE_SHARE_LIFETIME ;;
  }

  measure: post_storytellers {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_STORYTELLERS_LIFETIME ;;
  }

  measure: post_video_avg_time_watched {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_VIDEO_AVG_TIME_WATCHED_LIFETIME ;;
  }

  measure: post_video_complete_views_30s_autoplayed {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_VIDEO_COMPLETE_VIEWS_30S_AUTOPLAYED_LIFETIME ;;
  }

  measure: post_video_complete_views_30s_clicked_to_play {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_VIDEO_COMPLETE_VIEWS_30S_CLICKED_TO_PLAY_LIFETIME ;;
  }

  measure: post_video_complete_views_30s_organic {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_VIDEO_COMPLETE_VIEWS_30S_ORGANIC_LIFETIME ;;
  }

  measure: post_video_complete_views_30s_paid {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_VIDEO_COMPLETE_VIEWS_30S_PAID_LIFETIME ;;
  }

  measure: post_video_complete_views_30s_unique {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_VIDEO_COMPLETE_VIEWS_30S_UNIQUE_LIFETIME ;;
  }

  measure: post_video_complete_views_organic {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_VIDEO_COMPLETE_VIEWS_ORGANIC_LIFETIME ;;
  }

  measure: post_video_complete_views_organic_unique {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_VIDEO_COMPLETE_VIEWS_ORGANIC_UNIQUE_LIFETIME ;;
  }

  measure: post_video_complete_views_paid {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_VIDEO_COMPLETE_VIEWS_PAID_LIFETIME ;;
  }

  measure: post_video_complete_views_paid_unique {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_VIDEO_COMPLETE_VIEWS_PAID_UNIQUE_LIFETIME ;;
  }

  measure: post_video_length {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_VIDEO_LENGTH_LIFETIME ;;
  }

  measure: post_video_view_time {
    type: sum
    sql: ${TABLE}.POST_VIDEO_VIEW_TIME_DAY ;;
  }

  measure: post_video_view_time_organic {
    type: sum
    sql: ${TABLE}.POST_VIDEO_VIEW_TIME_ORGANIC_DAY ;;
  }

  measure: post_video_views_10s_autoplayed {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_VIDEO_VIEWS_10S_AUTOPLAYED_LIFETIME ;;
  }

  measure: post_video_views_10s_clicked_to_play {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_VIDEO_VIEWS_10S_CLICKED_TO_PLAY_LIFETIME ;;
  }

  measure: post_video_views_10s {
    type: sum
    sql: ${TABLE}.POST_VIDEO_VIEWS_10S_DAY ;;
  }

  measure: post_video_views_10s_paid {
    type: sum
    sql: ${TABLE}.POST_VIDEO_VIEWS_10S_PAID_DAY ;;
  }

  measure: post_video_views_10s_sound_on {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_VIDEO_VIEWS_10S_SOUND_ON_LIFETIME ;;
  }

  measure: post_video_views_10s_unique {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_VIDEO_VIEWS_10S_UNIQUE_LIFETIME ;;
  }

  measure: post_video_views_autoplayed {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_VIDEO_VIEWS_AUTOPLAYED_LIFETIME ;;
  }

  measure: post_video_views_clicked_to_play {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_VIDEO_VIEWS_CLICKED_TO_PLAY_LIFETIME ;;
  }

  measure: post_video_views {
    type: sum
    sql: ${TABLE}.POST_VIDEO_VIEWS_DAY ;;
  }

  measure: post_video_views_organic {
    type: sum
    sql: ${TABLE}.POST_VIDEO_VIEWS_ORGANIC_DAY ;;
  }

  measure: post_video_views_organic_unique {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_VIDEO_VIEWS_ORGANIC_UNIQUE_LIFETIME ;;
  }

  measure: post_video_views_paid {
    type: sum
    sql: ${TABLE}.POST_VIDEO_VIEWS_PAID_DAY ;;
  }

  measure: post_video_views_paid_unique {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_VIDEO_VIEWS_PAID_UNIQUE_LIFETIME ;;
  }

  measure: post_video_views_sound_on {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_VIDEO_VIEWS_SOUND_ON_LIFETIME ;;
  }

  measure: post_video_views_unique {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.ID ;;
    sql: ${TABLE}.POST_VIDEO_VIEWS_UNIQUE_LIFETIME ;;
  }

  # Calculated Measures

  measure: distinct_days {
    type: count_distinct
    sql: iff(${created_date} <= ${date} and ${date} <= CURRENT_DATE, ${TABLE}.DATE, null) ;;
  }

  measure: avg_daily_impressions {
    type: number
    value_format: "0.00"
    sql: ${post_impressions} / ${distinct_days} ;;
  }

  measure: avg_daily_reach {
    type: number
    value_format: "0.00"
    sql: ${post_reach} / ${distinct_days} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}
