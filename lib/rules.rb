module Rules
  def self.read(settings,key,default=nil)
    read!(settings,key) rescue default
  end
  
  def self.read!(settings,key)
    if key.is_a?(Array)
      key.each do |k| 
        raise SettingMissing,k unless settings && settings.has_key?(k)
        settings = settings[k]      
      end
      settings
    else
      raise SettingMissing,key unless settings && settings.has_key?(key)
      settings[key]
    end
  end
  
end