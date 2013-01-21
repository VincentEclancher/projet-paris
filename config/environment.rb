# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
ProjetParis::Application.initialize!

Scheduler.schedule_clean
Scheduler.schedule_parse