ignore_paths 'daemons'

group 'specs' do
  guard 'rspec', :cli => '--color --format doc' do
    watch(%r{^spec/.+_spec\.rb$})
    #watch(%r/^(.+)\.rb$/)         { |m| "spec/handlers/#{m[1]}_spec.rb" }
  end
  guard 'bundler' do
    watch 'Gemfile'
  end
end

# linux
# rb-inotify
# libnotify

# OS X
# rb-fsevent
# growl_notify

guard 'livereload', :apply_js_live => false do
  watch(%r{app/.+\.(erb|haml)})
  #watch(%r{app/helpers/.+\.rb})
  #watch(%r{(public/|app/assets).+\.(css|js|html)})
  watch(%r{(app/assets/.+\.css)\.s[ac]ss}) { |m| m[1] }
  watch(%r{(app/assets/.+\.js)\.coffee}) { |m| m[1] }
  watch(%r{config/locales/.+\.yml})
end
