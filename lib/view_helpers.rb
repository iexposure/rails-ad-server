module ViewHelpers
  def show_rads_banner(banner_type)
    banner_type = RadsBannerType.find_by_name(banner_type.to_s)
    if banner_type
      campaigns = RadsCampaign.find(:all, :include => "rads_banners", :conditions => ["rads_banners.rads_banner_type_id = ?", banner_type.id])
      total_budget = 0
      campaigns.each{ |campaign|
        total_budget += campaign.budget_remaining
      }
      campaign_fortune = {}
      i = 0
      campaigns.each{ |campaign|
        if campaign.budget_remaining > 0
          lower = i = i + 1 #increment by one to prevent overlap
          upper = i = ((campaign.budget_remaining.to_f/total_budget.to_f) * 100000) + i
          range = lower..upper
          campaign_fortune[range] = campaign
        end
      }
      random = rand(100000)
      campaign = nil
      campaign_fortune.each { |k,v|
        if k.include?(random)
          campaign = v
          break
        end
      }
      unless campaign.nil?
        banner = campaign.banner(banner_type.id)
        if banner and banner.image
          return link_to(image_tag(banner.image), :controller => "/rads", :action => "rads_click_to", :id => banner.id)
        elsif banner and banner.html
          return banner.html
        end
      end
    end
    return  link_to image_tag("/images/rads/advertise_here.gif"), "/advertise"
  end
  
  def show_rads_admin_panel(campaign_id,args={})
     campaign = RadsCampaign.find(campaign_id)
     render :partial => '/rads/banner_admin', :locals => {:campaign => campaign,:admin=> args[:admin].blank? ? false : true}
  end

  def show_rads_banner_html(banner_id)
    banner = RadsBanner.find(banner_id)
    if banner and banner.image
      return "<img src=\"#{banner.image}\">"
    elsif banner and banner.html
      return banner.html
    else
      return "Banner not found."
    end
  end
end
