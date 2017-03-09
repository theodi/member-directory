Before("@timecop") do
  Timecop.freeze(Time.local(2015, 1, 1, 1, 0, 0))
end

After("@timecop") do
  Timecop.return
end