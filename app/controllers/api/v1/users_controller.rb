# frozen_string_literal: true

module Api
  module V1
    # Users controller
    class UsersController < ProtectedController
      PROFILE_ATTRIBUTES_LIST = %w[first_name last_name phone].freeze
      VALID_QUERY_PROFILE_FIELDS = %w(first_name last_name).freeze
      USER_DISPLAY_ATTRIBUTES_LIST = %w[id email].freeze
        
      include Orderable

      before_action :authenticate
      before_action :check_permissions, only: [:create, :destroy]
      before_action :access_to_foreign_resources, only: [:update, :show]
      before_action :set_user, only: [:update, :show, :destroy]

      # GET /api/v1/users
      def index
        users_scope = admin? ? users_collection.all : users_collection.client
        render json: users_scope.map { |u| cat_list_attributes(u) }, status: :ok
      rescue => e
        log_and_render_users_controller_error(e, "display list of users failed")
      end

      # GET /api/v1/users/:id
      # GET /api/v1/users/:field/:value
      def show
        render json: get_full_user_details(user), status: :ok
      rescue => e
        log_and_render_users_controller_error(e, "get user details failed")
      end

      # POST /api/v1/users
      def create
        user = users_collection.new(user_permitted_params)
        if user.save
          render json: { message: "User successfully created", id: user.id }
          return
        end
        render_response("Сreation failed: #{user.errors.full_messages.join('; ')}", 400)
      rescue => e
        log_and_render_users_controller_error(e, "create user failed")
      end

      # PUT /api/v1/users/:id
      def update
        user.assign_attributes user_permitted_params
        if user.save
          head :no_content
          return
        end
        render_response("Updating failed: #{user.errors.full_messages.join('; ')}", 400)
      rescue => e
        log_and_render_users_controller_error(e, "user update failed")
      end

      # DELETE /api/v1/users/:id
      def destroy
        user.destroy
        head :no_content
      rescue => e
        log_and_render_users_controller_error(e, "destroy user failed")
      end

      private

      attr_reader :user

      def set_user
        @user = users_collection.find_by(build_query)
        render_not_found && return unless user
      end

      def build_query
        return { id: params[:id] } unless search_by_field?
        render_response("Invalid field. Valid fields: #{valid_query_fields}", 400) && return unless search_field_valid?
        query = { "#{params[:field]}": params[:value] }
        query = { profiles: query } if search_field_belongs_to_profile?
        query
      end

      def valid_query_fields
        %w(email) + VALID_QUERY_PROFILE_FIELDS
      end

      def search_by_field?
        params[:field].present? && params[:value].present?
      end

      def search_field_valid?
        valid_query_fields.include? params[:field]
      end

      def search_field_belongs_to_profile?
        VALID_QUERY_PROFILE_FIELDS.include? params[:field]
      end

      def check_permissions
        render_not_allowed && return unless admin?
      end

      def access_to_foreign_resources
        render_not_allowed && return if no_access_to_foreign_resources?
      end

      def cat_list_attributes(user)
        user.attributes.slice(*USER_DISPLAY_ATTRIBUTES_LIST).merge(user_enum_attributes(user))
      end

      def user_enum_attributes(user)
        { role: user.role }
      end

      def get_full_user_details(user)
        cat_list_attributes(user).merge(profile_attributes(user))
      end

      def no_access_to_foreign_resources?
        not_admin? && params[:id] != current_user.id.to_s
      end

      def profile_attributes(user)
        user.profile.attributes.slice("first_name", "last_name", "phone", "created_at", "updated_at")
      end

      def user_permitted_params
        params.slice(*user_attributes_list).merge(profile_attributes: profile_params)
              .permit(:email, :password, profile_attributes: PROFILE_ATTRIBUTES_LIST.map(&:to_sym))
      end

      def profile_params
        params.slice(*PROFILE_ATTRIBUTES_LIST)
      end

      def user_attributes_list
        user_attributes_list = %w[email password]
        user_attributes_list << "role" if admin?
        user_attributes_list
      end

      def log_and_render_users_controller_error(e, message)
        log_error(e, "[Api::V1::Users::UsersController] #{message}. " \
                     "User id: #{current_user.id}, params: #{params.inspect}")
        render_error(e)
      end

      def render_not_found
        render_response("User with id: #{params[:id]} not found", 404)
      end

      def render_not_allowed
        render_response("You are not allowed", 403)
      end

      def prepare_nessted_ordering_params
        PROFILE_ATTRIBUTES_LIST.each_with_object(ordering_params(params)) do |attr, memo|
          memo.gsub!(attr, "#{profiles_collection.table_name}.#{attr}") if memo.include? attr
        end
      end

      def need_order?
        action_name == "index" && params[:sort].present?
      end

      def users_collection
        User
          .tap_and_chain_if(action_name == "show" || need_order?) { |c| c.includes(:profile) }
          .tap_and_chain_if(need_order?) { |c| c.reorder(prepare_nessted_ordering_params) }
      end

      def profiles_collection
        Profile
      end
    end
  end
end
