package it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model;

import java.util.Date;

public class Cliente extends Utente{
    private Date dataDiNascita;



    public Cliente(String email, String password, String tipo, String nome, String cognome, Date dataDiNascita){
        super(email, password, "Cliente", nome, cognome);
        setDatadiNascita(dataDiNascita);
    }

    public Cliente(String email,String nome, String cognome){
        super(email, "", "Cliente", nome,cognome);
        setDatadiNascita(new Date());
    }

    public Cliente(String email){
        super(email, "", "Cliente","","");
        setDatadiNascita(new Date());
    }


    public void setDatadiNascita(Date dataDiNascita) {
        this.dataDiNascita = dataDiNascita;
    }

    public Date getDataDiNascita() {
        return dataDiNascita;
    }
}
