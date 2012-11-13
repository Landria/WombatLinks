class UserDomainUniquenessValidator < ActiveModel::Validator
  def validate(record)
    record.errors[:url] << I18n.t('activerecord.errors.models.user_watch.attributes.url.is already being watched') unless check(record)
  end

  private

  def check(record)
    UserWatch.accessible? record.url, record.user_id
  end
end

