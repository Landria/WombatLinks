Resque::Server.use(Rack::Auth::Basic) do |user, password|
  (user == Settings.resque.admin.user) and (password == Settings.resque.admin.pass)
end