panel t('dashboards.referrer_top_10'), :class => 'table'  do
  block do
    total_referrers = resource.total_referrers(params)
    referrers = resource.visits_by_referrer(params).limit(10).all
    if referrers.empty?
      h3 t('no_referrers_found')    
    else
      store referrers.to_table(:percent_of_visits => total_referrers)
    end
  end
end