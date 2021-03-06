module ApplicationHelper
  def trigger_flash_notice
    link_to 'Flash Notice', '', id: 'trigger_flash_notice'
  end

  def trigger_flash_alert
    link_to 'Flash Alert', '', id: 'trigger_flash_alert'
  end

  def hide_stuff
    link_to 'Cloak Container', '', id: 'cloak_container'
  end

  def site_logo(options = {})
    path = 'skela_logo'

    if options[:color]
      path << '_'
      path << options[:color]
    end

    path << '.svg'

    klass = options[:background] ? 'background' : ''

    image_tag(path, id: 'site_logo', class: klass)
  end

  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object)
    yield presenter if block_given?
    presenter
  end

  def my_profile_nav(&block)
    klass = 'nav_link'
    klass << ' selected' if params[:controller] == 'users' && params[:action] == 'my_profile'
    link_to my_profile_path, remote: true, id: 'logged_in_user', class: klass, data: { fade_content: true, swap_title: 'My Profile' } do
      block.call
    end
  end

  def logging_in?
    controller_action? 'login', 'new_session'
  end

  def signing_up?
    controller_action? 'login', 'signup'
  end

  def controller_action?(controller, action)
    params[:controller] == controller && params[:action] == action
  end

  def time_ago(datetime)
    "#{distance_of_time_in_words(Time.now, datetime)} ago"
  end

  def navigation_link(target, parent = target, routing_controllers = [])
    klass = 'nav_link'
    if params[:controller] == target
      klass << ' selected'
    else
      routing_controllers.each do |c|
        klass << ' selected' if params[:controller] == c
      end
    end
    link_to target.titleize, send("#{target}_path"), remote: true, class: klass, data: { path: target, parent: parent, fade_content: true }
  end

  def circle_add
    content_tag :i, class: 'material-icons md-icon md-48', style: 'color: #2d5daf' do
      'add_circle'
    end
  end

  def days_since(event)
    (Time.now - event.to_datetime).to_i / 3600 / 24
  end

  def get_next_weekday(weekday)
    weekday = "#{weekday}?".to_sym
    (Date.today..Date.today + 1.week).find { |day| day.send weekday }
  end

  def publish_link(record)
    text = record.published ? '<i class="material-icons">visibility</i>'.html_safe : '<i class="material-icons">visibility_off</i>'.html_safe
    klass = record.class.to_s.underscore
    title = record.published ? 'Public' : 'Private'
    link_to(text, send("#{klass}_path", klass => { published: !record.published }, id: record.id), id: 'publish_link', title: title, data: { method: :put, remote: true })
  end

  def destroy_link(record, nav = true)
    klass = record.class.to_s.underscore
    title = klass.titleize.pluralize
    path = send(klass + '_path', record)
    data = { method: :delete, remote: true, collapse: true }
    if nav
      data.merge! fade_content: true, swap_title: title
    end
    link_to trash_icon_right, path, data: data, class: "destroy_crud destroy_#{klass}"
  end

  def md_icon(icon, huge = false)
    content_tag :i, icon, class: "material-icons#{' huge' if huge}"
  end

  def div_tag(content, options)

  end

  def avatar(user = nil, size = nil)
    avatar_path = if user.nil?
                    Avatar.default
                  else
                    user.avatar ? user.avatar.path : Avatar.default
                  end

    fixed_size = size ? "width:#{size}px;height:#{size}px;" : ''
    image_tag(avatar_path, class: 'avatar', style: "background: gray; border-radius:50%;#{fixed_size}")
  end

  def login_link
    if logged_in?
      link_to 'Logout', logout_path, id: 'logout_button', data: { remote: true, method: :delete, fade_content: true, swap_title: 'Authenticate'}, class: 'user_link link_2'
    else
      link_to 'Login', login_path, id: 'login_link', class: 'nav_link', data: { remote: true, fade_content: true, swap_title: 'Authenticate', theme: 'login' }
    end
  end
end
