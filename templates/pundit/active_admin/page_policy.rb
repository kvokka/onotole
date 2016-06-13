# frozen_string_literal: true
module ActiveAdmin
  class PagePolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
    end

    def show?
      case record.name
      when 'Dashboard'
        true
      else
        false
      end
    end
  end
end
