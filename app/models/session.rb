class Session < ApplicationRecord
  belongs_to :chat
  has_many :messages, dependent: :destroy
end
