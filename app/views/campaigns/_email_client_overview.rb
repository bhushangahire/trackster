panel t('campaigns.impressions_by_browser'), :class => 'table sixcol'  do
  block do
    impressions = (@account || @campaign || @property).tracks.impressions.by(:browser).order('impressions DESC').between(Track.period_from_params(params)).all
    impressions.reject!{|item| item[:impressions] == 0 }
    if impressions.empty?
      h3 t('no_impressions_yet')
    else
      total_impressions = impressions.sum(:impressions)
      store impressions.to_table(:percent_of_impressions => total_impressions)
    end
  end
end
