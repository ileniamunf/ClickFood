package it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model;

public class Prodotto {
    private int id_prodotto;
    private String nome, categoria;
    private float prezzo;



    public Prodotto(){

    }

    public Prodotto(int id_prodotto, String nome, float prezzo, String categoria){
        setIdProdotto(id_prodotto);
        setNome(nome);
        setPrezzo(prezzo);
        setCategoria(categoria);
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public void setPrezzo(float prezzo) {
        this.prezzo = prezzo;
    }

    public void setNome(String nome) {
        this.nome=nome;
    }

    public void setIdProdotto(int id_prodotto) {
        this.id_prodotto = id_prodotto;
    }

    public String getCategoria() {
        return categoria;
    }

    public String getNome() {
        return nome;
    }

    public int getId_prodotto() {
        return id_prodotto;
    }

    public float getPrezzo() {
        return prezzo;
    }
}
