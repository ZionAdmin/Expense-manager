$(document).ready(function () {
    $("#daily_invoice_form").validate();
    $('.selectpicker').selectpicker();

    $('#cal1').click(function(){
        $(".bill_date").datepicker({dateFormat: "yy-mm-dd"}).focus();
    });
    $('#cal2').click(function(){
        $(".date").multiDatesPicker({dateFormat: "yy-mm-dd"}).focus();
    });

    $('#daily_invoice_expense_type').on('change', function () {

        if($("#daily_invoice_expense_type").val() == "CustomExpense")
        {
            $("#custom_expense_modal_id").modal('show');
        }

    });

});