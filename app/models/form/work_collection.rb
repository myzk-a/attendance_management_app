class Form::WorkCollection < Form::Base
  FORM_COUNT = 3 #ここで、作成したい登録フォームの数を指定
  attr_accessor :works

  def initialize(attributes = {})
    super attributes
    self.works = FORM_COUNT.times.map { Work.new() } unless self.works.present?
  end

  def works_attributes=(attributes)
    self.works = attributes.map { |_, v| Work.new(v) }
  end

  def save
    saved = true
    Work.transaction do
      self.works.each do |work|
        if work.signup
          unless work.save
            saved = false
          end
        end
      end
    end
    return saved
  end
end