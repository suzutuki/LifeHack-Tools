// ボタンが押されたら優先順位,1位以外を非表示にする。not-priority-1がターゲット
$(function () {
    $("trigger_priority").click(function () {
        $(".itemnot-priority-1").toggle("slow");
    });
});
// ボタンが押されたら更新・作成日時を非表示にする。tasks-targetがターゲット
$(function () {
    $("trigger_time item").click(function () {
        $(".tasks-time").toggle("slow");
    });
});
// フラッシュメッセージのアニメーション
$(function () {
    setTimeout("$('.time-limit').fadeOut('slow')", 6000)
});

$(function () {
    $("trigger_time").click(function () {
        $(".tasks-time").toggle("slow");
    });
});
// ToDoリストでチェックボタンを動的(チェックされた、またはされてない状態を保存)にする
$(function () {
    $('input:checkbox[name="task"]').click(function () {
        $.post('/tasks/' + $(this).data('id') + '/toggle');
    });
});


