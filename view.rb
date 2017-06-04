require "action_view"
require "action_view/helpers"
require "active_support/core_ext"
include ActionView::Helpers::DateHelper

Time.zone = 'Eastern Time (US & Canada)'
t = rand(10)
puts time_ago_in_words(Time.now, include_seconds: true)
puts time_ago_in_words(t.minutes.from_now, include_seconds: true) #seconds isn't shown
puts time_ago_in_words(Time.zone.parse('January 1, 2017'))
puts distance_of_time_in_words_to_now(Time.zone.parse('January 1, 2015'))
