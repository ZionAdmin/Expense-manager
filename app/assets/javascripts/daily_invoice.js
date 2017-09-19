$(document).ready(function () {


    $('#cal1').click(function(){
        $(".bill_date").datepicker({dateFormat: "yy-mm-dd"}).focus();
    });
    $('#cal2').click(function(){
        $(".date").multiDatesPicker({dateFormat: "yy-mm-dd"}).focus();
    });

    custom_expense();

});

function custom_expense() {

    $('#daily_invoice_expense_type').on('change', function () {

        if($("#daily_invoice_expense_type").val() == "CustomExpense")
        {
            $("#custom_expenses_link").trigger('click');
        }

    });

}