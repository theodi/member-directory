require 'active_support/concern'


module MemberConstants
  extend ActiveSupport::Concern

  included do
    
    SUPPORTER_LEVELS = %w[
      supporter
      member
      partner
      sponsor
      individual
      student
    ]

    CURRENT_SUPPORTER_LEVELS = %w[
      supporter
    ]

    ORGANISATION_TYPES = {
      "Corporate" => "commercial",
      "Nonprofit / Government" => "non_commercial"
    }

    ORGANISATION_SIZES = {
      "less than 10 employees" => '<10',
      "10 - 50 employees" => '10-50',
      "51 - 250 employees" => '51-250',
      "251 - 1000 employees" => '251-1000',
      "more than 1000 employees" => '>1000'
    }

    SECTORS = [
      "Business & Legal Services",
      "Data/Technology",
      "Education",
      "Energy",
      "Environment & Weather",
      "Finance & Investment",
      "Food & Agriculture",
      "Geospatial/Mapping",
      "Governance",
      "Healthcare",
      "Housing/Real Estate",
      "Insurance",
      "Lifestyle & Consumer",
      "Media",
      "Research & Consulting",
      "Scientific Research",
      "Transportation",
      "Other"
    ]

    ORIGINS = {
      "Aberdeen" => "odi-aberdeen",
      "Athens" => "odi-athens",
      "Belfast" => "odi-belfast",
      "Birmingham" => "odi-birmingham",
      "Brasilia" => "odi-brasilia",
      "Bristol" => "odi-bristol",
      "Cairo" => "odi-cairo",
      "Cardiff" => "odi-cardiff",
      "Cornwall" => "odi-cornwall",
      "Devon" => "odi-devon",
      "Dubai" => "odi-dubai",
      "Galway" => "odi-galway",
      "Gothenburg" => "odi-gothenburg",
      "Hampshire" => "odi-hampshire",
      "Leeds" => "odi-leeds",
      "Madrid" => "odi-madrid",
      "Osaka" => "odi-osaka",
      "Paris" => "odi-paris",
      "Queensland" => "odi-queensland",
      "Rio" => "odi-rio",
      "Rome" => "odi-rome",
      "Riyadh" => "odi-riyadh",
      "Seoul" => "odi-seoul",
      "St Petersburg" => "odi-st-petersburg",
      "Toronto" => "odi-toronto",
      "Trento" => "odi-trento",
      "Vienna" => "odi-vienna"
    }

    LARGE_CORPORATE = %w[251-1000 >1000]

    SUBSCRIPTION_OPTIONS = {
      choices: [1,2,5,10,20,30,40,50,60,70,80,90,100],
      default: 30
    }

  end
    
end
