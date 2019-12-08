_ = require 'lodash'
{get} = require 'needle'
es = require 'event-stream'
Promise = require 'bluebird'

module.exports =
  format: (str) ->
    new Date str.match(/([0-9]{4})([0-9]{2})([0-9]{2})/)[1..3]
  holidays: ->
    new Promise (resolve, reject) ->
      get process.env.URL || 'https://www.1823.gov.hk/common/ical/en.json'
        .pipe es.mapSync (data) ->
          resolve _.map data.vcalendar[0].vevent, (el) ->
            dtend = module.exports.format el.dtend[0]
            dtend.setHours 23
            dtend.setMinutes 59
            dtend.setSeconds 59
            dtend.setMilliseconds 999
            [
              module.exports.format el.dtstart[0]
              dtend
            ]
        .on 'error', reject
  isHoliday: (date) ->
    for range in await module.exports.holidays()
      if date >= range[0] and date <= range[1]
        return true
    return false
