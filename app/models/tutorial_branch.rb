class TutorialBranch < ActiveRecord::Base
	belongs_to :tutorial
	belongs_to :branch
end
