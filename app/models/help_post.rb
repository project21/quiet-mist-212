class HelpPost < ActiveRecord::Base
  has_one :post, :polymorphic => true
end
