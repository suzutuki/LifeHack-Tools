window.draw_graph = ->
  if document.getElementById("sportsChart") == null
    return
  ctx = document.getElementById("sportsChart").getContext('2d')
  sportsChart = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: graphdays,#ここは日付が表示される　X軸に当たる
      datasets: [{
        label: '運動時間',
        data: graphtimes,#ここは時間が表示される　Y軸に当たる
        backgroundColor: [
          'rgba(255, 159, 64, 0.2)',
          'rgba(255, 159, 64, 0.2)',
          'rgba(255, 159, 64, 0.2)',
          'rgba(255, 159, 64, 0.2)',
          'rgba(255, 159, 64, 0.2)',
          'rgba(255, 159, 64, 0.2)'
        ],
        borderColor: [
          'rgba(255, 159, 64, 1)',
          'rgba(255, 159, 64, 1)',
          'rgba(255, 159, 64, 1)',
          'rgba(255, 159, 64, 1)',
          'rgba(255, 159, 64, 1)',
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
    }
  })