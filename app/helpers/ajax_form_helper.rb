module AjaxFormHelper
  def ajax_string(field, resource = @resource)
    ajax_form 'string', resource, field
  end

  def ajax_subject(field, resource = @resource, focus_target = false)
    ajax_form 'subject', resource, field
  end

  def ajax_notes(field, resource = @resource)
    ajax_form 'notes', resource, field
  end

  def ajax_text(field, resource = @resource)
    ajax_form 'text', resource, field
  end

  def ajax_number(field, resource = @resource)
    ajax_form 'number', resource, field
  end

  def ajax_price(field, resource = @resource)
    ajax_form 'price', resource, field
  end

  def ajax_user_select(field, resource = @resource)
    ajax_form 'user_select', resource, field
  end

  def ajax_boolean(field, resource = @resource)
    ajax_form 'boolean', resource, field
  end

  def ajax_datetime(field, resource = @resource, value = nil)
    ajax_form 'datetime', resource, field, value
  end

  def ajax_date(field, resource = @resource, value = nil)
    ajax_form 'date', resource, field, value
  end

  def ajax_time(field, resource = @resource)
    ajax_form 'time', resource, field
  end

  def ajax_form(type, resource, field, value = nil)
    klass = type
    form_for resource, html: { id: "edit_issue_#{field}", class: klass}, remote: true do |f|
      case type
        when 'user_select'
          user_select f, field, resource
        when 'number'
          f.number_field field, class: 'ajax_field'
        when 'string'
          f.text_field field, class: 'ajax_field'
        when 'notes'
          f.text_area field, class: 'ajax_field notes', placeholder: 'Notes'
        when 'subject'
          f.text_field field, class: 'ajax_field subject', placeholder: "New #{resource.class.to_s}"
        when 'text'
          f.text_area field, class: 'ajax_field'
        when 'boolean'
          (f.label field) + (f.check_box field, class: 'ajax_field')
        when 'datetime'
          value = if resource.send(field)
            resource.send(field).in_time_zone('Eastern Time (US & Canada)').strftime('%FT%R')
          else
            nil
          end
          f.datetime_local_field field, class: 'ajax_field', value: value
        when 'time'
          f.time_field field, class: 'ajax_field'
        when 'date'
          f.date_field field, class: 'ajax_field'
      end
    end
  end

  def user_select(form_builder, field, resource)
    form_builder.select field, options_for_select(User.all.map { |user| [user.username, user.id.to_s]}, resource.send(field)), { include_blank: true }, { class: 'ajax_field' }
  end

  def updated_field_at(field, object, options = {})
    klass = 'updated_at'
    klass << ' invisible' if options[:cloaked]
    content_tag :span, data: { field: field, id: object.id }, class: klass do
      if object.send field
      'updated: ' + object.send(field).in_time_zone('Eastern Time (US & Canada)').strftime('%B %e, %Y at %l:%M:%S %p')
      end
    end
  end

  def edit_field(object, field, type)
    send("ajax_#{type.to_s}", field, object)
  end

  def add_field(object, field, type)
    content_tag :a, data: { add_field: true } do
      "Add #{field.to_s.titleize}".html_safe +
          content_tag(:template, edit_field(object, field, type), class: 'edit')
    end
  end

  def read_field(object, field, type)
    content_tag :span, class: 'read' do
      object.send(field).to_s.html_safe +
          content_tag(:template, edit_field(object, field, type), class: 'edit')
    end
  end

  def edit_fields(object, fields = {})
    content_tag :dl do
      fields.map do |field, type|
        content_tag(:dt, field.to_s.titleize) +
            content_tag(:dd, send("ajax_#{type.to_s}", field, object))
      end.reduce :+
    end
  end

  def optional_fields(object, fields = {})
    content_tag :dl do
      fields.map do |field, type|
        dt = content_tag(:dt, field.to_s.titleize)
        dd = content_tag :dd do
          if object.send(field).nil? || !object.send(field).present?
            add_field object, field, type
          else
            read_field object, field, type
          end
        end
        dt + dd
      end.reduce :+
    end
  end
end
