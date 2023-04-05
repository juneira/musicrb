require "rake/testtask"
require "rake/extensiontask"

Rake::ExtensionTask.new "musicrb" do |ext|
  ext.lib_dir = "lib/musicrb"
end

Rake::TestTask.new do |t|
  t.libs << "test"
end

desc "Run tests"
task default: :test
