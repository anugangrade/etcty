class BranchConnect < ActiveRecord::Base
  belongs_to :branch, touch: true
  belongs_to :connectable, polymorphic: true, touch: true

  scope :if_checked, -> { where(checked: true) }
end
