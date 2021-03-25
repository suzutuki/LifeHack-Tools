window.draw_graph = ->
  if document.getElementById("sportsChart") == null
    return
  ctx = document.getElementById("sportsChart").getContext('2d')
  #  横軸の数を決めているよ
  barNum = 7
  labels = new Array(barNum)
  bgColors = new Array(barNum)
  bdColors = new Array(barNum)
  for i in [0...barNum]
    labels[i] = 'data' + i
    bgColors[i] = 'rgba(75, 192, 192, 0.2)'
    bdColors[i] = 'rgba(75, 192, 192, 1)'
  sportsChart = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: @graphdays,#ここは日付が表示される　X軸に当たる
      datasets: [{
        label: '運動時間(分)',
        data: @graphtimes,#ここは時間が表示される　Y軸に当たる
        backgroundColor: [
          'rgba(255, 99, 132, 0.2)',
          'rgba(54, 162, 235, 0.2)',
          'rgba(255, 206, 86, 0.2)',
          'rgba(75, 192, 192, 0.2)',
          'rgba(153, 102, 255, 0.2)',
          'rgba(255, 159, 64, 0.2)',
          'rgba(255, 99, 132, 0.2)',
          'rgba(54, 162, 235, 0.2)',
          'rgba(255, 206, 86, 0.2)',
          'rgba(75, 192, 192, 0.2)',
          'rgba(153, 102, 255, 0.2)',
          'rgba(255, 159, 64, 0.2)'
        ],
        borderColor: [
          'rgba(255, 99, 132, 1)',
          'rgba(54, 162, 235, 1)',
          'rgba(255, 206, 86, 1)',
          'rgba(75, 192, 192, 1)',
          'rgba(153, 102, 255, 1)',
          'rgba(255, 159, 64, 1)',
          'rgba(255, 99, 132, 1)',
          'rgba(54, 162, 235, 1)',
          'rgba(255, 206, 86, 1)',
          'rgba(75, 192, 192, 1)',
          'rgba(153, 102, 255, 1)',
          'rgba(255, 159, 64, 1)'
        ],
        borderWidth: 1
      }]
    },
    options: {
      scales: {
        yAxes: [{
          ticks: {
            beginAtZero:true
          }
        }]
      }
      maintainAspectRatio: false
    }
  })