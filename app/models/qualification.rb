class Qualification
  def self.names
    [
      "BSc - Bachelor of Science",
      "BA - Bachelor of Arts",
      "MA - Master of arts",
      "MSc - Master of science",
      "BA Econ - Bachelor of Economics",
      "BEng - Bachelor of Engineering",
      "M.Eng - Masters of Engineering",
      "MBA - Masters of Business Administration",
      "M.Ed - Master of Education",
      "BM BS - Bachelor of Medicine and Bachelor of Surgery",
      "Ph.D (or PhD) - Doctor of Philosophy",
      "Diploma"
    ]
  end
  
  def self.select_name(str)
    if Qualification.names.include?(str)
      str
    else
      nil
    end
  end
  
  def self.select_name_other(str)
    if Qualification.names.include?(str)
      nil
    else
      str
    end
  end

end

