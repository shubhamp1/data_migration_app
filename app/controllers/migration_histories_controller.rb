class MigrationHistoriesController < ApplicationController
  before_action :find_record, only: %i[show]
  def index
    @histories = MigrationHistory.all
  end

  def show; end

  private

  def find_record
    @history = MigrationHistory.find(params[:id])
  end
end
