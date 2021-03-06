class RadsBanner < ActiveRecord::Base
  belongs_to :rads_campaign
  belongs_to :rads_banner_type
  has_many :rads_banner_stats

  def cpm
    self.rads_banner_type.cpm
  end

  def self.reloadable?
    false
  end
end
