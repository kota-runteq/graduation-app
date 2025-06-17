# 正規化しているので、栄養素の種類をデータとして初期投入
%w[protein fat carbs calories].each do |k|
  Nutrient.find_or_create_by!(key: k) do |n|
    n.name = k.capitalize
    n.unit = k == 'calories' ? 'kcal' : 'g'
  end
end
