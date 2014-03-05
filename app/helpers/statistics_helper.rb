module StatisticsHelper
  def cubic_cyclic_data_graph(data,start,normalize=nil,scalex=24.0,scaley=1.0)
    scalex/=24.0
    l=data.length
    last=data[(start-1)%l]
    last=last.to_f/normalize if normalize
    result="M #{-0.5*scalex} #{last*scaley}"
    (0..l).each do |i|
      current=data[(start+i)%l]*scaley
      current=current.to_f/normalize if normalize
      x=i*scalex
      result+=[' C',x,last,x,current,(i+0.5)*scalex,current].join(' ')
      last=current
    end
    result
  end
  def hour_statistic_svg(user=nil)
    i = user ? user.id : nil
    url=statistic_path(:format=>'svg',:action=>:hours,:user=>i)
    "<object data='#{url}' type='image/svg+xml' width='768' height='230'><param name='src' value='#{url}' /></object>"
  end
end
