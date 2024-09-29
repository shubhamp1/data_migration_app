# frozen_string_literal: true

# MigrationHistoriesController handles the management of migration histroy.
class MigrationHistoriesController < ApplicationController
  before_action :find_record, only: %i[show]

  # GET /migration_histories
  def index
    @histories = MigrationHistory.all.reverse
  end

  # GET /migration_histories/1
  def show; end

  private

  def find_record
    @history = MigrationHistory.find(params[:id])
  end
end
