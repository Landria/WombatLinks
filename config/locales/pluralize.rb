I18n::Backend::Simple.send(:include, I18n::Backend::Pluralization)
{
    :'ru' => { :i18n => { :plural => { :rule => lambda { |n| [1].include?(n % 100) && ![11].include?(n % 100) ? :one : [2].include?(n % 100) && ![12].include?(n % 100) ? :two : [3, 4].include?(n % 100) && ![13, 14].include?(n % 100) ? :few : :other }}}}
}