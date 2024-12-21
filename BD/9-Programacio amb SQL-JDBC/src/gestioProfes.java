import java.sql.*;
import java.util.Properties;

public class gestioProfes
   {
   public static void main (String args[])
     {
	try
	   {

	   // connectar a la base de dades
	   // cal modificar el username, password i el nom de la base de dades
	   // en el servidor postgresfib, SEMPRE el SSL ha de ser true
	   Properties props = new Properties();
	   props.setProperty("user","ElVostreUsername");
	   props.setProperty("password","ElVostrePassword");
	   props.setProperty("ssl","true");
	   props.setProperty("sslfactory", "org.postgresql.ssl.NonValidatingFactory"); 
	   Connection c = DriverManager.getConnection("jdbc:postgresql://postgresfib.fib.upc.es:6433/LaVostraBD", props);
	   c.setAutoCommit(false);
	   System.out.println ("Connexio realitzada correctament.");
	   System.out.println ();


	   // canvi de l'esquema per defecte a un altre esquema
		 Statement s = c.createStatement();
		 s.executeUpdate("set search_path to ElVostreEsquema;");
		 s.close();					
	   System.out.println ("Canvi d'esquema realitzat correctament.");
           System.out.println ();

	   // inserir un Professor
       String dni = "555";
       String nom = "nina";
       String telf = "3555";
       int sou = 1000;
	   String nouProfe = "insert into Professors values ('"+dni+"','"+nom+"','"+telf+"',"+sou+")";
	   Statement st = c.createStatement();
	   st.executeUpdate(nouProfe);
	   System.out.println ("Insercio realitzada");
           System.out.println ();
		   
	   // IMPLEMENTAR
       // printar el dni i el nom dels professors que tenen els tel�fons amb n�mero inferior al que s'indica en la variable buscaTelf
       // en cas que no hi hagi cap professor amb aquest tel�fon printar "NO TROBAT"     
       
		String buscaTelf="3334";    
       	String consulta = "select dni, nomProf from professors where telefon < ?";
      	PreparedStatement ps = c.prepareStatement(consulta);
      	ps.setString(1, buscaTelf);
       	ResultSet rs = ps.executeQuery();
       	boolean trobat = false;
       	while(rs.next()) {
			trobat = true;
			String dniProfe = rs.getString("dni");
			String nomProfe = rs.getString("nomProf");
			System.out.println("Dni: " + dniProfe + "; Nom: " + nomProfe);
    	}
       	rs.close();
       	ps.close();
       	if (!trobat) System.out.println("NO TROBAT");
       
       
		// Rollback i desconnexio de la base de dades
		c.commit();
		c.close();
  	}

	catch (SQLException se)
	{
		if (se.getSQLState().equals("23505")) {
			System.out.println("El professor ja existeix");
			System.out.println ();
		} else {
			System.out.println ("Excepcio: ");System.out.println ();
			System.out.println ("El getSQLState es: " + se.getSQLState());
			System.out.println ();
			System.out.println ("El getMessage es: " + se.getMessage());  
		}
  	}
}
}
}