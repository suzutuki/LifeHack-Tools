// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require activestorage
//= require rails-ujs
//= require flatpickr
//= require flatpickr/l10n/ja
//= require turbolinks
//= require jquery3
//= require jquery_ujs
//= require jquery
//= require Chart.min
//= require_tree .

// ボタンが押されたら優先順位,1位以外を非表示にする。not-priority-1がターゲット
$(function () {
    $("trigger_priority").click(function () {
        $(".not-priority-1").toggle("slow");
    });
});
// ボタンが押されたら更新・作成日時を非表示にする。tasks-targetがターゲット
$(function () {
    $("trigger_time").click(function () {
        $(".tasks-time").toggle("slow");
    });
});
// フラッシュメッセージのアニメーション
$(function () {
    setTimeout("$('.time-limit').fadeOut('slow')", 2000)
});

// ToDoリストでチェックボタンを動的(チェックされた、またはされてない状態を保存)にする
$(function () {
    $('input:checkbox[name="task"]').click(function () {
        $.post('/tasks/' + $(this).data('id') + '/toggle');
    });
});

// スモールステップでチェックボタンを動的(チェックされた、またはされてない状態を保存)にする
$(function () {
    $("input[type=checkbox]").click(function () {
        $.post('/steps/' + $(this).data('id') + '/toggle');
    });
});

