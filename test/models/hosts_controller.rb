class HostsController
  attr_reader :params
  attr_reader :logger

  def self.before_action(proc, args = {})
    methods = args.has_key?(:only) ? (args[:only].is_a? Array) ? args[:only] : [args[:only]] : []

    (@@filter_action ||= {}).merge!({ proc => methods }) do |key, oldval, newval|
      (oldval + newval).flatten.uniq
    end
  end

  def initialize(params = {})
    m = {}
    @@filter_action.each do |k, v|
      v.each do |a|
        m.merge!({ a => [k] }) do |key, oldval, newval|
          (oldval + newval).flatten.uniq
        end
      end
    end
    m.each do |method, methods_call|
      self.instance_eval %Q{
        def #{method}(*args, &block)
            #{methods_call.join('\n')}
            result = super
        end
      }
    end
    @params = params
    @logger = Logger.new
  end

  def destroy
    "removed"
  end

  private

  def find_resource
    @host = Hosts.new(params)
  end

  def process_success(*args)
    args.first.inspect
  end

  def process_error(*args)
    args.first.inspect
  end

  def _(str)
    str
  end
end
