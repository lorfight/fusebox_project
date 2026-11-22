*** Settings ***
Resource    ./NewOrder/NewOrder.resource
Resource    ./OpenOrders/OpenOrders.resource
Resource    ./OrderHistory/OrderHistory.resource
Resource    ./BackorderedOrders/BackorderedOrders.resource
Resource    ./OrderConfirmationMode/OrderConfirmationMode.resource
Resource    ./OrdersUnderDispute/OrdersUnderDispute.resource
Resource    ./PendingOrders/PendingOrders.resource
Resource    ./SalesOrders/SalesOrders.resource
Resource    ./AP-OrderInvoiceLedger/AP-OrderInvoiceLedger.resource
Resource    ./AP-ReconcileInvoices/AP-ReconcileInvoices.resource
Resource    ./OrderRequisitions/OrderRequisitions.resource
Resource    ./OrderDiscrepancyAudit/OrderDiscrepancyAudit.resource
Resource    ScheduledAppointmentOrdering/ScheduledAppointmentOrdering.resource
Resource    Reports/Reports.resource
Resource    FeeTracker/FeeTracker.resource