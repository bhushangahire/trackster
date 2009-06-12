panel t('dashboards.video_summary'), :class => 'table'  do
  @videos.each do |video|
    block do
      @events_summary = @property.video_summary(video, params).all
      unless @events_summary.empty?
        h3 I18n.t('videos.video', :name => video)
        store @events_summary.to_table
      end
    end
  end
end