module ProxyAPI
  class ProxyException < ::StandardError
    attr_accessor :url

    def initialize(url, exception, message, *params)
      super(message, *params)
      @url = url
    end

    def message
      super + " " + "for proxy" + " " + url
    end
  end

  class Puppetca
    def initialize(args)
    end

    def del_certificate(certname)
    end
  end
end
