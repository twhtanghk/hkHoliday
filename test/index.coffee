{format, holidays, isHoliday} = require '../index'

do ->
  console.log await holidays()
  console.log await isHoliday new Date [2018, 1, 3]
