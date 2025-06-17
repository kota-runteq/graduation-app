# ransackが1を真偽値として扱うので、1で検索できないのを防ぐ
Ransack.configure do |c|
  c.sanitize_custom_scope_booleans = false
end
