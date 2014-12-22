require 'spec_helper'

describe BadgeController do
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

  context "downloading badges" do
    it 'returns image data from assets' do
      badge = File.read('app/assets/images/badges/black/170px.png', encoding: 'binary')
      get :badge, colour: 'black', size: '170px', level: 'supporter'
      expect(response.body == badge).to eq(true), "images don't match"
    end

    it 'returns the orange mini image data' do
      badge = File.read('app/assets/images/badges/orange/16px.png', encoding: 'binary')
      get :badge, colour: 'orange', size: '16px', level: 'supporter'
      expect(response.body == badge).to eq(true), "images don't match"
    end

    it 'has a content disposition of attachment' do
      get :badge, colour: 'black', size: '170px', level: 'supporter'
      expect(response.headers['Content-Disposition']).to start_with('attachment')
    end

    it 'has a type of image/png' do
      get :badge, colour: 'black', size: '170px', level: 'supporter'
      expect(response.headers['Content-Type']).to eq('image/png')
    end

    it 'has a file name' do
      get :badge, colour: 'black', size: '170px', level: 'supporter'
      filename = response.headers['Content-Disposition'].match(/filename="(.*?)"/)[1]
      expect(filename).to eq('odi-supporter-170px.png')
    end
  end
end
