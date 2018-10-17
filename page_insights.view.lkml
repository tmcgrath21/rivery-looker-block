view: page_insights {
  sql_table_name: FB.SOCIAL_INSIGHTS_PAGE ;;

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.ID ;;
  }

  dimension: date {
    type: date
    sql: to_date(${TABLE}.DATE);;
  }


# # Create date fields

  dimension: month {
    type: date_month
    sql: to_date(${TABLE}.DATE) ;;
  }

  dimension: day_of_week{
    type: date_day_of_week
    sql: to_date(${TABLE}.DATE) ;;
  }

  dimension: week{
    type: date_week
    sql: to_date(${TABLE}.DATE) ;;
  }

  dimension: day_of_week_no {
    type: date_day_of_week_index
    sql: to_date(${TABLE}.DATE) ;;
  }

#   dimension: until_today {
#     type: yesno
#     sql: ${day_of_week_no} <= DAYOFWEEK(CURRENT_DATE) AND ${day_of_week_no} >= 0 ;;
#   }

  dimension: end_time {
    type: string
    sql: ${TABLE}.END_TIME ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.NAME ;;
    drill_fields: [post_insights.type, post_insights.status_type]
  }

# This key is used to sum_distinct certain page-level metrics to avoid duplication when joined to post_insights in the Insights explore.

  dimension: page_date_key {
    type: string
    hidden: yes
    sql:  concat(${id},to_varchar(${date})) ;;
  }

  parameter: time_selector_parameter {
    type: string
    allowed_value: { value: "Today" }
    allowed_value: { value: "Yesterday" }
    allowed_value: { value: "Last 7 days" }
    allowed_value: { value: "Last 28 days" }
  }

# Date filters
dimension: is_today {
  type: yesno
  sql: ${date} = CURRENT_DATE;;
}

dimension: is_yesterday {
    type: yesno
    sql: ${date} = dateadd(day, -1, current_date);;
  }

dimension: is_day_before_yesterday {
    type: yesno
    sql: ${date} = dateadd(day, -2, current_date);;
  }


dimension: is_past_7_days {
    type: yesno
    sql: ${date} > dateadd(day, -7, current_date);;
  }

dimension: is_previous_7_days {
    type: yesno
    sql: ${date} <= dateadd(day, -7, current_date) and ${date} > dateadd(day, -14, current_date);;
  }

  dimension: is_past_28_days {
    type: yesno
    sql: ${date} > dateadd(day, -28, current_date);;
  }

  dimension: is_previous_28_days {
    type: yesno
    sql: ${date} <= dateadd(day, -28, current_date) and ${date} > dateadd(day, -56, current_date);;
  }


# APPLY PARAMETER VALUES FOR CURRENT DATE SELECTED AND COMPARISON TIME PERIOD
  dimension: time_selector_filter {
    label_from_parameter: time_selector_parameter
    sql:
       CASE
         WHEN {% parameter time_selector_parameter %} = 'Today' THEN
           ${is_today}
         WHEN {% parameter time_selector_parameter %} = 'Yesterday' THEN
           ${is_yesterday}
         WHEN {% parameter time_selector_parameter %} = 'Last 7 days' THEN
           ${is_past_7_days}
         WHEN {% parameter time_selector_parameter %} = 'Last 28 days' THEN
            ${is_past_28_days}
         ELSE
           NULL
       END ;;
  }

  dimension: previous_time_selector_filter {
    label_from_parameter: time_selector_parameter
    sql:
       CASE
         WHEN {% parameter time_selector_parameter %} = 'Today' THEN
           ${is_yesterday}
         WHEN {% parameter time_selector_parameter %} = 'Yesterday' THEN
           ${is_day_before_yesterday}
         WHEN {% parameter time_selector_parameter %} = 'Last 7 days' THEN
           ${is_previous_7_days}
         WHEN {% parameter time_selector_parameter %} = 'Last 28 days' THEN
            ${is_previous_28_days}
         ELSE
           NULL
       END ;;
  }

# Date-filtered measures

  measure: page_impressions_time_filter {
    label: "Page Impressions (Time Parameter)"
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_DAY ;;

    filters: {
      field: time_selector_filter
      value: "true"
    }
  }

  measure: page_impressions_prev_time_filter {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_DAY ;;

    filters: {
      field: previous_time_selector_filter
      value: "true"
    }
  }

  measure: page_impressions_comparison {
    label: "Page Impressions Comparison (Time Parameter)"
    type: number
    value_format: "0.00%"
    sql:  IFF(${page_impressions_prev_time_filter} = 0,0,
    (${page_impressions_time_filter}-${page_impressions_prev_time_filter}) /${page_impressions_prev_time_filter});;
  }

# Reactions

  measure: page_actions_post_reactions_anger {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_ACTIONS_POST_REACTIONS_ANGER_TOTAL_DAY ;;
  }

  measure: page_actions_post_reactions_haha {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_ACTIONS_POST_REACTIONS_HAHA_TOTAL_DAY ;;
  }

  measure: page_actions_post_reactions_like {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_ACTIONS_POST_REACTIONS_LIKE_TOTAL_DAY ;;
  }

  measure: page_actions_post_reactions_love {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_ACTIONS_POST_REACTIONS_LOVE_TOTAL_DAY ;;
  }

  measure: page_actions_post_reactions_sorry {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_ACTIONS_POST_REACTIONS_SORRY_TOTAL_DAY ;;
  }

  measure: page_actions_post_reactions_wow {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_ACTIONS_POST_REACTIONS_WOW_TOTAL_DAY ;;
  }

  measure: page_call_phone_clicks_unique {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_CALL_PHONE_CLICKS_LOGGED_IN_UNIQUE_DAY ;;
  }

# Consumptions

  measure: page_consumptions_button_clicks {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_consumptions_by_consumption_TYPE_BUTTON_CLICKS_DAY ;;
  }

  measure: page_consumptions_link_clicks {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_consumptions_by_consumption_TYPE_LINK_CLICKS_DAY ;;
  }

  measure: page_consumptions_other_clicks {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_consumptions_by_consumption_TYPE_OTHER_CLICKS_DAY ;;
  }

  measure: page_consumptions_photo_view {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_consumptions_by_consumption_TYPE_PHOTO_VIEW_DAY ;;
  }

  measure: page_consumptions_unique_button_clicks {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_consumptions_by_consumption_TYPE_UNIQUE_BUTTON_CLICKS_DAY ;;
  }

  measure: page_consumptions_unique_link_clicks {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_consumptions_by_consumption_TYPE_UNIQUE_LINK_CLICKS_DAY ;;
  }

  measure: page_consumptions_unique_other_clicks {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_consumptions_by_consumption_TYPE_UNIQUE_OTHER_CLICKS_DAY ;;
  }

  measure: page_consumptions_unique_photo_view {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_consumptions_by_consumption_TYPE_UNIQUE_PHOTO_VIEW_DAY ;;
  }

  measure: page_consumptions_unique_video_play {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_consumptions_by_consumption_TYPE_UNIQUE_VIDEO_PLAY_DAY ;;
  }

  measure: page_consumptions_video_play {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_consumptions_by_consumption_TYPE_VIDEO_PLAY_DAY ;;
  }

  measure: page_CONSUMPTIONS {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_CONSUMPTIONS_DAY ;;
  }

  measure: page_CONSUMPTIONS_unique {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_CONSUMPTIONS_UNIQUE_DAY ;;
  }

# Engaged Users / Fans

  measure: page_engaged_users {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_ENGAGED_USERS_DAY ;;
  }

  measure: page_fan_adds_unique_paid {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_FAN_ADDS_BY_PAID_NON_PAID_UNIQUE_PAID_DAY ;;
  }


  measure: page_fan_adds_unique_unpaid {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_FAN_ADDS_BY_PAID_NON_PAID_UNIQUE_UNPAID_DAY ;;
  }

  measure: page_fan_adds {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_FAN_ADDS_DAY ;;
  }

  measure: page_fan_adds_unique {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_FAN_ADDS_UNIQUE_DAY ;;
  }

  measure: page_fan_removes {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_FAN_REMOVES_DAY ;;
  }

  measure: page_fan_removes_unique {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_FAN_REMOVES_UNIQUE_DAY ;;
  }

# Impressions and Reach

  measure: page_impressions_checkin {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_BY_STORY_TYPE_CHECKIN_DAY ;;
  }

  measure: page_impressions_coupon {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_BY_STORY_TYPE_COUPON_DAY ;;
  }

  measure: page_impressions_event {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_BY_STORY_TYPE_EVENT_DAY ;;
  }

  measure: page_impressions_fan {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_BY_STORY_TYPE_FAN_DAY ;;
  }

  measure: page_impressions_mention {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_BY_STORY_TYPE_MENTION_DAY ;;
  }

  measure: page_impressions_other {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_BY_STORY_TYPE_OTHER_DAY ;;
  }

  measure: page_impressions_page_post {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_BY_STORY_TYPE_PAGE_POST_DAY ;;
  }

  measure: page_impressions_question {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_BY_STORY_TYPE_QUESTION_DAY ;;
  }

  measure: page_impressions_unique_checkin {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_BY_STORY_TYPE_UNIQUE_CHECKIN_DAY ;;
  }

  measure: page_impressions_unique_coupon {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_BY_STORY_TYPE_UNIQUE_COUPON_DAY ;;
  }

  measure: page_impressions_unique_event {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_BY_STORY_TYPE_UNIQUE_EVENT_DAY ;;
  }

  measure: page_impressions_unique_fan {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_BY_STORY_TYPE_UNIQUE_FAN_DAY ;;
  }

  measure: page_impressions_unique_mention {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_BY_STORY_TYPE_UNIQUE_MENTION_DAY ;;
  }

  measure: page_impressions_unique_other {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_BY_STORY_TYPE_UNIQUE_OTHER_DAY ;;
  }

  measure: page_impressions_unique_page_post {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_BY_STORY_TYPE_UNIQUE_PAGE_POST_DAY ;;
  }

  measure: page_impressions_unique_question {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_BY_STORY_TYPE_UNIQUE_QUESTION_DAY ;;
  }

  measure: page_impressions_unique_user_post {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_BY_STORY_TYPE_UNIQUE_USER_POST_DAY ;;
  }

  measure: page_impressions_user_post {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_BY_STORY_TYPE_USER_POST_DAY ;;
  }

  measure: page_impressions {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_DAY ;;
  }

  measure: page_impressions_nonviral {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_NONVIRAL_DAY ;;
  }

  measure: page_reach_nonviral {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_NONVIRAL_UNIQUE_DAY ;;
  }

  measure: page_impressions_organic_day {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_ORGANIC_DAY ;;
  }

  measure: page_reach_organic {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_ORGANIC_UNIQUE_DAY ;;
  }

  measure: page_impressions_paid {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_PAID_DAY ;;
  }

  measure: page_reach_paid {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_PAID_UNIQUE_DAY ;;
  }

  measure: page_reach {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_UNIQUE_DAY ;;
  }

  measure: page_impressions_viral {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_VIRAL_DAY ;;
  }

  measure: page_reach_viral {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_IMPRESSIONS_VIRAL_UNIQUE_DAY ;;
  }

# Negative Feedback

  measure: page_negative_feedback_hide_all_clicks {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_NEGATIVE_FEEDBACK_BY_TYPE_HIDE_ALL_CLICKS_DAY ;;
  }

  measure: page_negative_feedback_hide_clicks {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_NEGATIVE_FEEDBACK_BY_TYPE_HIDE_CLICKS_DAY ;;
  }

  measure: page_negative_feedback_report_spam_clicks {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_NEGATIVE_FEEDBACK_BY_TYPE_REPORT_SPAM_CLICKS_DAY ;;
  }

  measure: page_negative_feedback_unique_hide_all_clicks {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_NEGATIVE_FEEDBACK_BY_TYPE_UNIQUE_HIDE_ALL_CLICKS_DAY ;;
  }

  measure: page_negative_feedback_unique_hide_clicks {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_NEGATIVE_FEEDBACK_BY_TYPE_UNIQUE_HIDE_CLICKS_DAY ;;
  }

  measure: page_negative_feedback_unique_report_spam_clicks {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_NEGATIVE_FEEDBACK_BY_TYPE_UNIQUE_REPORT_SPAM_CLICKS_DAY ;;
  }

  measure: page_negative_feedback_unique_unlike_page_clicks {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_NEGATIVE_FEEDBACK_BY_TYPE_UNIQUE_UNLIKE_PAGE_CLICKS_DAY ;;
  }

  measure: page_negative_feedback_unique_xbutton_clicks {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_NEGATIVE_FEEDBACK_BY_TYPE_UNIQUE_XBUTTON_CLICKS_DAY ;;
  }

  measure: page_negative_feedback_unlike_page_clicks {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_NEGATIVE_FEEDBACK_BY_TYPE_UNLIKE_PAGE_CLICKS_DAY ;;
  }

  measure: page_negative_feedback_xbutton_clicks {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_NEGATIVE_FEEDBACK_BY_TYPE_XBUTTON_CLICKS_DAY ;;
  }

  measure: page_negative_feedback {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_NEGATIVE_FEEDBACK_DAY ;;
  }

  measure: page_negative_feedback_unique {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_NEGATIVE_FEEDBACK_UNIQUE_DAY ;;
  }

# Checkins

  measure: page_places_checkin_mobile {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_PLACES_CHECKIN_MOBILE_DAY ;;
  }

  measure: page_places_checkin_mobile_unique {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_PLACES_CHECKIN_MOBILE_UNIQUE_DAY ;;
  }

  measure: page_places_checkin {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_PLACES_CHECKIN_TOTAL_DAY ;;
  }

  measure: page_places_checkin_total_unique {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_PLACES_CHECKIN_TOTAL_UNIQUE_DAY ;;
  }

# Positive Feedback

  measure: page_positive_feedback_answer {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_POSITIVE_FEEDBACK_BY_TYPE_ANSWER_DAY ;;
  }

  measure: page_positive_feedback_claim {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_POSITIVE_FEEDBACK_BY_TYPE_CLAIM_DAY ;;
  }

  measure: page_positive_feedback_comment {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_POSITIVE_FEEDBACK_BY_TYPE_COMMENT_DAY ;;
  }

  measure: page_positive_feedback_like {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_POSITIVE_FEEDBACK_BY_TYPE_LIKE_DAY ;;
  }

  measure: page_positive_feedback_link {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_POSITIVE_FEEDBACK_BY_TYPE_LINK_DAY ;;
  }

  measure: page_positive_feedback_other {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_POSITIVE_FEEDBACK_BY_TYPE_OTHER_DAY ;;
  }

  measure: page_positive_feedback_unique_answer {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_POSITIVE_FEEDBACK_BY_TYPE_UNIQUE_ANSWER_DAY ;;
  }

  measure: page_positive_feedback_unique_claim {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_POSITIVE_FEEDBACK_BY_TYPE_UNIQUE_CLAIM_DAY ;;
  }

  measure: page_positive_feedback_unique_comment {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_POSITIVE_FEEDBACK_BY_TYPE_UNIQUE_COMMENT_DAY ;;
  }

  measure: page_positive_feedback_unique_like {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_POSITIVE_FEEDBACK_BY_TYPE_UNIQUE_LIKE_DAY ;;
  }

  measure: page_positive_feedback_unique_link {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_POSITIVE_FEEDBACK_BY_TYPE_UNIQUE_LINK_DAY ;;
  }

  measure: page_positive_feedback_unique_other {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_POSITIVE_FEEDBACK_BY_TYPE_UNIQUE_OTHER_DAY ;;
  }

# Post Engagements

  measure: page_post_engagements {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_POST_ENGAGEMENTS_DAY ;;
  }

# Stories

  measure: page_stories_checkin {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_STORIES_BY_STORY_TYPE_CHECKIN_DAY ;;
  }

  measure: page_stories_coupon {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_STORIES_BY_STORY_TYPE_COUPON_DAY ;;
  }

  measure: page_stories_event {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_STORIES_BY_STORY_TYPE_EVENT_DAY ;;
  }

  measure: page_stories_fan {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_STORIES_BY_STORY_TYPE_FAN_DAY ;;
  }

  measure: page_stories_mention {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_STORIES_BY_STORY_TYPE_MENTION_DAY ;;
  }

  measure: page_stories_other {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_STORIES_BY_STORY_TYPE_OTHER_DAY ;;
  }

  measure: page_stories_page_post {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_STORIES_BY_STORY_TYPE_PAGE_POST_DAY ;;
  }

  measure: page_stories_question {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_STORIES_BY_STORY_TYPE_QUESTION_DAY ;;
  }

  measure: page_stories_user_post {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_STORIES_BY_STORY_TYPE_USER_POST_DAY ;;
  }

  measure: page_stories {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_STORIES_DAY ;;
  }

  measure: page_story_adds {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_STORY_ADDS_DAY ;;
  }

# Storytellers

  measure: page_storytellers_checkin {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_STORYTELLERS_BY_STORY_TYPE_CHECKIN_DAY ;;
  }

  measure: page_storytellers_coupon {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_STORYTELLERS_BY_STORY_TYPE_COUPON_DAY ;;
  }

  measure: page_storytellers_event {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_STORYTELLERS_BY_STORY_TYPE_EVENT_DAY ;;
  }

  measure: page_storytellers_fan {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_STORYTELLERS_BY_STORY_TYPE_FAN_DAY ;;
  }

  measure: page_storytellers_mention {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_STORYTELLERS_BY_STORY_TYPE_MENTION_DAY ;;
  }

  measure: page_storytellers_other {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_STORYTELLERS_BY_STORY_TYPE_OTHER_DAY ;;
  }

  measure: page_storytellers_page_post {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_STORYTELLERS_BY_STORY_TYPE_PAGE_POST_DAY ;;
  }

  measure: page_storytellers_question {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_STORYTELLERS_BY_STORY_TYPE_QUESTION_DAY ;;
  }

  measure: page_storytellers_user_post {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_STORYTELLERS_BY_STORY_TYPE_USER_POST_DAY ;;
  }

  measure: page_total_actions {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_TOTAL_ACTIONS_DAY ;;
  }

# Video Views

  measure: page_video_complete_views_30s_autoplayed {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIDEO_COMPLETE_VIEWS_30S_AUTOPLAYED_DAY ;;
  }

  measure: page_video_complete_views_30s_click_to_play {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIDEO_COMPLETE_VIEWS_30S_CLICK_TO_PLAY_DAY ;;
  }

  measure: page_video_complete_views_30s {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIDEO_COMPLETE_VIEWS_30S_DAY ;;
  }

  measure: page_video_complete_views_30s_organic {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIDEO_COMPLETE_VIEWS_30S_ORGANIC_DAY ;;
  }

  measure: page_video_complete_views_30s_paid {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIDEO_COMPLETE_VIEWS_30S_PAID_DAY ;;
  }

  measure: page_video_complete_views_30s_repeat_views {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIDEO_COMPLETE_VIEWS_30S_REPEAT_VIEWS_DAY ;;
  }

  measure: page_video_complete_views_30s_unique {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIDEO_COMPLETE_VIEWS_30S_UNIQUE_DAY ;;
  }

  measure: page_video_repeat_views {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIDEO_REPEAT_VIEWS_DAY ;;
  }

  measure: page_video_view_time {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIDEO_VIEW_TIME_DAY ;;
  }

  measure: page_video_views_10s_autoplayed {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIDEO_VIEWS_10S_AUTOPLAYED_DAY ;;
  }

  measure: page_video_views_10s_click_to_play {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIDEO_VIEWS_10S_CLICK_TO_PLAY_DAY ;;
  }

  measure: page_video_views_10s {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIDEO_VIEWS_10S_DAY ;;
  }

  measure: page_video_views_10s_organic {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIDEO_VIEWS_10S_ORGANIC_DAY ;;
  }

  measure: page_video_views_10s_paid {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIDEO_VIEWS_10S_PAID_DAY ;;
  }

  measure: page_video_views_10s_repeat {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIDEO_VIEWS_10S_REPEAT_DAY ;;
  }

  measure: page_video_views_10s_unique {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIDEO_VIEWS_10S_UNIQUE_DAY ;;
  }

  measure: page_video_views_autoplayed {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIDEO_VIEWS_AUTOPLAYED_DAY ;;
  }

  measure: page_video_views_unpaid {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIDEO_VIEWS_BY_PAID_NON_PAID_UNPAID_DAY ;;
  }

  measure: page_video_views_click_to_play {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIDEO_VIEWS_CLICK_TO_PLAY_DAY ;;
  }

  measure: page_video_views {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIDEO_VIEWS_DAY ;;
  }

  measure: page_video_views_organic {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIDEO_VIEWS_ORGANIC_DAY ;;
  }

  measure: page_video_views_paid {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIDEO_VIEWS_PAID_DAY ;;
  }

  measure: page_video_views_unique {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIDEO_VIEWS_UNIQUE_DAY ;;
  }

# Views by Age/Gender groups. NOTE - these are hidden measures and used below for separate gender/age calculations.

  measure: page_views_by_age_gender_unique_13_17_f {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_13_17_F_DAY ;;
  }

  measure: page_views_by_age_gender_unique_13_17_m {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_13_17_M_DAY ;;
  }

  measure: page_views_by_age_gender_unique_13_17_u {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_13_17_U_DAY ;;
  }

  measure: page_views_by_age_gender_unique_13_f {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_13_F_DAY ;;
  }

  measure: page_views_by_age_gender_unique_13_m {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_13_M_DAY ;;
  }

  measure: page_views_by_age_gender_unique_13_u {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_13_U_DAY ;;
  }

  measure: page_views_by_age_gender_unique_18_24_f {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_18_24_F_DAY ;;
  }

  measure: page_views_by_age_gender_unique_18_24_m {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_18_24_M_DAY ;;
  }

  measure: page_views_by_age_gender_unique_18_24_u {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_18_24_U_DAY ;;
  }

  measure: page_views_by_age_gender_unique_25_34_f {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_25_34_F_DAY ;;
  }

  measure: page_views_by_age_gender_unique_25_34_m {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_25_34_M_DAY ;;
  }

  measure: page_views_by_age_gender_unique_25_34_u {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_25_34_U_DAY ;;
  }

  measure: page_views_by_age_gender_unique_35_44_f {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_35_44_F_DAY ;;
  }

  measure: page_views_by_age_gender_unique_35_44_m {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_35_44_M_DAY ;;
  }

  measure: page_views_by_age_gender_unique_35_44_u {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_35_44_U_DAY ;;
  }

  measure: page_views_by_age_gender_unique_45_54_f {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_45_54_F_DAY ;;
  }

  measure: page_views_by_age_gender_unique_45_54_m {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_45_54_M_DAY ;;
  }

  measure: page_views_by_age_gender_unique_45_54_u {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_45_54_U_DAY ;;
  }

  measure: page_views_by_age_gender_unique_55_64_f {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_55_64_F_DAY ;;
  }

  measure: page_views_by_age_gender_unique_55_64_m {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_55_64_M_DAY ;;
  }

  measure: page_views_by_age_gender_unique_55_64_u {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_55_64_U_DAY ;;
  }

  measure: page_views_by_age_gender_unique_65_f {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_65_F_DAY ;;
  }

  measure: page_views_by_age_gender_unique_65_m {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_65_M_DAY ;;
  }

  measure: page_views_by_age_gender_unique_65_u {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_65_U_DAY ;;
  }

  measure: page_views_by_age_gender_unique_unknown_f {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_UNKNOWN_F_DAY ;;
  }

  measure: page_views_by_age_gender_unique_unknown_m {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_UNKNOWN_M_DAY ;;
  }

  measure: page_views_by_age_gender_unique_unknown_u {
    type: sum_distinct
    hidden: yes
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_BY_AGE_GENDER_LOGGED_IN_UNIQUE_UNKNOWN_U_DAY ;;
  }

  measure: page_views_logged_in {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_LOGGED_IN_TOTAL_DAY ;;
  }

  measure: page_views_unique {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_LOGGED_IN_UNIQUE_DAY ;;
  }

  measure: page_views {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_VIEWS_TOTAL_DAY ;;
  }

# Website clicks

  measure: page_website_clicks_by_site_unique_api {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_WEBSITE_CLICKS_BY_SITE_LOGGED_IN_UNIQUE_API_DAY ;;
  }

  measure: page_website_clicks_by_site_unique_mobile {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_WEBSITE_CLICKS_BY_SITE_LOGGED_IN_UNIQUE_MOBILE_DAY ;;
  }

  measure: page_website_clicks_by_site_unique_other {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_WEBSITE_CLICKS_BY_SITE_LOGGED_IN_UNIQUE_OTHER_DAY ;;
  }

  measure: page_website_clicks_by_site_unique_www {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_WEBSITE_CLICKS_BY_SITE_LOGGED_IN_UNIQUE_WWW_DAY ;;
  }

  measure: page_website_clicks_unique {
    type: sum_distinct
    sql_distinct_key: ${page_date_key};;
    sql: ${TABLE}.PAGE_WEBSITE_CLICKS_LOGGED_IN_UNIQUE_DAY ;;
  }

  # CALCULATED MEASURES

  # Create AGE and GENDER columns (combine bucketed fields from FB API output)

  measure: page_views_female {
    type: number
    sql:  ${page_views_by_age_gender_unique_13_f} + ${page_views_by_age_gender_unique_13_17_f} + ${page_views_by_age_gender_unique_18_24_f} +
    ${page_views_by_age_gender_unique_25_34_f} + ${page_views_by_age_gender_unique_35_44_f} + ${page_views_by_age_gender_unique_55_64_f} + ${page_views_by_age_gender_unique_65_f}
      + ${page_views_by_age_gender_unique_unknown_f} + ${page_views_by_age_gender_unique_45_54_f};;
  }

  measure: page_views_male {
    type: number
    sql:  ${page_views_by_age_gender_unique_13_m} + ${page_views_by_age_gender_unique_13_17_m} + ${page_views_by_age_gender_unique_18_24_m} +
          ${page_views_by_age_gender_unique_25_34_m} + ${page_views_by_age_gender_unique_35_44_m} + ${page_views_by_age_gender_unique_55_64_m} + ${page_views_by_age_gender_unique_65_m}
            + ${page_views_by_age_gender_unique_unknown_m} + ${page_views_by_age_gender_unique_45_54_m};;
  }

  measure: page_views_gender_unknown{
    type: number
    sql:  ${page_views_by_age_gender_unique_13_u} + ${page_views_by_age_gender_unique_13_17_u} + ${page_views_by_age_gender_unique_18_24_u} +
          ${page_views_by_age_gender_unique_25_34_u} + ${page_views_by_age_gender_unique_35_44_u} + ${page_views_by_age_gender_unique_55_64_u} + ${page_views_by_age_gender_unique_65_u}
            + ${page_views_by_age_gender_unique_unknown_u} + ${page_views_by_age_gender_unique_45_54_u};;
  }

  measure: page_views_age_under_13 {
    type: number
    sql: ${page_views_by_age_gender_unique_13_f} + ${page_views_by_age_gender_unique_13_m} + ${page_views_by_age_gender_unique_13_u} ;;
  }

  measure: page_views_age_13_to_17 {
    type: number
    sql: ${page_views_by_age_gender_unique_13_17_f} + ${page_views_by_age_gender_unique_13_17_m} + ${page_views_by_age_gender_unique_13_17_u} ;;
  }

  measure: page_views_age_18_to_24 {
    type: number
    sql: ${page_views_by_age_gender_unique_18_24_f} + ${page_views_by_age_gender_unique_18_24_m} + ${page_views_by_age_gender_unique_18_24_u} ;;
  }

  measure: page_views_age_25_to_34 {
    type: number
    sql: ${page_views_by_age_gender_unique_25_34_f} + ${page_views_by_age_gender_unique_25_34_m} + ${page_views_by_age_gender_unique_25_34_u} ;;
  }

  measure: page_views_age_35_to_44 {
    type: number
    sql: ${page_views_by_age_gender_unique_35_44_f} + ${page_views_by_age_gender_unique_35_44_m} + ${page_views_by_age_gender_unique_35_44_u} ;;
  }

  measure: page_views_age_45_to_54 {
    type: number
    sql: ${page_views_by_age_gender_unique_45_54_f} + ${page_views_by_age_gender_unique_45_54_m} + ${page_views_by_age_gender_unique_45_54_u} ;;
  }

  measure: page_views_age_55_to_64 {
    type: number
    sql: ${page_views_by_age_gender_unique_55_64_f} + ${page_views_by_age_gender_unique_55_64_m} + ${page_views_by_age_gender_unique_55_64_u} ;;
  }

  measure: page_views_age_over_65 {
    type: number
    sql: ${page_views_by_age_gender_unique_65_f} + ${page_views_by_age_gender_unique_65_m} + ${page_views_by_age_gender_unique_65_u} ;;
  }

  measure: page_views_age_unknown {
    type: number
    sql: ${page_views_by_age_gender_unique_unknown_f} + ${page_views_by_age_gender_unique_unknown_m} + ${page_views_by_age_gender_unique_unknown_u} ;;
  }


  measure: distinct_days {
    type: count_distinct
    hidden: yes
    sql: ${TABLE}.DATE ;;
  }

  measure: avg_daily_impressions {
    type: number
    value_format: "0.00"
    sql: ${page_impressions} / ${distinct_days} ;;
  }

  measure: avg_daily_reach {
    type: number
    value_format: "0.00"
    sql: ${page_reach} / ${distinct_days} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}
