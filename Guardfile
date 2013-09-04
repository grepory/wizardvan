# vim: ft=ruby
# More info at https://github.com/guard/guard#readme
#
# More info also at https://github.com/guard/guard-rspec -- this one in
# particular details configuration options such as whether to run all tests
# after a failing test starts passing

guard :rspec do
  watch(%r{^spec/.+_spec\.rb})
  watch(%r{^lib/(.+)\.rb$}) do |m|
    "spec/lib/#{m[1]}_spec.rb"
  end
  watch('spec/spec_helper.rb') { "spec" }
  watch('spec/fixtures.rb') { "spec" }
  watch(%r{^spec/fixtures/}) { "spec" }
end
