ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel "Recent Links" do
          ul do
            Link.last(10).map do |link|
              li link_to(link.title, admin_user_link_path(link))
            end
          end
        end
      end

      column do
        panel "Info" do
          para "Welcome to ActiveAdmin."
        end
      end
    end
  end # content
end