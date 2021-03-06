module CruddyHelper
  def cruddier_table(collection, options = {})
    content_tag :ul, class: 'cruddy_table', id: options[:id] do
      if collection.present?
        collection.map do |crud|
          content_tag :li, class: 'cruddy_resource', data: { resource_id: crud.id, type: crud.class.to_s.underscore } do
          content_tag :div, class: 'compact' do
          render partial: 'cruddy/compact', locals: { crud: crud, type: crud.class.to_s.underscore.pluralize }
          end
          end
        end.reduce :+
      else
        # content_tag :span, 'No records match this criteria', class: 'half_gray'
      end
    end
  end

  def cruddy_table(options)
    id = options[:type] ? options[:type].pluralize : controller_name
    content_tag :ul, class: 'cruddy_table', id: id do
      if options[:resources]
        options[:resources].map do |resource|
          content_tag :li, class: 'cruddy_resource', data: { resource_id: resource.id } do
            content_tag :div, class: 'compact' do
              render partial: options[:compact] || 'compact', locals: { crud: resource }
            end
          end
        end.reduce :+
      end
    end
  end

  def crud_wrapper(resource, content, view = 'compact')
    content_tag :li, class: 'cruddy_resource', data: { resource_id: resource.id } do
      content_tag :div, class: view do
        content
      end
    end
  end

  def new_cruddy_resource(resource, hidden = false)
    content_tag :li, class: 'cruddy_resource', data: { resource_id: resource.id, type: resource.class.to_s.underscore } do
      views = content_tag :div, class: 'compact', style: 'display:none;' do
        render partial: 'compact', locals: { crud: resource }
      end
      views += content_tag :div, class: 'full', style: hidden ? 'display:none;' : '' do
        render partial: 'full', locals: { crud: resource }
      end
      views
    end
  end

  def collapse_button
    content_tag :a, class: 'collapse' do
      md_icon 'expand_less'
    end
  end

  def button(text, path, selected = false, data = {})
    data.merge! remote: true
    link_to text, path, class: "button#{' selected' if selected}", data: data
  end
end
