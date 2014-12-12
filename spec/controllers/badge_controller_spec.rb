require 'spec_helper'

describe ApplicationController do
  context "svgs for badge embedding" do
    it 'gives standard black partner badge' do
      get :logo, colour: 'black', size: 'medium', level: 'partner', format: 'svg'
      expect(assigns(:colour)).to eq('black')
      expect(response).to render_template('logos/partner-standard')
    end

    it 'gives a mini orange supporter badge' do
      get :logo, colour: 'orange', size: 'mini', level: 'supporter', format: 'svg'
      expect(assigns(:colour)).to eq('orange')
      expect(response).to render_template('logos/supporter-mini')
    end
  end
end
