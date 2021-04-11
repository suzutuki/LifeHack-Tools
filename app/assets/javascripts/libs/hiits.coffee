window.draw_graph = ->
  if document.getElementById("My_Chart") == null
    return
#getContextメソッドで描画機能を有効にします。getContextメソッドに指定できる引数は'2d'のみです。
  ctx = document.getElementById("My_Chart").getContext('2d')

  exercise_Chart = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: graphdays,   #ここは日付が表示される　X軸に当たる
      datasets: [{
        label: '運動時間(分)',
        data: graphminutes,#ここは時間(分)が表示される　Y軸に当たる
        backgroundColor: [
          'rgba(255, 99, 132, 0.2)',
          'rgba(54, 162, 235, 0.2)',
          'rgba(255, 206, 86, 0.2)',
          'rgba(75, 192, 192, 0.2)',
          'rgba(153, 102, 255, 0.2)',
          'rgba(255, 159, 64, 0.2)',
          'rgba(254, 99, 132, 0.2)',
          'rgba(53, 162, 235, 0.2)',
          'rgba(254, 206, 86, 0.2)',
          'rgba(74, 192, 192, 0.2)',
          'rgba(152, 102, 255, 0.2)',
          'rgba(253, 159, 64, 0.2)',
          'rgba(254, 99, 132, 0.2)',
          'rgba(55, 162, 235, 0.2)',
          'rgba(253, 206, 86, 0.2)',
          'rgba(74, 192, 192, 0.2)',
          'rgba(152, 102, 255, 0.2)',
          'rgba(254, 159, 64, 0.2)',
          'rgba(254, 99, 132, 0.2)',
        ],
        borderColor: [
          'rgba(255, 99, 132, 1)',
          'rgba(54, 162, 235, 1)',
          'rgba(255, 206, 86, 1)',
          'rgba(75, 192, 192, 1)',
          'rgba(153, 102, 255, 1)',
          'rgba(255, 159, 64, 1)',
          'rgba(254, 99, 132, 1)',
          'rgba(53, 162, 235, 1)',
          'rgba(254, 206, 86, 1)',
          'rgba(73, 192, 192, 1)',
          'rgba(152, 102, 255, 1)',
          'rgba(253, 159, 64, 1)',
          'rgba(254, 99, 132, 1)',
          'rgba(53, 162, 235, 1)',
          'rgba(254, 206, 86, 1)',
          'rgba(74, 192, 192, 1)',
          'rgba(152, 102, 255, 1)',
          'rgba(254, 159, 64, 1)',
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