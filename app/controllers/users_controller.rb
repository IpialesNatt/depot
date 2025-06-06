class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

    rescue_from "User::Error" do |exception|
    redirect_to users_url, notice: exception.message
  end

  # GET /users or /users.json
  def index
  @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

    # POST /users or /users.json
    def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html {
          redirect_to users_url,
          notice: "User #{@user.name} was successfully created."
        }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

   # PATCH/PUT /users/1 or /users/1.json
   def update
  # Solo si el usuario intenta cambiar su contraseña
  if user_params[:password].present?
    unless @user.authenticate(params[:current_password])
      @user.errors.add(:current_password, "is incorrect")
      return render :edit, status: :unprocessable_entity
    end
  end

  if @user.update(user_params)
    redirect_to users_url, notice: "User #{@user.name} was successfully updated."
  else
    render :edit, status: :unprocessable_entity
  end
end

 # DELETE /users/1 or /users/1.json
def destroy
    @user.destroy!
    respond_to do |format|
      format.html do
        redirect_to users_path,
                    status: :see_other,
                    notice: "User #{@user.name} deleted"
      end
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
       @user = User.find(params[:id])
    end

     # Only allow a list of trusted parameters through.
     def user_params
      params.expect(user: [
        :name,
        :email_address,
        :password,
        :password_confirmation
      ])
    end
end
