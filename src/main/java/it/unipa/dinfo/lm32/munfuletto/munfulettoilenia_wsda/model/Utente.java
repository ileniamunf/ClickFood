package it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model;

public class Utente {
    private String email, password, tipo, nome, cognome;

    public Utente(){
    }

    public Utente(String email, String password, String tipo, String nome, String cognome){
        setEmail(email);
        setPassword(password);
        setTipo(tipo);
        setNome(nome);
        setCognome(cognome);
    }

    public void setCognome(String cognome) {
        this.cognome = cognome;
    }

    public void setNome(String nome) {
        this.nome=nome;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }


    public String getEmail() {
        return email;
    }


    public String getPassword() {
        return password;
    }


    public String getTipo() {
        return tipo;
    }

    public String getNome() {
        return nome;
    }

    public String getCognome() {
        return cognome;
    }
}

