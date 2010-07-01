module Multiloop
  def all(*args,&block)
    # find the first array argument
    aarg=args.index{|x| x.class==Array}
    if aarg
      args[aarg].each do |v|
        replaced=args.clone
        replaced[aarg]=v
        all *replaced,&block
      end
    else
      block.call(args)
    end
  end
end
