# Call this file 'foo.rb' (in logstash/filters, as above)
require "logstash/filters/base"
require "logstash/namespace"

class LogStash::Filters::Foo < LogStash::Filters::Base

  # Setting the config_name here is required. This is how you
  # configure this filter from your logstash config.
  #
  # filter {
  #   foo { ... }
  # }
  config_name "disjoin"

  # New plugins should start life at milestone 1.
  milestone 1

  config :includes, :validate => :array
  config :cancel, :validate => :boolean

  public
  def register
    # nothing to do
  end # def register

  public
  def filter(event)
    # return nothing unless there's an actual filter event
    return unless filter?(event)
    if @includes
      @includes.each { |field| 
        event_clone = event.clone
        @includes.each { |exclude|
          next if field == exclude
          event_clone.remove(exclude)
        }
        filter_matched(event_clone)

        # Push this new event onto the stack at the LogStash::FilterWorker
        yield event_clone
      }
    end
    # filter_matched should go in the last line of our successful code 
    if @cancel
      event.cancel()
    end
    filter_matched(event)
  end # def filter
end # class LogStash::Filters::Foo
