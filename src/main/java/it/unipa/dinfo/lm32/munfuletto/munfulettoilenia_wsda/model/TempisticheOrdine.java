package it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model;

import java.util.Date;
public class TempisticheOrdine {

    private int id_ordine;
    private String stato;
    private Date timestamp;

    public TempisticheOrdine(int id_ordine, String stato, Date timestamp){
            setIdOrdine(id_ordine);
            setStato(stato);
            setTimestamp(timestamp);

    }

    public void setStato(String stato) {
        this.stato=stato;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp=timestamp;
    }

    public void setIdOrdine(int id_ordine) {
        this.id_ordine=id_ordine;
    }

    public int getIdOrdine() {
        return id_ordine;
    }

    public String getStato() {
        return stato;
    }

    public Date getTimestamp() {
        return timestamp;
    }
}
