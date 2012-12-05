ActiveAdmin.register Promo do
  form do |f|
    f.inputs "User" do
      f.input :active_upto
      f.input :registration

    end
    f.actions
  end
end
