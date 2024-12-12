package it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.utils;


import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model.*;
import org.json.JSONArray;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.ConnectionPoolDataSource;
import javax.sql.DataSource;
import javax.sql.PooledConnection;

public class Connessione {
    public static Connection connetti() throws NamingException, SQLException {
        Context ctx = new InitialContext();

        Context envCtx = (Context) ctx.lookup("java:comp/env");
        DataSource ds = (DataSource) envCtx.lookup("jdbc/MunfulettoDB");

        Connection connection = ds.getConnection();

        connection.setAutoCommit(false);

        return connection;
    }

}

