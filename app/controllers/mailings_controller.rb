class MailingsController < ApplicationController
  before_action :set_mailing, only: [:show, :edit, :update, :destroy, :manage_inscriptions, :manage_inscrits]
  before_action :check_rights, only: [:edit, :manage_inscrits, :manage_inscriptions, :accepter_inscription, :refuser_inscription, :ajouter, :set_admin, :destroy]

  # GET /mailings
  # GET /mailings.json
  def index
    #@mailings = Mailing.where.not(creator: current_user.uid)
    mailings = Mailing.where.not(creator: current_user.uid).order(nom: :asc)
    @mailings = []

    mailings.each do |mailing|
      if ! mailing.contains_user_valide(current_user.uid)
          @mailings.push(mailing)
      end
    end
  end

  # GET /mailings/1
  # GET /mailings/1.json
  def show
    @inscriptions_valide = Inscription.where(mailing_id: params[:id]).where(valide: true).paginate(:page => params[:page], :per_page => 15);
  end

  def show_custom
    @mailing = CustomMailing.find(params[:id])
    @users = @mailing.users().paginate(:page => params[:page], :per_page => 15);
  end

  def custom_mailings
    @mailings = CustomMailing.all;
  end

  # GET /mailings/new
  def new
    @mailing = Mailing.new
    @types = Type.all
  end

  # GET /mailings/1/edit
  def edit
    @types = Type.all
    @type = Mailing.find(params[:id]).type_mailing
    mail = Mailing.find(params[:id]).mail
    @mail = mail[0, mail.length - 15]
  end

  def manage
    @my_mailings = Mailing.where(creator: current_user.uid)
    no_creator = Mailing.where.not(creator: current_user.uid).order(nom: :asc)
    @subscribed_mailings = Inscription.where(uid: current_user.uid).where(mailing: no_creator)
  end

  def manage_inscriptions
    @inscriptions_invalide = Inscription.where(mailing_id: params[:id]).where(valide: false).paginate(:page => params[:page], :per_page => 15);
  end

  def manage_inscrits
    @inscriptions_valide = Inscription.where(mailing_id: params[:id]).where(valide: true).paginate(:page => params[:page], :per_page => 15);
  end

  def accepter_inscription
    @inscription = Inscription.where(mailing_id: params[:id]).where(uid: params[:uid]).where(valide: false).first

    if @inscription == nil
      @inscription = Inscription.new
      @inscription.mailing_id = params[:id];
      @inscription.uid = params[:uid];
      @inscription.valide = true;
      @inscription.save
      redirect_to ajouter_path(params[:id])
    else
      @inscription.valide = true
      @inscription.save
      redirect_to manage_inscriptions_path(params[:id])
    end
    
  end

  def refuser_inscription
    @inscription = Inscription.where(mailing_id: params[:id]).where(uid: params[:uid]).first
    @inscription.delete
    redirect_to manage_inscriptions_path(params[:id])
  end

  def demande_inscription
    @inscription = Inscription.new
    @inscription.mailing_id = params[:id];
    @inscription.uid = current_user.uid;
    @inscription.valide = false;
    @inscription.save
    redirect_to mailings_path
  end

  def quitter
    mailing = Mailing.find(params[:id])
    if mailing.creator == current_user.uid
      flash[:error] = "Impossible de quitter une mailing liste qui vous appartient"
    else
      inscription = Inscription.where(mailing_id: params[:id]).where(uid: current_user.uid).first
      if inscription != nil
        inscription.delete
      end
    end
    redirect_to mailings_manage_path
  end

  def ajouter
    @mailing = Mailing.find(params[:id]);
    @users = User.search(params[:search]).paginate(:page => params[:page], :per_page => 15);
  end

  def ajouter_utilisateur
  end

  def set_admin
    mailing = Mailing.find(params[:id])
    mailing.creator = params[:uid]
    mailing.save

    redirect_to mailings_manage_path
  end

  # POST /mailings
  # POST /mailings.json
  def create
    @mailing = Mailing.new(mailing_params)
    @mailing.creator = current_user.uid;
    @mailing.nom = mailing_params[:nom].downcase
    @mailing.mail = mailing_params[:mail].downcase
    @mailing.type_mailing = mailing_params[:type_mailing].titleize
    @types = Type.all

    mail = mailing_params[:mail].downcase + "@ares-ensiie.eu"
    if EmailValidator.valid?(mail)
      if ! mail.end_with? "@ares-ensiie.eu"
        @wrong_mail = true;
      end
    else
       @wrong_mail = true;
    end
    @mailing.mail = mail

    respond_to do |format|
      if !@wrong_mail && @mailing.save
        Type.find_or_create_by(name: mailing_params[:type_mailing].titleize)
        format.html { redirect_to @mailing, notice: 'Mailing was successfully created.' }
        format.json { render :show, status: :created, location: @mailing }

        @inscription = Inscription.new
        @inscription.mailing_id = @mailing.id
        @inscription.uid = current_user.uid;
        @inscription.valide = true;
        @inscription.save
      else
        format.html { render :new }
        format.json { render json: @mailing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mailings/1
  # PATCH/PUT /mailings/1.json
  def update
    mail = mailing_params[:mail].downcase + "@ares-ensiie.eu"
    if EmailValidator.valid?(mail)
      if ! mail.end_with? "@ares-ensiie.eu"
        @wrong_mail = true;
      end
    else
      @wrong_mail = true;
    end
    @mailing.mail = mail

    respond_to do |format|
      if !@wrong_mail && @mailing.update(mailing_params)
        format.html { redirect_to @mailing, notice: 'Mailing was successfully updated.' }
        format.json { render :show, status: :ok, location: @mailing }
      else
        @types = Type.all
        format.html { render :edit }
        format.json { render json: @mailing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mailings/1
  # DELETE /mailings/1.json
  def destroy
    @mailing.destroy
    respond_to do |format|
      format.html { redirect_to mailings_url, notice: 'Mailing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mailing
      @mailing = Mailing.find(params[:id])
    end

    def check_rights
      mailing = Mailing.find(params[:id])
      if mailing.creator != current_user.uid
        flash[:error] = "Impossible de gérer une mailing liste qui ne vous appartient pas"
        redirect_to mailings_manage_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mailing_params
      params.require(:mailing).permit(:nom, :mail, :type_mailing)
    end
end
