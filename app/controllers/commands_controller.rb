class CommandsController < ApplicationController
  before_action :set_command, only: [:show, :destroy]

  # GET /commands
  # GET /commands.json
  def index
    @command  = Command.new
    @commands = Command.order('accessed_at DESC').page(params[:page])
  end

  # GET /commands/1
  # GET /commands/1.json
  def show
  end

  # POST /commands
  # POST /commands.json
  def create
    @command = Command.new(command_params)

    respond_to do |format|
      if @command.save
        format.html { redirect_to @command, notice: 'Command was successfully created.' }
        format.json { render json: { url: @command.gotty_url } }
      else
        format.html { redirect_to commands_url }
        format.json { render json: @command.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /commands/1
  # DELETE /commands/1.json
  def destroy
    @command.destroy
    respond_to do |format|
      format.html { redirect_to commands_url, notice: 'Command was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_command
      @command = Command.find_by(uuid: params[:uuid])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def command_params
      params.require(:command).permit(:text)
    end
end
