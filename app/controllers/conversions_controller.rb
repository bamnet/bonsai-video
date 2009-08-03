class ConversionsController < ApplicationController
  # GET /conversions
  # GET /conversions.xml
  def index
    @conversions = Conversion.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @conversions }
    end
  end

  # GET /conversions/1
  # GET /conversions/1.xml
  def show
    @conversion = Conversion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @conversion }
    end
  end

  # GET /conversions/1/edit
  def edit
    @conversion = Conversion.find(params[:id])
  end
  
  def resubmit
    @conversion = Conversion.find(params[:id])
    VideoWorker.asynch_convert(:conversion_id => @conversion.id)
    redirect_to(@conversion)
  end

  # POST /conversions
  # POST /conversions.xml
  def create
    @conversion = Conversion.new(params[:conversion])
    @conversion.status = "submitted" if @conversion.status.blank?

    respond_to do |format|
      if @conversion.save
        VideoWorker.asynch_convert(:conversion_id => @conversion.id)
        flash[:notice] = 'Conversion was successfully created.'
        format.html { redirect_to(@conversion) }
        format.xml  { render :xml => @conversion, :status => :created, :location => @conversion }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @conversion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /conversions/1
  # PUT /conversions/1.xml
  def update
    @conversion = Conversion.find(params[:id])

    respond_to do |format|
      if @conversion.update_attributes(params[:conversion])
        flash[:notice] = 'Conversion was successfully updated.'
        format.html { redirect_to(@conversion) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @conversion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /conversions/1
  # DELETE /conversions/1.xml
  def destroy
    @conversion = Conversion.find(params[:id])
    @conversion.destroy

    respond_to do |format|
      format.html { redirect_to(conversions_url) }
      format.xml  { head :ok }
    end
  end
end
