#chart.jsの設定
window.draw_graph = ->
  ctx = document.getElementById("myChart").getContext('2d')
  barNum = 6
  labels = new Array(barNum)
  bgColors = new Array(barNum)
  bdColors = new Array(barNum)
  for i in [0...barNum]
    bgColors[i] = 'rgba(75, 192, 192, 0.2)'
    bdColors[i] = 'rgba(75, 192, 192, 1)'
  myChart = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: gon.monthly
      datasets: [{
        label: 'イベントの数',
        data: gon.data,
        backgroundColor: bgColors,
        borderColor: bdColors,
        borderWidth: 1
      }, {
        label: '行ったイベントの総数',
        data: gon.linedata,
        type: 'line'
      }]
    },
    options: {
      scales: {
        yAxes: [{
          ticks: {
            beginAtZero: true
          }
        }]
      }
    }
  })
#window.draw_graph = ->
#  ctx = document.getElementById("myChart").getContext('2d')
#  sportsChart = new Chart(ctx, {
#    type: 'bar',
#    data: {
#      labels: graphsdays,#ここは日付が表示される　X軸に当たる
#      datasets: [{
#        label: '運動時間',
#        data: graphtimes,#ここは時間が表示される　Y軸に当たる
#        backgroundColor: [
#          'rgba(255, 159, 64, 0.2)',
#          'rgba(255, 159, 64, 0.2)',
#          'rgba(255, 159, 64, 0.2)',
#          'rgba(255, 159, 64, 0.2)',
#          'rgba(255, 159, 64, 0.2)',
#          'rgba(255, 159, 64, 0.2)'
#        ],
#        borderColor: [
#          'rgba(255, 159, 64, 1)',
#          'rgba(255, 159, 64, 1)',
#          'rgba(255, 159, 64, 1)',
#          'rgba(255, 159, 64, 1)',
#          'rgba(255, 159, 64, 1)',
#          'rgba(255, 159, 64, 1)'
#        ],
#        borderWidth: 1
#      }]
#    },
#    options: {
#      scales: {
#        yAxes: [{
#          ticks: {
#            beginAtZero:true
#          }
#        }]
#      }
#    }
#  })
