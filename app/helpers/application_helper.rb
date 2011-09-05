module ApplicationHelper
  DEBUG_ARG = {:debug => Rails.env.development?}

  def user_json
    attrs = (current_user.try(:attributes) || {}).slice('id', 'email', 'firstname', 'lastname', 'image_url', 'major','school_id', 'photo')
    attrs['courses'] = current_user.courses.inject({}) {|hsh,c| hsh[c.id] = c.name; hsh }
    attrs.to_json.html_safe
  end

  def require_javascript *args
    if args.last.is_a?(Hash)
      last_arg = args.pop
      javascript_include_tag *args, DEBUG_ARG.merge(last_arg)
    else
      javascript_include_tag *args, DEBUG_ARG
    end
  end
end
