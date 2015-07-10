module ApplicationHelper
  def default_meta_tags
    {
      title: t('site.title'),
      description: t('site.description')
    }
  end
end
