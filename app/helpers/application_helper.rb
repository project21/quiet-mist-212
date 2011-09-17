module ApplicationHelper
  DEBUG_ARG = {:debug => Rails.env.development?}

  def user_json
    return {}.to_json unless current_user
    attrs = current_user.attributes.slice('id', 'email', 'firstname', 'lastname', 'image_url', 'major','school_id')
    attrs['image_url'] = current_user.avatar_url
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
