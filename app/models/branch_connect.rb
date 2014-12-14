class BranchConnect < ActiveRecord::Base
  belongs_to :branch
  belongs_to :connectable, polymorphic: true

  scope :if_checked, -> { where(checked: true) }
end
