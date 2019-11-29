class CandidatosController < ApplicationController
  before_action :set_candidato, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /candidatos
  def index
    @candidatos = Candidatos.all
    # if current_user
    #   @candidato = Candidato.where(cpf: @current_user.cpf).count
    # end
    render "candidatos/menu/mainMenu"
  end

  # GET /candidatos/edit
  def show
    if current_user.tipoUser == 'candidato'
      @candidato = Candidato.where(cpf: @current_user.cpf)
    elsif current_user.tipoUser == 'admin'
      @candidato = if params[:name_term]
        Candidato.where('nome ILIKE ?', "%#{params[:name_term]}%").or(Candidato.where('cidade ILIKE ?', "%#{params[:city_term]}%"))
      else
        @Candidato = Candidato.all
      end
    end
  end

  # GET /candidatos/new
  def new
    @candidato = Candidato.new
  end

  # GET /candidatos/1/edit
  def edit
    if current_user
      findQuery = Candidato.where(cpf: @current_user.cpf)
      id = findQuery.ids
      @candidato = Candidato.find_by_id(id)
    end
    link_forward
  end

  # POST /candidatos
  # POST /candidatos.json
  def create
    if current_user
      if @candidato = Candidato.where(cpf: @current_user.cpf).count == 0
        @candidato = Candidato.new(candidato_params)

        respond_to do |format|
          if @candidato.save
            format.html { redirect_to "/formations/new"}
          else
            format.html { render :new }
          end
        end
      else
        render "candidatos/menu/mainMenu"
      end
    end
  end

  # PATCH/PUT /candidatos/1
  # PATCH/PUT /candidatos/1.json
  def update

    @candidato = Candidato.find(params[:id])

    respond_to do |format|
      if @candidato.update(candidato_params)
        format.html { redirect_to @candidato, notice: 'Candidato was successfully updated.' }
        format.json { render :show, status: :ok, location: @candidato }
      else
        format.html { render :edit }
        format.json { render json: @candidato.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /candidatos/1
  # DELETE /candidatos/1.json
  def destroy
    @candidato = Candidato.find(params[:id])
    @candidato.destroy
    respond_to do |format|
      format.html { redirect_to candidatos_url, notice: 'Candidato was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def link_forward
    forward_id = Formation.where(cpf_candidato: current_user.cpf)
    @id_forward_formations = forward_id.ids
    @id_forward_formations = @id_forward_formations[0]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_candidato
      @candidato = Candidato.where(cpf: current_user.cpf)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def candidato_params
      params.require(:candidato).permit(:cpf, :nome, :data_nasc, :cep, :logradouro, :numero, :bairro, :cidade, :uf, :user_id, :term)
    end
end
