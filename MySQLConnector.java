import java.sql.*;

public class MySQLConnector {
    public static void main(String[] args) {
        Connection con = null;
        try {
            // JDBCドライバのロード
            Class.forName("com.mysql.jdbc.Driver");//.newInstance();
            // MySQLに接続
            con = DriverManager.getConnection("jdbc:mysql://localhost/psp_for_E", "root", "");
            System.out.println("MySQLに接続できました。");
        } catch(ClassNotFoundException ex){
            System.out.println(ex);
        } catch (SQLException e) {
            System.out.println("MySQLに接続できませんでした。");
            System.out.println(e);
        } finally {
            if (con != null) {
                try {
                    con.close();
                } catch (SQLException e) {
                    System.out.println("MySQLのクローズに失敗しました。");
                }
            }
        }
    }
}
