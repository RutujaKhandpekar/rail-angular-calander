class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  def doctor_locations
    docloc_json = [
      {
        id: '1',
        firstname: 'Poorva',
        lastname: 'Mahajan',
        locations: [
          { id: 3, name: 'Akurdi' },
          { id: 4, name: 'Kalyani Nagar' }
        ]
      },
      {
        id: '2',
        firstname: 'Rutuja',
        lastname: 'Khanpekar',
        locations: [
          { id: 5, name: 'Swargate' },
          { id: 6, name: 'Dahanukar' }
        ]
      }
    ]
    render json: docloc_json
  end

  def events
    if params[:location].eql?('3') || params[:location].eql?('6')
      events_json = {
        calendar: {
          slot_duration: '01:00:00'
        },
        events: [
          {
            id: 1,
            start: '2015-07-18T15:00',
            end: '2015-07-18T18:00',
            event_type: 'blocked',
            blocked_for: 'OPD',
            subject: 'foo'
          },
          {
            id: 2,
            start:  '2015-07-19T11:00',
            end: '2015-07-19T13:00',
            event_type: 'booking',
            firstname: 'Poorva',
            lastname: 'Mahajan',
            subject: 'boo'
          },
          {
            id: 3,
            start:  '2015-07-17T09:00',
            end: '2015-07-17T11:00',
            event_type: 'booking',
            firstname: 'Test',
            lastname: 'User',
            subject: 'boo'
          },
          {
            id: 4,
            start: '2015-07-20T19:00',
            end: '2015-07-20T21:00',
            event_type: 'non-working'
          }
        ]
      }
    else
      events_json = {
        calendar: {
          slot_duration: '00:01:00'
        },
        events: [
          {
            id: 1,
            start:  '2015-07-18T19:00',
            end: '2015-07-18T22:00',
            event_type: 'blocked',
            blocked_for: 'OPD',
            subject: 'foo'
          },
          {
            id: 2,
            start:  '2015-07-19T13:00',
            end: '2015-07-19T15:00',
            event_type: 'booking',
            firstname: 'Rutuja',
            lastname: 'Khanpekar',
            subject: 'boo'
          },
          {
            id: 3,
            start:  '2015-07-17T09:00',
            end: '2015-07-17T11:00',
            event_type: 'booking',
            firstname: 'Test',
            lastname: 'User',
            subject: 'boo'
          },
          {
            id: 4,
            start: '2015-07-18T08:00',
            end: '2015-07-18T10:00',
            event_type: 'non-working'
          }
        ]
      }
    end
    render json: events_json
  end

  def book_appointment
    doc_response = {
      IsSuccess: true,
      Msg: 'add success',
      Data: '0',
      event_id: [*5..100].sample
    }
    render json: doc_response
  end

  def get_event_data
    event = params[:event]
    if event[:event_type].eql?('booking')
      events_json = {
        id: event[:id],
        doctor_id: 1,
        location_id: 1,
        firstname: event[:firstname],
        lastname: event[:lastname],
        mobile_number: '9878866543',
        email: 'foo@boo.com',
        # start: 'yymmdd hh:mm:ss',
        # end: 'yymmdd hh:mm:ss',
        subject: event[:subject],
        prepay_amount: 1234,
        prepay_date: '2015-07-19',
        prepay_time: '11:00:00',
        event_type: 'booking'
      }
    else
      events_json = {
        id: event[:id],
        doctor_id: 1,
        location_id: 1,
        # start: 'yymmdd hh:mm:ss',
        # end: 'yymmdd hh:mm:ss',
        subject: event[:subject],
        appointment_type: 1,
        event_type: 'blocked'
      }
    end
    render json: events_json
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :blurb, :body)
    end
end
