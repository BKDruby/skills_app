class Object
  def tap_and_chain_if(condition)
    return self unless condition
    yield self
  end
end
