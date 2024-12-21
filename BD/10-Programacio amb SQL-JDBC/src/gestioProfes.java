import java.sql.*;
import java.util.Properties;

public class gestioProfes
   {
   public static void main (String args[])
     {
	try
	   {
	   // carregar el driver al controlador
	   Class.forName ("org.postgresql.Driver");
           System.out.println ();
	   System.out.println ("Driver de PostgreSQL carregat correctament.");
           System.out.println ();


	   // connectar a la base de dades
	   // cal modificar el username, password i el nom de la base de dades
	   // en el servidor postgresfib, SEMPRE el SSL ha de ser true
	   Properties props = new Properties();
	   props.setProperty("user","bernat.borras.civil");
	   props.setProperty("password","DB141002");
	   props.setProperty("ssl","true");
	   props.setProperty("sslfactory", "org.postgresql.ssl.NonValidatingFactory"); 
	   Connection c = DriverManager.getConnection("jdbc:postgresql://postgresfib.fib.upc.es:6433/DBbernat.borras.civil", props);
	   c.setAutoCommit(false);
	   System.out.println ("Connexio realitzada correctament.");
	   System.out.println ();


	   // canvi de l'esquema per defecte a un altre esquema
		 Statement s = c.createStatement();
		 s.executeUpdate("set search_path to public;");
		 s.close();					
	   System.out.println ("Canvi d'esquema realitzat correctament.");
           System.out.println ();

           
	   // IMPLEMENTAR CONSULTA
       String[] telfsProf = {"3111", "3222", "3333", "4444"};
       
       PreparedStatement ps = c.prepareStatement("select p.dni, p.nomProf from professors p where p.telefon = ?");
       
       for (int i = 0; i < telfsProf.length; ++i) {
    	ps.setString(1, telfsProf[i]);
    	ResultSet rs = ps.executeQuery();
    	boolean empty = true;
    	if (rs.next()) {
    		System.out.println(rs.getString("dni") + " " + rs.getString("nomProf"));
    		empty = false;
    	}
    	else System.out.println(telfsProf[i] + " NO TROBAT");
       }
      
		   
	   // IMPLEMENTAR CANVI BD       
       Statement stat = c.createStatement();
       int files = stat.executeUpdate("Update despatxos d set superficie = superficie + 3 where d.modul = 'omega' and not exists(select * from assignacions a where a.numero = d.numero and a.modul = d.modul and a.instantFi is null)");
       System.out.println(Integer.toString(files) + " files modificades");
       
	   // Commit i desconnexio de la base de dades
	   c.commit();
	   c.close();
	   System.out.println ("Commit i desconnexio realitzats correctament.");
	   }
	
	catch (ClassNotFoundException ce)
	   {
	   System.out.println ("Error al carregar el driver");
	   }	
	catch (SQLException se)
	   {
			if (se.getSQLState().equals("23514")) System.out.println ("Algun despatx passaria a tenir superfície superior o igual a 25");
			else {
				System.out.println ("Excepcio: ");System.out.println ();
				   System.out.println ("El getSQLState es: " + se.getSQLState());
			           System.out.println ();
				   System.out.println ("El getMessage es: " + se.getMessage());	 
			}
	   }
  }
}