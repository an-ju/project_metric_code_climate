Code Climate Project Metrics
============================

Defines scalar and image for CodeClimate Project Metrics

Gemfile:
 
 gem 'project_metric_code_climate', git: 'https://github.com/AgileVentures/project_metric_code_climate'
 gem 'project_metrics', git: 'https://github.com/AgileVentures/ProjectMetrics/'

main.rb: 
 require 'project_metrics'
 ProjectMetrics.configure do 
 add_metric :project_metric_code_climate
 end
 ProjectMetrics.metric_names ```
["project_metric_code_climate"]

ProjectMetrics.class_for('code_climate')
ProjectMetricCodeClimate

sample_point = ProjectMetrics.class_for('code_climate').new url: 'http://github.com/AgileVentures/WebsiteOne'
#<ProjectMetricCodeClimate:0x007fd2428700c0 @identifier="github/AgileVentures/WebsiteOne", @raw_data=nil>


sample_point.score
3.5

sample_point.image
"https://codeclimate.com/github/AgileVentures/WebsiteOne/badges/gpa.svg"

He we have some preexisting raw data in raw_data that would be used to compute a gpa of 3.2:

sample_point.raw_data = raw_data

sample_point.score
3.2

Then we refresh, calling out to the network
sample_point.refresh
true

And we're back to live data of 3.5

sample_point.score
3.5
