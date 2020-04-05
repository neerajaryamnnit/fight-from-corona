namespace :daily_case do
  desc "TODO"
  task update_daily_cases: :environment do
    response = HTTParty.get('https://api.covid19india.org/data.json')
    if response.code != 200
      return
    end
    data = JSON.parse(response.body)
    unless data['statewise'].present?
      return
    end
    total = nil
    data['statewise'].each do |state|
      if state['statecode'] == "TT"
        total = state
        break
      end
    end

    unless total.present?
      return
    end
    daily = DailyCase.last

    daily.total = total['confirmed']
    daily.active = total['active']
    daily.decease = total['deaths']
    daily.recover = total['recovered']
    daily.save
  end

end
