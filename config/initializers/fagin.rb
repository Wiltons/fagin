module Fagin
  def self.[](key)
    unless @config
      raw_config = File.read("#{Rails.root}/config/fagin.yml")
      @config = YAML.load(raw_config)[Rails.env].symbolize_keys
    end
    @config[key]
  end
end
