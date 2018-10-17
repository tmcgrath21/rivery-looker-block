view: feed {
  sql_table_name: FB.STG_SOCIAL_FEED ;;

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.ID ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.CATEGORY ;;
  }

  measure: count_checkins {
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${TABLE}.CHECKINS ;;
  }

  measure: count_fans {
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${TABLE}.FAN_COUNT ;;
  }

  dimension: feed_admin_creator_id {
    type: string
    sql: ${TABLE}.FEED_ADMIN_CREATOR_ID ;;
  }

  dimension: feed_admin_creator_name {
    type: string
    sql: ${TABLE}.FEED_ADMIN_CREATOR_NAME ;;
  }

  dimension: feed_caption {
    type: string
    sql: ${TABLE}.FEED_CAPTION ;;
  }

  measure: feed_comments_comment_count {
    type: sum
    hidden: yes
    sql: ${TABLE}.FEED_COMMENTS_COMMENT_COUNT ;;
  }

  dimension: feed_comments_created_time {
    type: string
    sql: ${TABLE}.FEED_COMMENTS_CREATED_TIME ;;
  }

  dimension: feed_comments_id {
    type: string
    sql: ${TABLE}.FEED_COMMENTS_ID ;;
  }

  measure: feed_comments_like_count {
    type: sum
    hidden:  yes
    sql: ${TABLE}.FEED_COMMENTS_LIKE_COUNT ;;
  }

  dimension: feed_comments_message {
    type: string
    sql: ${TABLE}.FEED_COMMENTS_MESSAGE ;;
  }

  dimension: feed_created_time {
    type: string
    sql: ${TABLE}.FEED_CREATED_TIME ;;
  }

  dimension: feed_description {
    type: string
    sql: ${TABLE}.FEED_DESCRIPTION ;;
  }

  dimension: feed_full_picture {
    type: string
    sql: ${TABLE}.FEED_FULL_PICTURE ;;
  }

  dimension: feed_id {
    type: string
    sql: ${TABLE}.FEED_ID ;;
  }

  dimension: feed_instagram_eligibility {
    type: string
    sql: ${TABLE}.FEED_INSTAGRAM_ELIGIBILITY ;;
  }

  dimension: feed_is_hidden {
    type: yesno
    sql: ${TABLE}.FEED_IS_HIDDEN ;;
  }

  dimension: feed_is_instagram_eligible {
    type: yesno
    sql: ${TABLE}.FEED_IS_INSTAGRAM_ELIGIBLE ;;
  }

  dimension: feed_is_published {
    type: yesno
    sql: ${TABLE}.FEED_IS_PUBLISHED ;;
  }

  dimension: feed_link {
    type: string
    sql: ${TABLE}.FEED_LINK ;;
  }

  dimension: feed_message {
    type: string
    sql: ${TABLE}.FEED_MESSAGE ;;
  }

  dimension: feed_name {
    type: string
    sql: ${TABLE}.FEED_NAME ;;
  }

  dimension: feed_permalink_url {
    type: string
    sql: ${TABLE}.FEED_PERMALINK_URL ;;
  }

  dimension: feed_place_id {
    type: string
    hidden:  yes
    sql: ${TABLE}.FEED_PLACE_ID ;;
  }

  dimension: feed_place_location_city {
    type: string
    hidden:  yes
    sql: ${TABLE}.FEED_PLACE_LOCATION_CITY ;;
  }

  dimension: feed_place_location_country {
    type: string
    sql: ${TABLE}.FEED_PLACE_LOCATION_COUNTRY ;;
  }

  dimension: feed_place_location_latitude {
    type: number
    hidden: yes
    sql: ${TABLE}.FEED_PLACE_LOCATION_LATITUDE ;;
  }

  dimension: feed_place_location_longitude {
    type: number
    hidden:  yes
    sql: ${TABLE}.FEED_PLACE_LOCATION_LONGITUDE ;;
  }

  dimension: feed_place_name {
    type: string
    sql: ${TABLE}.FEED_PLACE_NAME ;;
  }

  dimension: feed_privacy_allow {
    type: string
    sql: ${TABLE}.FEED_PRIVACY_ALLOW ;;
  }

  dimension: feed_privacy_deny {
    type: string
    sql: ${TABLE}.FEED_PRIVACY_DENY ;;
  }

  dimension: feed_privacy_description {
    type: string
    sql: ${TABLE}.FEED_PRIVACY_DESCRIPTION ;;
  }

  dimension: feed_privacy_friends {
    type: string
    sql: ${TABLE}.FEED_PRIVACY_FRIENDS ;;
  }

  dimension: feed_privacy_value {
    type: string
    sql: ${TABLE}.FEED_PRIVACY_VALUE ;;
  }

  dimension: feed_promotable_id {
    type: string
    sql: ${TABLE}.FEED_PROMOTABLE_ID ;;
  }

  dimension: feed_promotion_status {
    type: string
    sql: ${TABLE}.FEED_PROMOTION_STATUS ;;
  }

  dimension: feed_reactions_id {
    type: string
    sql: ${TABLE}.FEED_REACTIONS_ID ;;
  }

  dimension: feed_reactions_name {
    type: string
    sql: ${TABLE}.FEED_REACTIONS_NAME ;;
  }

  dimension: feed_reactions_profile_type {
    type: string
    sql: ${TABLE}.FEED_REACTIONS_PROFILE_TYPE ;;
  }

  dimension: feed_reactions_type {
    type: string
    sql: ${TABLE}.FEED_REACTIONS_TYPE ;;
    drill_fields: [feed_type]
  }

  dimension: feed_reactions_username {
    type: string
    sql: ${TABLE}.FEED_REACTIONS_USERNAME ;;
  }

  dimension: feed_source {
    type: string
    sql: ${TABLE}.FEED_SOURCE ;;
  }

  dimension: feed_status_type {
    type: string
    sql: ${TABLE}.FEED_STATUS_TYPE ;;
  }

  dimension: feed_story {
    type: string
    sql: ${TABLE}.FEED_STORY ;;
  }

  dimension: feed_type {
    type: string
    sql: ${TABLE}.FEED_TYPE ;;
  }

# Create date fields
  dimension: feed_updated_date {
    type: date
    sql: left(${TABLE}.FEED_UPDATED_TIME,10) ;;
  }

  dimension: feed_updated_month {
    type: date_month
    sql: left(${TABLE}.FEED_UPDATED_TIME,10) ;;
  }

  dimension: feed_updated_day_of_week{
    type: date_day_of_week
    sql: left(${TABLE}.FEED_UPDATED_TIME,10) ;;
  }

  dimension: feed_updated_week{
    type: date_week
    sql: cast(left(${TABLE}.FEED_UPDATED_TIME,10) as date) ;;
  }


  dimension: name {
    type: string
    drill_fields: [feed_type, feed_description]
    sql: ${TABLE}.NAME ;;
  }

  dimension: name_with_location_descriptor {
    type: string
    hidden:  yes
    sql: ${TABLE}.NAME_WITH_LOCATION_DESCRIPTOR ;;
  }

  measure: rating_count {
    sql_distinct_key: ${id} ;;
    hidden: yes
    type: sum_distinct
    sql: ${TABLE}.RATING_COUNT ;;
  }

  measure: count_talking_about {
    sql_distinct_key: ${id} ;;
    type: sum_distinct
    sql: ${TABLE}.TALKING_ABOUT_COUNT ;;
  }

  dimension: verification_status {
    type: string
    sql: ${TABLE}.VERIFICATION_STATUS ;;
  }

  measure: were_here_count {
    sql_distinct_key: ${id} ;;
    type: sum_distinct
    sql: ${TABLE}.WERE_HERE_COUNT ;;
  }

  measure: count_posts {
    type: count_distinct
    sql: ${TABLE}.feed_id ;;
  }

  measure: count_comments {
    type: count_distinct
    sql: ${TABLE}.FEED_COMMENTS_ID ;;
  }

  measure: count_reactions {
    type: count_distinct
    sql: ${TABLE}.FEED_REACTIONS_ID ;;
  }

  measure: count_shares {
    type: sum_distinct
    sql_distinct_key: ${TABLE}.FEED_ID ;;
    sql: ${TABLE}.FEED_SHARES_COUNT ;;
  }

  measure: comments_per_post {
    type: number
    sql: ${count_comments} / ${count_posts} ;;
  }

  measure: shares_per_post {
    type: number
    sql: ${count_shares} / ${count_posts} ;;
  }

  measure: count_comment_likes {
    type: sum_distinct
    sql_distinct_key: ${feed_comments_id} ;;
    sql: ${TABLE}.feed_comments_like_count ;;
  }

  measure: count_child_comments {
    type: sum_distinct
    sql_distinct_key: ${feed_comments_id} ;;
    sql: ${TABLE}.feed_comments_comment_count ;;
  }


  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      name,
      feed_type
    ]
  }
}
