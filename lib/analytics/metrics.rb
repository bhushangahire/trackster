module Analytics
  module Metrics
    def self.included(base)
      base.class_eval do

        # Pages_views calculated because following dimensions may include
        # events anyway and the cross-product of the two tables will
        # mess up totals.
        named_scope :page_views, lambda{ |*args|
          if args.first && args.first == :with_events
            {:select => "count(*) as page_views",
            :conditions => "category = '#{Event::PAGE_CATEGORY}' AND action = '#{Event::VIEW_ACTION}' AND url IS NOT NULL",
            :joins => :events}
          else
            {:select => "sum(page_views) as page_views"}
          end
        }

        named_scope :video_views,
          :select => "count(*) as video_views",
          :conditions => "events.category = '#{Event::VIDEO_CATEGORY}' and events.action = '#{Event::VIDEO_PLAY}'",
          :joins => :events
            
        # Maximum view time of a video
        named_scope :video_playtime,
          :select => "max(events.value) as maxplay",
          :conditions => "events.category = '#{Event::VIDEO_CATEGORY}' AND events.action = '#{Event::VIDEO_MAXPLAY}'",
          :joins => :events

        # Can only count sessions that have visitors
        named_scope :visitors,
          :select => 'count(DISTINCT visitor) as visitors',
          :conditions => "visitor IS NOT NULL"

        # Each session is a visit
        named_scope :visits,
          :select => 'count(*) as visits'

        # Visitors for whom this was their first visit
        named_scope :new_visitors,
          :select => 'count(*) as new_visitors',
          :conditions => "visit = 1"

        # Visitors who have visited more than once in the current period
        # Without further scoping this is meaningless - but the #between scope
        # needs to see this first
        named_scope :repeat_visitors,
          :select => 'count(DISTINCT visitor) as repeat_visitors',
          :conditions => "previous_visit_at IS NOT NULL"

        named_scope :repeat_visits,
          :select => 'count(*) as repeat_visits',
          :conditions => "previous_visit_at IS NOT NULL"

        # Visitors who visited before the current period and have now returned
        # Needs to be scoped with previous_visit_at before a relevant period
        named_scope :return_visitors,
          :select => 'count(DISTINCT visitor) as return_visitors',
          :conditions => "previous_visit_at IS NOT NULL"

        named_scope :return_visits,
          :select => 'count(*) as return_visits',
          :conditions => "visit > 1 AND previous_visit_at IS NOT NULL"

        # Entry page is marked in the events table
        named_scope :entry_pages,
          :select => 'count(*) as entry_pages',
          :conditions => 'entry_page = 1',
          :joins => :events
    
        # Landing page is the same as an entry page - but in a campaign
        # context
        named_scope :landing_pages,
          :select => 'count(*) as landing_pages',
          :conditions => "entry_page = 1 and url IS NOT NULL and campaign_name IS NOT NULL"
          
        named_scope :clicks_through,
          :select => 'count(*) as clicks_through',
          :conditions => "campaign_medium = 'email' AND campaign_name IS NOT NULL"

        named_scope :exit_pages,
          :select => 'count(*) as exit_pages',
          :conditions => "exit_page = 1",
          :joins => :events

        # Duration is marked in the Session table for the total of the session
        named_scope :duration,
          :select => 'avg(duration) as duration'

        named_scope :bounces,
          :select => 'count(*) as bounces',
          :conditions => 'duration = 0'
          
        named_scope :impressions,
          :select => 'count(*) as impressions',
          :conditions => "category = '#{Event::EMAIL_CATEGORY}' AND action = '#{Event::OPEN_ACTION}'",
          :joins => :events

        named_scope :latency, 
          :select => "CAST(AVG(time_to_sec(events.created_at) - time_to_sec(tracked_at)) AS signed) AS latency",
          :conditions => 'events.created_at IS NOT NULL AND events.tracked_at IS NOT NULL',
          :joins => :events
      end
    end
  end
end