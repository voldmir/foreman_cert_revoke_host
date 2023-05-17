module H
  def method_missing(sym, *)
    r = fetch(sym) { fetch(sym.to_s) { super } }
    Hash === r ? r.extend(H) : r
  end
end
