const getUserMenuListApi = "RMS/v1.0/getUserMenus";
const configApi = "RMS/v1.0/getDomainList";
const loginTokenApi = "RMS/get/token";
const getLoginDataApi = "RMS/v1.0/getLoginData";
const depositWithdrawalApi = "RMS/v1.0/getOlaReport";
const getLedgetReportDataApi = "RMS/v1.0/getLedger";
const getOperationalCashReportDataApi = "RMS/v1.0/fetchOperationalCashReport";
const getBalanceInvoiceReportDataApi = "/RMS/v1.0/fetchBalanceReport";
const getGamesWithDraw = "sle/api/v1/retailer/getGamesWithDraw";
const getHistoricalResults = "sle/api/v1/retailer/getHistoricalResults";
const doRetailerSaleApi = 'sle/retailer/doretailerSale';
const claimWinningApi = 'sle/retailer/claimWinning';
const changePin = 'RMS/v1.0/changePassword';
const serviceList = 'RMS/v1.0/getServiceList';
const serviceReportDetail = 'RMS/v1.0/getSaleReport';
const summarizeReport = 'RMS/v1.0/getSummarizedLedger';
const depositAmountApi = 'rms/provideCoupon';
const pendingWithdrawalByQrcode = 'rms/pendingWithdrawalByQrcode';
const updateQrWithdrawalRequest = 'rms/updateQRWithdrawalRequest';
const defaultConfigApi = "RMS/getConfigValues";
const couponReversal = "rms/couponreversal";


const versionControlUrl            = "RMS/getPreAppVersion";

//Scratch
const inventoryFlowReportUrl = "/reports/inventoryFlowReport";
const inventoryReportUrl = "/reports/getInventoryDetailsForRetailer";
const gameDetailsForQuickOrderUrl = "/game/gameDetailsForQuickOrder";
const quickOrderUrl = "/order/quickOrder";
const packActivationUrl = "/inventory/activateBooks";
const gameListUrl = "/game/gameList";
const gameWiseInventoryUrl = "/inventory/getGameWiseInventory";
const packReturnUrl = "/inventory/getReturnNote";
const packReturnSubmitUrl = "/inventory/packReturnSubmit";
const dlDetailsUrl = "/inventory/dlDetails";
const bookReceiveUrl = "/inventory/bookReceive";
const soldTicketUrl = "/sale/soldTickets";
const ticketValidationUrl = "/Winning/verifyWinning";
const ticketClaimUrl = "/Winning/claimWinning";
const remainingTicketCount = "/inventory/currentRemainingTicketsCount";