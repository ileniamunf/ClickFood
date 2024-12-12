package it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model;

public class DettagliOrdine {
    private int id, id_ordine, id_prodotto;



    public DettagliOrdine(int id, int id_ordine, int id_prodotto){
        setId(id);
        setIdOrdine(id_ordine);
        setIdProdotto(id_prodotto);

    }


    public void setIdProdotto(int idProdotto) {
        this.id_prodotto=idProdotto;
    }

    public void setIdOrdine(int idOrdine) {
        this.id_ordine=idOrdine;
    }

    public void setId(int id) {
        this.id=id;
    }



    public int getId_ordine() {
        return id_ordine;
    }

    public int getId_prodotto() {
        return id_prodotto;
    }

    public int getId() {
        return id;
    }
}
