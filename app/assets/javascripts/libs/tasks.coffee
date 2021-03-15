#stepsの一時的な退避
#window.draw_graph = ->
#  ctx = document.getElementById("myChart").getContext('2d')
#  #  横軸の数を決めているよ
#  barNum = 10
#  labels = new Array(barNum)
#  bgColors = new Array(barNum)
#  bdColors = new Array(barNum)
#  for i in [0...barNum]
#    labels[i] = 'data' + i
#    bgColors[i] = 'rgba(75, 192, 192, 0.2)'
#    bdColors[i] = 'rgba(75, 192, 192, 1)'
#  myChart = new Chart(ctx, {
#    type: 'line',
#    data: {
#      labels: labels
#      datasets: [{
#        label: '目標達成率',
#        data: gon.data,
#        backgroundColor: bgColors,
#        borderColor: bdColors,
#        borderWidth: 1
#      }]
#    },
#    options: {
#      scales: {
#        yAxes: [{
#          ticks: {
#            beginAtZero: true
#          }
#        }]
#      }
#    }
#  })