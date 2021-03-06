class CruddyController < ApplicationController

  before_filter :set_resource, except: [:new, :create]
  before_filter :set_resources, only: [:index, :new, :create]
  before_filter :create_resource, only: [:new, :create]


  def index
    render 'cruddy/index'
  end

  def new
    render 'cruddy/new'
  end

  def create
    @resource.update crud_params
    render 'cruddy/create'
  end

  def show
    render 'cruddy/read'
  end

  def edit
    render 'cruddy/read'
  end

  def update
    @resource.update crud_params
    @updated_fields = crud_params.map { |field, _| field }
    render 'cruddy/update'
  end

  def destroy
    @resource.destroy
    render 'cruddy/destroy'
  end


  private

  def model
    self.class.to_s[0..-11].singularize.constantize
  end

  def model_formatted
    "@#{model}".downcase
  end

  def set_resource
    @resource = if params[:id]
                  model.find params[:id]
                else
                  nil
                end
    self.instance_variable_set model_formatted.to_sym, @resource
  end

  def set_resources
    @resources = if model.columns.map{|c| c.name}.include? 'context_id'
                   if session[:context].present?
                     model.where context_id: session[:context]
                   else
                     model.where context_id: nil
                   end
                 else
                   model.all
                 end
    self.instance_variable_set model_formatted.pluralize.to_sym, @resources
  end

  def create_resource
    @resource = model.create
    if session[:context].present? && @resource.respond_to?(:context)
      @resource.context = current_context
      @resource.save
    end
    self.instance_variable_set model_formatted.to_sym, @resource
  end

  def crud_params
    send "#{model.to_s.singularize.underscore}_params"
  end

end
