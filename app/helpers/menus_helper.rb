module MenusHelper
  NUTRIENT_LABELS = {
    'protein'  => 'たんぱく質',
    'fat'      => '脂質',
    'carbs'    => '炭水化物',
    'calories' => 'カロリー'
  }.freeze

  def sort_description
    key = params[:sort_target]
    return unless key.present? && NUTRIENT_LABELS.key?(key)

    name = NUTRIENT_LABELS[key]
    dir  = params[:sort_order] == 'desc' ? '多い順' : '少ない順'
    "#{name}を#{dir}に表示"
  end
end