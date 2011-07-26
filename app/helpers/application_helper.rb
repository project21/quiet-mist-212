module ApplicationHelper
  DEBUG_ARG = {:debug => Rails.env.development?}

  def require_javascript *args
    if args.last.is_a?(Hash)
      last_arg = args.pop
      javascript_include_tag *args, DEBUG_ARG.merge(last_arg)
    else
      javascript_include_tag *args, DEBUG_ARG
    end
  end
end
