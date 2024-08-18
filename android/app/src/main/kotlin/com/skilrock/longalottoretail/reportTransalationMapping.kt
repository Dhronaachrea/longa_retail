package com.skilrock.longalottoretail

object ReportTranslationMapping {
    fun getTranslatedReportString(inputString: String, languageCode: String): String {
        if (languageCode == "en") {
            return when(inputString) {
                 "Draw Game"                -> "Draw Game"
                 "Sale"                     -> "Sale"
                 "Sale Return"              -> "Sale Return";
                 "Winning"                  -> "Winning"
                 "Credit"                   -> "Credit"
                 "Debit"                    -> "Debit"
                 "Cash Payment By"          -> "Cash Payment By"
                 "Credit Note By"           -> "Credit Note By"
                 "Debit Note By"            -> "Debit Note By"
                 "Retail Payments"          -> "Retail Payments"
                 "Player And Management"    -> "Player And Management"
                 "Opening Balance"          -> "Opening Balance"
                 "Closing Balance"          -> "Closing Balance"
                 "Summarize Ledger Report"  -> "Summarize Ledger Report"
                 "Net Amount"               -> "Net Amount"
                 else -> {inputString}
            }

        } else if (languageCode == "fr") {
            return when(inputString) {
                "Draw Game"                -> "Jeu de tirage au sort"
                "Sale"                     -> "Vente"
                "Sale Return"              -> "Retour de vente"
                "Winning"                  -> "Gagnant"
                "Credit"                   -> "Crédit"
                "Debit"                    -> "Débit"
                "Cash Payment By"          -> "Paiement en espèces par"
                "Credit Note By"           -> "Note de débit par"
                "Debit Note By"            -> "Note de crédit par"
                "Retail Payments"          -> "PAIEMENTS AU DÉTAIL"
                "Player And Management"    -> "JOUEUR ET GESTION"
                "Opening Balance"          -> "Solde d’ouverture"
                "Closing Balance"          -> "Solde de clôture"
                "Summarize Ledger Report"  -> "Résumer le rapport du grand livre"
                 "Net Amount"              -> "Montant net"
                else -> {inputString}
            }
        }
        
        return inputString
    }
}