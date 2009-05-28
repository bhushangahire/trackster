panel t('dashboards.referrer_top_10'), :class => 'table'  do
  block do
    referrers = @property.tracks.visits.by(:referrer_host).filter('referrer_host IS NOT NULL').limit(10).order('visits DESC').between(Track.period_from_params(params)).all
    if referrers.empty?
      store t('.no_referrers_found')
    else
      store referrers.to_table
    end
  end
end