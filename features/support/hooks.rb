Before("@timecop") do
  Timecop.freeze
end

After("@timecop") do
  Timecop.return
end