class MailingsController < ApplicationController
  before_action :set_mailing, only: [:show, :edit, :update, :destroy]

  # GET /mailings
  # GET /mailings.json
  def index
    #@mailings = Mailing.where.not(creator: current_user.uid)
    @mailings = Mailing.where.not(creator: current_user.uid).order(nom: :asc)
  end

  # GET /mailings/1
  # GET /mailings/1.json
  def show
  end

  # GET /mailings/new
  def new
    @mailing = Mailing.new
    @types = Type.all
  end

  # GET /mailings/1/edit
  def edit
    @types = Type.all
  end

  def manage
    @my_mailings = Mailing.where(creator: current_user.uid)
    no_creator = Mailing.where.not(creator: current_user.uid).order(nom: :asc)
    @subscribed_mailings = Inscription.where(uid: current_user.uid).where(mailing: no_creator)
  end

  def manage_inscriptions
    @mailing = Mailing.find(params[:id])
    @inscriptions_invalide = Inscription.where(mailing_id: params[:id]).where(valide: false)
    @inscriptions_valide = Inscription.where(mailing_id: params[:id]).where(valide: true)
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

  def ajouter 
    ldap = Net::LDAP.new
    ldap.host = LDAP_CONFIG["host"]
    ldap.port = LDAP_CONFIG["port"]
    ldap.auth LDAP_CONFIG["auth_dn"], LDAP_CONFIG["auth_pass"]
    filter = Net::LDAP::Filter.eq( "objectClass", LDAP_CONFIG["user_object_class"])
    treebase = LDAP_CONFIG["search_base"]
    @users = ldap.search( :base => treebase, :filter => filter, :scope => Net::LDAP::SearchScope_WholeSubtree)

    @mailing = Mailing.find(params[:id]);
  end

  def ajouter_utilisateur
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

    if EmailValidator.valid?(mailing_params[:mail].downcase)
      if ! mailing_params[:mail].end_with? "@ares-ensiie.eu"
        @wrong_mail = true;
      end
    else
       @wrong_mail = true;
    end

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
    respond_to do |format|
      if @mailing.update(mailing_params)
        format.html { redirect_to @mailing, notice: 'Mailing was successfully updated.' }
        format.json { render :show, status: :ok, location: @mailing }
      else
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def mailing_params
      params.require(:mailing).permit(:nom, :mail, :type_mailing)
    end
end
