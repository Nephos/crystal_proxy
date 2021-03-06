module HttpDistributor
  # The configuration is a class to handle the configuration of the project.
  # It does mean the default values, and its integrity.
  #
  # It is also used to apply the configuration by using these parameters.
  class Configuration
    # Probability for each request to use a new user agent
    @change_agent_probability : Number::Primitive
    # Duration to wait before any new request on a domain
    @wait_fixed : Number::Primitive
    # Duration range to wait before any new request on a domain
    @wait_random : Range(Float64, Float64)?
    # Coeficient to multiply the delay before any new request on a domain
    # delay = wait + ping * coeficient
    @wait_delay_coefficient : Number::Primitive
    # Keep log during n seconds. Influence memory usage
    @keep_log_duration : UInt32

    getter change_agent_probability, wait_fixed, wait_random, wait_delay_coefficient,
      keep_log_duration
    setter change_agent_probability, wait_fixed, wait_random, wait_delay_coefficient,
      keep_log_duration

    def initialize(@change_agent_probability = 0.05,
                   @wait_fixed = 1,
                   @wait_random = nil,
                   @wait_delay_coefficient = 1.0,
                   keep_log_duration = 60)
      @keep_log_duration = keep_log_duration.to_u32
    end

    # return a valid duration to wait, in seconds
    def wait : Number::Primitive
      if @wait_random.nil?
        @wait_fixed
      else
        rand @wait_random.as(Range(Float64, Float64))
      end
    end

    def to_h
      wait_random_display = @wait_random.nil? ||
        [(@wait_random.as(Range(Float64, Float64))).begin, (@wait_random.as(Range(Float64, Float64))).end]
      {
        "wait_fixed"               => @wait_fixed,
        "wait_random"              => wait_random_display,
        "wait_delay_coefficient"   => @wait_delay_coefficient,
        "change_agent_probability" => @change_agent_probability,
      }
    end
  end
end
