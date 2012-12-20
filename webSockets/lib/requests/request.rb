module Request
  class Request
    include Virtus
    attributes :message, :type
  end
end