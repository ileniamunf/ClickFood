package it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model;

import java.util.Date;

public class Ordine {
    private int id_ordine;
    private String codiceRitiro, email, numeroCarta, stato, indirizzoSpedizione,note;
    private Date data;



    public Ordine(int id_ordine, String codiceRitiro, String email, String numeroCarta, Date data, String stato, String indirizzoSpedizione,String note){
        setIdOrdine(id_ordine);
        setCodiceRitiro(codiceRitiro);
        setEmail(email);
        setNumeroCarta(numeroCarta);
        setData(data);
        setStato(stato);
        setIndirizzoSpedizione(indirizzoSpedizione);
        setNote(note);
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getNote() {
        return note;
    }

    public void setIndirizzoSpedizione(String indirizzoSpedizione) {
        this.indirizzoSpedizione = indirizzoSpedizione;
    }

    public void setStato(String stato) {
        this.stato = stato;
    }

    public void setData(Date data) {
        this.data = data;
    }

    public void setNumeroCarta(String numeroCarta) {
        this.numeroCarta = numeroCarta;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setCodiceRitiro(String codiceRitiro) {
        this.codiceRitiro = codiceRitiro;
    }

    public void setIdOrdine(int id_ordine) {
        this.id_ordine=id_ordine;
    }

    public Date getData() {
        return data;
    }

    public String getStato() {
        return stato;
    }

    public String getEmail() {
        return email;
    }

    public int getId_ordine() {
        return id_ordine;
    }

    public String getCodiceRitiro() {
        return codiceRitiro;
    }

    public String getIndirizzoSpedizione() {
        return indirizzoSpedizione;
    }

    public String getNumeroCarta() {
        return numeroCarta;
    }
}
