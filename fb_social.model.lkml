connection: "snowflake"

# include all the views
#include: "*.view"

# include all the dashboards
include: "*"

#include: "*.dashboard.lookml"
#include: "*.view.lookml""

datagroup: fb_social_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: fb_social_default_datagroup


explore: feed {
  view_name: feed
}

explore: insights {
  view_name: post_insights
  join: page_insights {
    type: full_outer
    relationship: many_to_one
    sql_on: ${post_insights.page_id} = ${page_insights.id} and ${post_insights.date} = ${page_insights.date};;
  }
}
