# frozen_string_literal: true

class Web::BulletinsController < ApplicationController
  def index
    @bulletins = Bulletin.all
  end
end
