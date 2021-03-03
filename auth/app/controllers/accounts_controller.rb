class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_account!, only: [:index]

  # GET /accounts
  # GET /accounts.json
  def index
    @accounts = Account.all
  end

  # GET /accounts/current.json
  def current
    respond_to do |format|
      format.json  { render :json => current_account }
    end
  end

  # GET /accounts/1/edit
  def edit
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      new_role = @account.role != account_params[:role] ? account_params[:role] : nil

      if @account.update(account_params)
        # ----------------------------- produce event -----------------------
        # Events::AccountUpdated.new(payload).to_h.to_json
        event = {
          **account_event_data,
          event_name: 'AccountUpdated',
          data: {
            public_id: @account.public_id,
            email: @account.email,
            full_name: @account.full_name,
            position: @account.position
          }
        }
        result = SchemaRegistry.validate_event(event, 'accounts.updated', version: 1)

        if result.success?
          WaterDrop::SyncProducer.call(event.to_json, topic: 'accounts-stream')
        else

        end
        # --------------------------------------------------------------------

        produce_be_event(@account.public_id, new_role) if new_role

        # --------------------------------------------------------------------

        format.html { redirect_to root_path, notice: 'Account was successfully updated.' }
        format.json { render :index, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  #
  # in DELETE action, CUD event
  def destroy
    @account.update(active: false, disabled_at: Time.now)

    # ----------------------------- produce event -----------------------
    event = {
      **account_event_data,
      event_name: 'AccountDeleted',
      data: { public_id: @account.public_id }
    }
    result = SchemaRegistry.validate_event(event, 'accounts.deleted', version: 1)

    if result.success?
      WaterDrop::SyncProducer.call(event.to_json, topic: 'accounts-stream')
    end
    # --------------------------------------------------------------------

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def account_event_data
      {
        event_id: SecureRandom.uuid,
        event_version: 1,
        event_time: Time.now.to_s,
        producer: 'auth_service',
      }
    end

    def current_account
      if doorkeeper_token
        Account.find(doorkeeper_token.resource_owner_id)
      else
        super
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def account_params
      params.require(:account).permit(:full_name, :role)
    end

    def produce_be_event(public_id, role)
      event = {
        **account_event_data,
        event_name: 'AccountRoleChanged',
        data: { public_id: public_id, role: role }
      }
      result = SchemaRegistry.validate_event(event, 'accounts.role_changed', version: 1)

      if result.success?
        WaterDrop::SyncProducer.call(event.to_json, topic: 'accounts')
      end
    end
end
