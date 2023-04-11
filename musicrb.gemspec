Gem::Specification.new "musicrb", "0.1.0" do |s|
  s.summary     = "A player for music"
  s.description = "A player for music"
  s.authors     = ["juneira"]
  s.email       = "marcelo.jr63@gmail.com"
  s.files       = %w[lib/musicrb.rb lib/play_list.rb lib/musicrb/musicrb.so]
  s.homepage    = "https://github.com/juneira/musicrb"
  s.license     = "MIT"
  s.extensions  = %w[ext/musicrb/extconf.rb]
end

