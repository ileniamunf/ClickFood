package it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.utils;

import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model.*;
import jakarta.validation.constraints.Null;
import org.json.JSONArray;
import org.json.JSONObject;

import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;
import javax.naming.NamingException;

public class Query {

    //Prepared Statement
    private static final String cercaProdottiQuery = "SELECT * FROM Prodotti";
    private static final String cercaUtenteQuery = "SELECT * FROM Utenti WHERE Email = ? AND Password = ?";
    private static final String cercaClienteQuery= "SELECT * FROM Utenti U, Clienti C WHERE U.Email = C.Ref_Email AND C.Ref_Email=?";
    private static final String cercaUtenteQuery2 = "SELECT * FROM Utenti WHERE Email = ?";
    private static final String inserisciUtenteQuery = " INSERT INTO Utenti VALUES (?,?,?,?,?)";
    private static final String inserisciClienteQuery = "INSERT INTO Clienti VALUES (?,?)";
    private static final String inserisciOrdineQuery = "insert into Ordini (id_Ordine,Codice_Ritiro, Email_Ordine, Numero_Carta, Data, Stato, `Indirizzo di spedizione`,Note) values (?,?,?,?,?,?,?,?);";
    private static final String inserisciDettagliOrdineQuery = "INSERT INTO Dettagli_Ordini (Ref_Ordine,Ref_Prodotto) VALUES (?,?)";
    private static final String cercaMaxIdOrdineQuery ="SELECT max(id_Ordine) as max_id FROM Ordini;";
    private static final String cercaOrdiniDaLavorareQuery = "SELECT\n" +
            "    o.id_Ordine,\n" +
            "    o.Stato,\n" +
            "    COUNT(do.Ref_Prodotto) AS numero_prodotti,\n" +
            "    p.Nome_prodotto,\n" +
            "    do.Ref_Prodotto,\n" +
            "    o.`Indirizzo di spedizione`,\n" +
            "    o.Note\n" +
            "FROM\n" +
            "    Ordini o, Dettagli_Ordini do, Prodotti p\n" +
            "WHERE\n" +
            "    o.id_Ordine = do.Ref_Ordine and\n" +
            "    do.Ref_Prodotto = p.id_prodotto and\n" +
            "    (o.Stato = 'da lavorare' or o.Stato = 'in lavorazione') \n" +
            "GROUP BY\n" +
            "    o.id_Ordine, o.Stato, p.Nome_prodotto, do.Ref_Prodotto\n" +
            "ORDER BY\n" +
            "    o.id_Ordine;";

    private static final String cambiaStatoOrdineQuery = "UPDATE Ordini SET Stato = ? WHERE id_Ordine = ?";
    private static final String cercaOrdiniAlBancoQuery = "SELECT\n" +
            "    o.id_Ordine,\n" +
            "    o.Email_Ordine,\n" +
            "    o.Numero_Carta,\n" +
            "    o.Stato,\n" +
            "    o.Codice_Ritiro,\n" +
            "    COUNT(do.Ref_Prodotto) AS numero_prodotti,\n" +
            "    p.Nome_prodotto,\n" +
            "    do.Ref_Prodotto,\n" +
            "    p.Prezzo\n" +
            "FROM\n" +
            "    Ordini o, Dettagli_Ordini do, Prodotti p\n" +
            "WHERE\n" +
            "    o.id_Ordine = do.Ref_Ordine and\n" +
            "    do.Ref_Prodotto = p.id_prodotto and\n" +
            "    (o.Stato = 'al banco') \n" +
            "GROUP BY\n" +
            "    o.id_Ordine, o.Stato, p.Nome_prodotto, do.Ref_Prodotto\n" +
            "ORDER BY\n" +
            "    o.id_Ordine;";

    private static final String inserisciTimestampQuery = "INSERT INTO Tempistica_Ordini VALUES (?,?,current_time())";
    private static final String cercaOrdiniClienteQuery = "SELECT    \n" +
            "                o.*,\n" +
            "                 COUNT(do.Ref_Prodotto) AS numero_prodotti,    \n" +
            "                 p.Nome_prodotto,    \n" +
            "                 do.Ref_Prodotto,    \n" +
            "                 p.Prezzo    \n" +
            "             FROM    \n" +
            "                 Ordini o, Dettagli_Ordini do, Prodotti p    \n" +
            "             WHERE    \n" +
            "                 o.id_Ordine = do.Ref_Ordine and    \n" +
            "                 do.Ref_Prodotto = p.id_prodotto and\n" +
            "                 o.Email_Ordine = ?\n" +
            "            GROUP BY\n" +
            "                 o.id_Ordine, o.Stato, p.Nome_prodotto, do.Ref_Prodotto, o.Data    \n" +
            "             ORDER BY    \n" +
            "                 o.Data;";


    private static final String cercaOrdiniDaConsegnareQuery = "SELECT\n" +
            "                 o.*,\n" +
            "                 COUNT(do.Ref_Prodotto) AS numero_prodotti,    \n" +
            "                 p.Nome_prodotto,    \n" +
            "                 do.Ref_Prodotto,    \n" +
            "                 p.Prezzo    \n" +
            "             FROM    \n" +
            "                 Ordini o, Dettagli_Ordini do, Prodotti p    \n" +
            "             WHERE    \n" +
            "                 o.id_Ordine = do.Ref_Ordine and    \n" +
            "                 do.Ref_Prodotto = p.id_prodotto and    \n" +
            "                 (o.Stato = 'domicilio' or o.Stato = 'in consegna')\n" +
            "             GROUP BY    \n" +
            "                 o.id_Ordine, o.Stato, p.Nome_prodotto, do.Ref_Prodotto, o.Data\n" +
            "             ORDER BY    \n" +
            "                 o.Data;";


    private static final String cercaTempisticheGraficoQuery = "SELECT\n" +
            "    previous_status,\n" +
            "    next_status,\n" +
            "    AVG(TIMESTAMPDIFF(SECOND, previous_timestamp, next_timestamp)) AS average_time_seconds\n" +
            "FROM (\n" +
            "         SELECT\n" +
            "             previous_status.Stato AS previous_status,\n" +
            "             next_status.Stato AS next_status,\n" +
            "             previous_status.Timestamp AS previous_timestamp,\n" +
            "             next_status.Timestamp AS next_timestamp\n" +
            "         FROM Tempistica_Ordini AS previous_status\n" +
            "                  JOIN Tempistica_Ordini AS next_status\n" +
            "                       ON previous_status.Ref_Ordine = next_status.Ref_Ordine\n" +
            "                           AND previous_status.Timestamp < next_status.Timestamp\n" +
            "     ) AS status_transitions\n" +
            "GROUP BY previous_status, next_status\n" +
            "ORDER BY previous_status, next_status;";


    private static final String  cercaNumeroOrdiniQuery = "SELECT COUNT(id_Ordine) AS numero_ordini FROM Ordini;";
    private static final String  cercaNumeroClientiQuery = "SELECT COUNT(Email) AS numero_clienti FROM Utenti WHERE Tipo = 'Cliente';";
    private static final String cambiaPasswordQuery = "UPDATE Utenti SET Password = ? WHERE Email = ?";



    //QUERY
    public static ArrayList<Prodotto> getProdotti() {
        ArrayList<Prodotto> prodList = new ArrayList<Prodotto>();
        Connection connection = null;
        PreparedStatement selectProdottiQuery = null;
        ResultSet result = null;

        try {
            connection = Connessione.connetti();
            selectProdottiQuery = connection.prepareStatement(cercaProdottiQuery);

            result = selectProdottiQuery.executeQuery();

            while (result.next()) {
                Prodotto prod = new Prodotto();
                prod.setIdProdotto(result.getInt("id_prodotto"));
                prod.setNome(result.getString("Nome_prodotto"));
                prod.setPrezzo(result.getFloat("Prezzo"));
                prod.setCategoria(result.getString("Categoria"));

                prodList.add(prod);
            }

        }catch(SQLException | NamingException e){
            e.printStackTrace();
        }
        finally {
            try{
                if(connection!=null){
                    connection.close();
                }
                if(selectProdottiQuery!=null){
                    selectProdottiQuery.close();
                }
                if(result!= null){
                    result.close();
                }

            }catch (SQLException e){
                e.printStackTrace();
            }
        }
        return prodList;
    }


    public static Utente getUtente(String email, String password) {
        Connection connection = null;
        PreparedStatement selectUtenteQuery = null;
        ResultSet result = null;
        Utente utente = null;
        try {
             connection = Connessione.connetti();
             selectUtenteQuery = connection.prepareStatement(cercaUtenteQuery);
             selectUtenteQuery.setString(1, email);
             selectUtenteQuery.setString(2, password);
             result = selectUtenteQuery.executeQuery();

            if(result.next()){
                String tipo = result.getString("Tipo");
                String nome = result.getString("Nome");
                String cognome = result.getString("Cognome");
                utente = new Utente(email, password,tipo, nome, cognome);

            }


        }catch(SQLException | NamingException e){
            e.printStackTrace();
        }
        finally {
            try{
                if(connection!=null){
                    connection.close();
                }
                if(selectUtenteQuery!=null){
                    selectUtenteQuery.close();
                }
                if(result!= null){
                    result.close();
                }

            }catch (SQLException e){
                e.printStackTrace();
            }
        }
        return utente;
    }




    public static Cliente getCliente(String email) {
        Connection connection = null;
        PreparedStatement selectClienteQuery = null;
        ResultSet result = null;
        Cliente cliente = null;

        try {
            connection = Connessione.connetti();
            selectClienteQuery = connection.prepareStatement(cercaClienteQuery);
            selectClienteQuery.setString(1, email);

             result = selectClienteQuery.executeQuery();

            if(result.next()){
                String password = result.getString("Password");
                String tipo = result.getString("Tipo");
                String nome = result.getString("Nome");
                String cognome = result.getString("Cognome");
                Date dataNascita = result.getDate("Data di nascita");
                cliente = new Cliente(email, password,tipo, nome, cognome, dataNascita);
            }

            selectClienteQuery.close();
            result.close();
            connection.close();


        }catch(SQLException | NamingException e){
            e.printStackTrace();
        }
        finally {
            try{
                if(connection!=null){
                    connection.close();
                }
                if(selectClienteQuery!=null){
                    selectClienteQuery.close();
                }
                if(result!= null){
                    result.close();
                }

            }catch (SQLException e){
                e.printStackTrace();
            }
        }
        return cliente;
    }


    public static boolean searchUtente(String email) {
        Connection connection = null;
        PreparedStatement checkUserQuery = null;
        ResultSet result = null;
        boolean esito = false;

        try {
            connection = Connessione.connetti();
            checkUserQuery = connection.prepareStatement(cercaUtenteQuery2);
            checkUserQuery.setString(1, email);

             result = checkUserQuery.executeQuery();

            if(result.next()){
                esito = true;
            }

        }catch(SQLException | NamingException e){
            e.printStackTrace();
        }
        finally {
            try{
                if(connection!=null){
                    connection.close();
                }
                if(checkUserQuery!=null){
                    checkUserQuery.close();
                }
                if(result!= null){
                    result.close();
                }

            }catch (SQLException e){
                e.printStackTrace();
            }
        }
        return esito;
    }




    public static boolean insertCliente(Cliente cliente) {
        Connection connection = null;
        PreparedStatement insertClienteQuery = null;
        boolean esito = false;
        try{
             connection = Connessione.connetti();
            if(Query.insertUtente(new Utente(cliente.getEmail(), cliente.getPassword(), cliente.getTipo(), cliente.getNome(), cliente.getCognome()))){
                 insertClienteQuery = connection.prepareStatement(inserisciClienteQuery);
                insertClienteQuery.setString(1, cliente.getEmail());
                insertClienteQuery.setDate(2, new java.sql.Date(cliente.getDataDiNascita().getTime()));


                insertClienteQuery.executeUpdate();
                connection.commit();
                esito=true;
            }
            connection.rollback();


        }catch(SQLException | NamingException e){
            e.printStackTrace();
        }
        finally {
            try{
                if(connection!=null){
                    connection.close();
                }
                if(insertClienteQuery!=null){
                    insertClienteQuery.close();
                }

            }catch (SQLException e){
                e.printStackTrace();
            }
        }
        return esito;
    }


    public static boolean insertUtente(Utente utente) {
        Connection connection = null;
        PreparedStatement insertUtenteQuery = null;
        boolean esito = false;
        try{
            connection = Connessione.connetti();
            insertUtenteQuery = connection.prepareStatement(inserisciUtenteQuery);
            insertUtenteQuery.setString(1, utente.getEmail());
            insertUtenteQuery.setString(2, utente.getPassword());
            insertUtenteQuery.setString(3, utente.getTipo());
            insertUtenteQuery.setString(4, utente.getNome());
            insertUtenteQuery.setString(5, utente.getCognome());

            insertUtenteQuery.executeUpdate();
            connection.commit();

           esito=true;

        }catch(SQLException | NamingException e){
            e.printStackTrace();
        }
        finally {
            try{
                if(connection!=null){
                    connection.close();
                }
                if(insertUtenteQuery!=null){
                    insertUtenteQuery.close();
                }

            }catch (SQLException e){
                e.printStackTrace();
            }
        }
        return esito;
    }



    public static boolean insertDettagliOrdine(ArrayList<Prodotto> listProdotti, JSONObject formParams, int max_id) {
        int id_Ordine= max_id+1;
        Connection connection = null;
        PreparedStatement insertDettagliOrdineQuery = null;
        boolean esito = false;

        try{
            connection = Connessione.connetti();
            try{
                if(Query.insertOrdine(listProdotti,formParams, id_Ordine, connection)){
                    insertDettagliOrdineQuery = connection.prepareStatement(inserisciDettagliOrdineQuery);

                    for(int i =0; i<listProdotti.size(); i++){
                        insertDettagliOrdineQuery.setInt(1, id_Ordine);
                        insertDettagliOrdineQuery.setInt(2, listProdotti.get(i).getId_prodotto());
                        insertDettagliOrdineQuery.executeUpdate();
                    }

                    connection.commit();
                    esito=true;
                }
            }catch(SQLException e){
                connection.rollback();
                e.printStackTrace();
            }

        }catch(SQLException | NamingException e){
            e.printStackTrace();

        }
        finally {
            try{
                if(connection!=null){
                    connection.close();
                }
                if(insertDettagliOrdineQuery!=null){
                    insertDettagliOrdineQuery.close();
                }

            }catch (SQLException e){
                e.printStackTrace();
            }
        }
        return esito;
    }


    public static boolean insertOrdine(ArrayList<Prodotto> listProdotti, JSONObject formParams, int id_Ordine, Connection connection) {
        String todayDate = new SimpleDateFormat("yyyy-MM-dd").format(Calendar.getInstance().getTime());
        PreparedStatement insertOrdineQuery = null;
        boolean esito = false;
        try{
            insertOrdineQuery = connection.prepareStatement(inserisciOrdineQuery);
            insertOrdineQuery.setInt(1,id_Ordine);
            insertOrdineQuery.setString(2, SHA256.SHA256Hash("ORDER-"+id_Ordine));
            insertOrdineQuery.setString(3, formParams.getString("emailRichiedente"));
            if(formParams.getString("modalitaPagamento").equals("carta")){
                insertOrdineQuery.setString(4,formParams.getString("numeroCarta").replace(" ",""));
            }else{
                insertOrdineQuery.setNull(4,java.sql.Types.NULL);
            }
            insertOrdineQuery.setString(5,todayDate);
            insertOrdineQuery.setString(6,"da lavorare");
            if(formParams.getString("modalitaConsegna").equals("domicilio")){
                insertOrdineQuery.setString(7, formParams.getString("indirizzo"));
            }else{
                insertOrdineQuery.setNull(7,java.sql.Types.NULL);
            }
            if (formParams.has("note")) {
                insertOrdineQuery.setString(8, formParams.getString("note"));
            }else{
                insertOrdineQuery.setNull(8,java.sql.Types.NULL);
            }


            insertOrdineQuery.executeUpdate();

            esito=true;

        }catch(SQLException e){
            e.printStackTrace();
        }

        finally {
            try{
                if(insertOrdineQuery!=null){
                    insertOrdineQuery.close();
                }

            }catch (SQLException e){
                e.printStackTrace();
            }
        }
        return esito;
    }




    public static int getMaxIdOrdine(){
        int max_id = 0;
        Connection connection = null;
        PreparedStatement selectMaxIdOrdineQuery = null;
        ResultSet result = null;
        try {
            connection = Connessione.connetti();
            selectMaxIdOrdineQuery = connection.prepareStatement(cercaMaxIdOrdineQuery);

            result = selectMaxIdOrdineQuery.executeQuery();

            if(result.next()){
               max_id = result.getInt("max_id");

            }

        }catch(SQLException | NamingException e){
            e.printStackTrace();
        }
        finally {
            try{
                if(connection!=null){
                    connection.close();
                }
                if(selectMaxIdOrdineQuery!=null){
                    selectMaxIdOrdineQuery.close();
                }
                if(result!= null){
                    result.close();
                }

            }catch (SQLException e){
                e.printStackTrace();
            }
        }

        return max_id;
    }


    public static Map<Integer, List<JSONObject>> getOrdiniCuoco() {
       List<JSONObject> ordini = new ArrayList<>();
       Map<Integer, List<JSONObject>> ordiniDaLavorare = new HashMap<>();
        Connection connection = null;
        PreparedStatement selectOrdiniDaLavorareQuery = null;
        ResultSet result = null;

        try{
            connection = Connessione.connetti();
            selectOrdiniDaLavorareQuery = connection.prepareStatement(cercaOrdiniDaLavorareQuery);

            result = selectOrdiniDaLavorareQuery.executeQuery();

            while (result.next()) {
                JSONObject ordine = new JSONObject();
                ordine.put("id_Ordine",result.getInt("id_Ordine"));
                ordine.put("Nome_Prodotto", result.getString("Nome_prodotto"));
                ordine.put("Quantity", result.getInt("numero_prodotti"));
                ordine.put("id_Prodotto", result.getInt("Ref_Prodotto"));
                ordine.put("Stato", result.getString("Stato"));
                if(result.getString("Indirizzo di spedizione") == null){
                    ordine.put("Indirizzo", "");
                }else{
                    ordine.put("Indirizzo", result.getString("Indirizzo di spedizione"));
                }
                if(result.getString("Note") == null){
                    ordine.put("Note", "");
                }else{
                    ordine.put("Note", result.getString("Note"));
                }
                ordini.add(ordine);
            }

            ordiniDaLavorare = ordini.stream().collect(Collectors.groupingBy(w -> w.getInt("id_Ordine")));


        }catch(SQLException | NamingException e){
            e.printStackTrace();
        }
        finally{
            try{
                if(connection!=null){
                    connection.close();
                }
                if(result!= null){
                    result.close();
                }
                if(selectOrdiniDaLavorareQuery!=null){
                    selectOrdiniDaLavorareQuery.close();
                }

            }catch(SQLException e){

            }
        }
        return ordiniDaLavorare;
    }



    public static boolean changeStatus(String idOrdine, String newStato) {
        Connection connection = null;
        PreparedStatement changeStatusOrdineQuery = null;
        boolean esito = false;

        try{
            connection = Connessione.connetti();
            changeStatusOrdineQuery = connection.prepareStatement(cambiaStatoOrdineQuery);
            changeStatusOrdineQuery.setString(1, newStato);
            changeStatusOrdineQuery.setString(2, idOrdine);

            int result = changeStatusOrdineQuery.executeUpdate();


            connection.commit();

            if(result > 0){
               esito = true;
            }

        }catch(SQLException | NamingException e){
            e.printStackTrace();
        }
        finally {
            try{
                if(connection!=null){
                    connection.close();
                }
                if(changeStatusOrdineQuery != null){
                    changeStatusOrdineQuery.close();
                }

            }catch (SQLException e){
                e.printStackTrace();
            }

        }

       return esito;
    }



    public static Map<Integer, List<JSONObject>> getOrdiniAddetto() {
        List<JSONObject> ordini = new ArrayList<>();
        Map<Integer, List<JSONObject>> ordiniAlBanco = new HashMap<>();
        Connection connection = null;
        PreparedStatement selectOrdiniAlBancoQuery = null;
        ResultSet result = null;
        try{
            connection = Connessione.connetti();
            selectOrdiniAlBancoQuery = connection.prepareStatement(cercaOrdiniAlBancoQuery);

            result = selectOrdiniAlBancoQuery.executeQuery();

            while (result.next()) {
                JSONObject ordine = new JSONObject();
                ordine.put("id_Ordine",result.getInt("id_Ordine"));
                ordine.put("EmailOrdine", result.getString("Email_Ordine"));
                if(result.getString("Numero_Carta")!= null){
                    ordine.put("NumCarta",result.getString("Numero_Carta"));
                }else{
                    ordine.put("NumCarta","Contanti");
                }
                ordine.put("Nome_Prodotto", result.getString("Nome_prodotto"));
                ordine.put("CodiceRitiro", result.getString("Codice_Ritiro"));
                ordine.put("Quantity", result.getInt("numero_prodotti"));
                ordine.put("id_Prodotto", result.getInt("Ref_Prodotto"));
                ordine.put("Stato", result.getString("Stato"));
                ordine.put("Prezzo", result.getFloat("Prezzo"));
                ordini.add(ordine);
            }

            ordiniAlBanco = ordini.stream().collect(Collectors.groupingBy(w -> w.getInt("id_Ordine")));


        }catch(SQLException | NamingException e){
            e.printStackTrace();
        }
        finally{
            try{
                if(connection!=null){
                    connection.close();
                }
                if(result!= null){
                    result.close();
                }
                if(selectOrdiniAlBancoQuery!=null){
                    selectOrdiniAlBancoQuery.close();
                }

            }catch(SQLException e){

            }
        }

        return ordiniAlBanco;
    }

    public static void insertTimestamp(int id_Ordine, String stato) {
        Connection connection = null;
        PreparedStatement insertTimestampQuery = null;

        try{
            connection = Connessione.connetti();
            insertTimestampQuery = connection.prepareStatement(inserisciTimestampQuery);

            insertTimestampQuery.setInt(1, id_Ordine);
            insertTimestampQuery.setString(2,stato);


            insertTimestampQuery.executeUpdate();

            connection.commit();

        }catch(SQLException | NamingException e){
            e.printStackTrace();
        }
        finally {
            try{
                if(connection!=null){
                    connection.close();
                }
                if(insertTimestampQuery!=null){
                    insertTimestampQuery.close();
                }

            }catch (SQLException e){
                e.printStackTrace();
            }
        }


    }


    public static Map<Integer, List<JSONObject>> getOrdiniCliente(String emailCliente) {
        List<JSONObject> ordini = new ArrayList<>();
        Map<Integer, List<JSONObject>> ordiniCliente = new HashMap<>();
        Connection connection = null;
        PreparedStatement selectOrdiniClienteQuery = null;
        ResultSet result = null;
        try{
            connection = Connessione.connetti();
            selectOrdiniClienteQuery = connection.prepareStatement(cercaOrdiniClienteQuery);
            selectOrdiniClienteQuery.setString(1,emailCliente);

            result = selectOrdiniClienteQuery.executeQuery();

            while (result.next()) {
                JSONObject ordine = new JSONObject();
                ordine.put("id_Ordine",result.getInt("id_Ordine"));
                ordine.put("CodiceRitiro", result.getString("Codice_Ritiro"));
                ordine.put("Email", result.getString("Email_Ordine"));
                if(result.getString("Numero_Carta")!= null){
                    ordine.put("NumCarta",result.getString("Numero_Carta"));
                }else{
                    ordine.put("NumCarta","Contanti");
                }
                ordine.put("Data", result.getDate("Data"));
                ordine.put("Stato", result.getString("Stato"));
                if(result.getString("Indirizzo di spedizione")!= null){
                    ordine.put("IndirizzoSpedizione", result.getString("Indirizzo di spedizione"));
                }else{
                    ordine.put("IndirizzoSpedizione", "Ritiro in negozio");
                }

                if(result.getString("Note")!= null){
                    ordine.put("Note",result.getString("Note"));
                }else{
                    ordine.put("Note","Nessuna Nota");
                }
                ordine.put("Quantity", result.getInt("numero_prodotti"));
                ordine.put("Nome_Prodotto", result.getString("Nome_prodotto"));
                ordine.put("id_Prodotto", result.getInt("Ref_Prodotto"));
                ordine.put("Prezzo", result.getFloat("Prezzo"));


                ordini.add(ordine);
            }

            ordiniCliente = ordini.stream().collect(Collectors.groupingBy(w -> w.getInt("id_Ordine")));

        }catch(SQLException | NamingException e){
            e.printStackTrace();
        }
        finally{
            try{
                if(connection!=null){
                    connection.close();
                }
                if(result!= null){
                    result.close();
                }
                if(selectOrdiniClienteQuery!=null){
                    selectOrdiniClienteQuery.close();
                }

            }catch(SQLException e){
                e.printStackTrace();
            }
        }
        return ordiniCliente;
    }


    public static Map<Integer, List<JSONObject>> getOrdiniFattorino() {
        List<JSONObject> ordini = new ArrayList<>();
        Map<Integer, List<JSONObject>> ordiniDaConsegnare = new HashMap<>();
        Connection connection = null;
        PreparedStatement selectOrdiniDaConsegnareQuery = null;
        ResultSet result = null;
        try{
            connection = Connessione.connetti();
            selectOrdiniDaConsegnareQuery = connection.prepareStatement(cercaOrdiniDaConsegnareQuery);

            result = selectOrdiniDaConsegnareQuery.executeQuery();

            while (result.next()) {
                JSONObject ordine = new JSONObject();
                ordine.put("id_Ordine",result.getInt("id_Ordine"));
                ordine.put("CodiceRitiro", result.getString("Codice_Ritiro"));
                ordine.put("EmailOrdine", result.getString("Email_Ordine"));
                if(result.getString("Numero_Carta")!= null){
                    ordine.put("NumCarta",result.getString("Numero_Carta"));
                }else{
                    ordine.put("NumCarta","Contanti");
                }
                ordine.put("Data", result.getDate("Data"));
                ordine.put("Stato", result.getString("Stato"));
                ordine.put("IndirizzoConsegna", result.getString("Indirizzo di spedizione"));
                if(result.getString("Note")!= null){
                    ordine.put("Note",result.getString("Note"));
                }else{
                    ordine.put("Note","Nessuna Nota");
                }
                ordine.put("Quantity", result.getInt("numero_prodotti"));
                ordine.put("Nome_Prodotto", result.getString("Nome_prodotto"));
                ordine.put("id_Prodotto", result.getInt("Ref_Prodotto"));
                ordine.put("Prezzo", result.getFloat("Prezzo"));
                ordini.add(ordine);
            }

            ordiniDaConsegnare = ordini.stream().collect(Collectors.groupingBy(w -> w.getInt("id_Ordine")));

        }catch(SQLException | NamingException e){
            e.printStackTrace();
        }
        finally{
            try{
                if(connection!=null){
                    connection.close();
                }
                if(result!= null){
                    result.close();
                }
                if(selectOrdiniDaConsegnareQuery!=null){
                    selectOrdiniDaConsegnareQuery.close();
                }

            }catch(SQLException e){
                e.printStackTrace();
            }
        }
        return ordiniDaConsegnare;


    }

    public static JSONArray getTempisticheResponsabile() {
        JSONArray tempistiche = new JSONArray();
        Connection connection = null;
        PreparedStatement selectTempisticheQuery = null;
        ResultSet result = null;
        try{
            connection = Connessione.connetti();
            selectTempisticheQuery = connection.prepareStatement(cercaTempisticheGraficoQuery);

            result = selectTempisticheQuery.executeQuery();

            while(result.next()){
                JSONObject obj = new JSONObject();
                obj.put("Stato_iniziale",result.getString("previous_status"));
                obj.put("Stato_finale",result.getString("next_status"));
                obj.put("tempo_medio",result.getInt("average_time_seconds"));

                tempistiche.put(obj);
            }

        }catch(SQLException | NamingException e){
            e.printStackTrace();
        }
        finally {
            try{
                if(connection!=null){
                    connection.close();
                }
                if(result!= null){
                    result.close();
                }
                if( selectTempisticheQuery!=null){
                    selectTempisticheQuery.close();
                }
            }catch (SQLException e){
                e.printStackTrace();
            }
        }

        return tempistiche;
    }


    public static int getNumeroOrdiniTotali(){
        int n = 0;
        Connection connection = null;
        PreparedStatement selectNumeroOrdiniQuery = null;
        ResultSet result = null;
        try{
            connection = Connessione.connetti();
            selectNumeroOrdiniQuery = connection.prepareStatement(cercaNumeroOrdiniQuery);

            result = selectNumeroOrdiniQuery.executeQuery();

            if(result.next()){
                n = result.getInt("numero_ordini");

            }

        }catch(SQLException | NamingException e){
            e.printStackTrace();
        }
        finally {
            try{
                if(connection!=null){
                    connection.close();
                }
                if(result!= null){
                    result.close();
                }
                if( selectNumeroOrdiniQuery!=null){
                    selectNumeroOrdiniQuery.close();
                }
            }catch (SQLException e){
                e.printStackTrace();
            }
        }
        return n;
    }


    public static int getNumeroClientiTotali(){
        int n = 0;
        Connection connection = null;
        PreparedStatement selectNumeroClientiQuery = null;
        ResultSet result = null;
        try{
            connection = Connessione.connetti();
            selectNumeroClientiQuery = connection.prepareStatement(cercaNumeroClientiQuery);

            result = selectNumeroClientiQuery.executeQuery();

            if(result.next()){
                n = result.getInt("numero_clienti");

            }

        }catch(SQLException | NamingException e){
            e.printStackTrace();
        }
        finally {
            try{
                if(connection!=null){
                    connection.close();
                }
                if(result!= null){
                    result.close();
                }
                if( selectNumeroClientiQuery!=null){
                    selectNumeroClientiQuery.close();
                }
            }catch (SQLException e){
                e.printStackTrace();
            }
        }

        return n;
    }

    public static boolean changePassword(String email, String password) {
        Connection connection = null;
        PreparedStatement changePasswordQuery = null;
        boolean esito = false;
        try{
            connection = Connessione.connetti();
            changePasswordQuery = connection.prepareStatement(cambiaPasswordQuery);
            changePasswordQuery.setString(1, password);
            changePasswordQuery.setString(2, email);

            int result = changePasswordQuery.executeUpdate();


            connection.commit();

            if(result > 0){
                esito=true;
            }

        }catch(SQLException | NamingException e){
            e.printStackTrace();
        }
        finally {
            try{
                if(changePasswordQuery!=null){
                    changePasswordQuery.close();
                }

            }catch (SQLException e){
                e.printStackTrace();
            }
        }
        return esito;
    }
}
