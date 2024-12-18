class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update]
  skip_before_action :authenticate_user!, only: :index

  # GET /events
  def index
    if params[:query].present?
      @events = policy_scope(Event).global_search(params[:query])
    else
      @events = policy_scope(Event)
    end
  end

  # GET /events/:id
  def show
    @tickets = @event.tickets.where(status: "for_sale")
    authorize @event
  end

  def new
    @event = Event.new
    authorize @event
  end

  def create
    @event = Event.new(event_params)
    authorize @event
    if @event.save
      redirect_to event_tickets_path(@event)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @event
  end

  def update
    authorize @event
    if @event.update(event_params)
      redirect_to event_tickets_path(@event)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # Find event for actions that need it
  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :date, :location, :capacity)
  end
end
