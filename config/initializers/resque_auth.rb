Resque::Server.use(Rack::Auth::Basic) do |user, password|
  password == 'gfhjkm'
end