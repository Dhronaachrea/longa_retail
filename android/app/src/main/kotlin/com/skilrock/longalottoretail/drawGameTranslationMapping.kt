package com.skilrock.longalottoretail

import android.util.Log

object DrawGameTranslationMapping {
    fun getTranslatedDrawGameString(inputString: String, languageCode: String): String {
        Log.i("Rajneesh", "getTranslatedDrawGameString: INCOMING languageCode : $languageCode")
        if (languageCode == "en") {
            return when(inputString) {
                 "Purchase Time"                -> "Purchase Time"
                 "Ticket Number"                -> "Ticket Number"
                 "Draw Timing"                  -> "Draw Timing"
                 "Bet Details"                  -> "Bet Details"
                 "Draw Date"                    -> "Draw Date"
                 "Draw Time"                    -> "Draw Time"
                 "Win Status"                   -> "Win Status"
                 "Winning Amount"               -> "Winning Amount"
                 "Reprint Ticket"               -> "Reprint Ticket"
                 "Amount"                       -> "Amount"
                 "No of Draws(s)"               -> "No of Draws(s)"
                 "TOTAL AMOUNT"                 -> "TOTAL AMOUNT"
                 "Winning Multiplier"           -> "Winning Multiplier"
                 "Side Bet"                     -> "Side Bet"
                 "Result"                       -> "Result"
                 "Ticket Validity"              -> "Ticket Validity"
                 "Refund Amount"                -> "Refund Amount"
                "Ticket Cancelled"              -> "Ticket Cancelled"
                "Claim Status"                  -> "Claim Status"
                "Successfully printed"          -> "Successfully printed"
                "Manual"                        -> "Manual"
                "QP"                            -> "QP"

                 else -> {inputString}
            }

        } else if (languageCode == "fr") {
            return when(inputString) {
                "Purchase Time"                 -> "Heure d'achat"
                "Ticket Number"                 -> "Numéro de billet"
                "Draw Timing"                   -> "Horaire du tirage"
                "Bet Details"                   -> "Détails de la mise"
                "Draw Date"                     -> "Date du tirage"
                "Draw Time"                     -> "Heure du tirage"
                "Win Status"                    -> "Statut de gain"
                "Winning Amount"                -> "Montant gagnant"
                "Reprint Ticket"                -> "Réimprimer le billet"
                "Amount"                        -> "Montant"
                "No of Draws(s)"                -> "Nombre de tirages"
                "TOTAL AMOUNT"                  -> "MONTANT TOTAL"
                "Winning Multiplier"            -> "Multiplicateur de gain"
                "Side Bet"                      -> "Mise accessoire"
                "Result"                        -> "Résultat"
                "Ticket Validity"               -> "Validité du billet"
                "Refund Amount"                 -> "Montant remboursé"
                "Ticket Cancelled"              -> "Billet annulé"
                "Claim Status"                  -> "Statut \n de la revendication"
                "Successfully printed"          -> "Impression réussie"
                "Manual"                        -> "Manuel"
                "QP"                            -> "QP"
                else -> {inputString}
            }
        }
        
        return inputString
    }
}