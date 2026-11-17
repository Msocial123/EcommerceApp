package com.conn;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 * Hands out JDBC connections to the DAOs.
 *
 * <p>Where connections come from, in order:</p>
 * <ol>
 *   <li>A JNDI DataSource {@code java:comp/env/jdbc/EcommerceDB}: a {@code <Resource>} in Tomcat's
 *       {@code conf/server.xml}, linked into the app by {@code META-INF/context.xml}.
 *       The JNDI name can be changed with the {@code db.jndiName} setting.</li>
 *   <li>Otherwise {@link DriverManager} with {@code db.url}, {@code db.username},
 *       {@code db.password} and {@code db.driver}.</li>
 * </ol>
 *
 * <p>Each setting is read from a {@code -Ddb.url=...} system property, then a {@code DB_URL}
 * environment variable, then {@code db.properties} on the classpath, then the default below.</p>
 *
 * <p>Callers never close what {@link #getConn()} returns, so every connection opened during an
 * HTTP request is remembered and closed by {@link ConnectionCleanupFilter} when the request ends.</p>
 */
public final class DBConnect {

	private static final Logger LOG = Logger.getLogger(DBConnect.class.getName());

	private static final String DEFAULT_URL =
			"jdbc:mysql://localhost:3306/ecommerce?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

	private static final Properties FILE_PROPS = loadFileProperties();

	/** Connections opened on the current thread (one HTTP request) and not yet closed. */
	private static final ThreadLocal<List<Connection>> OPEN = new ThreadLocal<List<Connection>>();

	/** Set once JNDI has been tried: the DataSource found, or null to use DriverManager. */
	private static volatile boolean jndiChecked = false;
	private static volatile DataSource dataSource;

	private DBConnect() {
	}

	/**
	 * Returns an open connection. It is closed automatically at the end of the HTTP request.
	 *
	 * @throws IllegalStateException if no connection can be made (the message says why)
	 */
	public static Connection getConn() {
		try {
			Connection conn = open();
			List<Connection> list = OPEN.get();
			if (list == null) {
				list = new ArrayList<Connection>();
				OPEN.set(list);
			}
			list.add(conn);
			return conn;
		} catch (SQLException e) {
			throw new IllegalStateException("Cannot connect to the database (" + describeSource() + "): "
					+ e.getMessage(), e);
		}
	}

	/** Closes every connection {@link #getConn()} opened on this thread. */
	public static void closeThreadConnections() {
		List<Connection> list = OPEN.get();
		OPEN.remove();
		if (list == null) {
			return;
		}
		for (Connection c : list) {
			try {
				if (!c.isClosed()) {
					c.close();
				}
			} catch (SQLException e) {
				LOG.log(Level.WARNING, "Could not close JDBC connection", e);
			}
		}
	}

	/** Where connections come from, e.g. for logs: "jndi:java:comp/env/jdbc/EcommerceDB" or the JDBC URL. */
	public static String describeSource() {
		DataSource ds = lookupDataSource();
		if (ds != null) {
			return "jndi:java:comp/env/" + setting("db.jndiName", "jdbc/EcommerceDB");
		}
		return setting("db.url", DEFAULT_URL).replaceAll("\\?.*", "");
	}

	private static Connection open() throws SQLException {
		DataSource ds = lookupDataSource();
		if (ds != null) {
			return ds.getConnection();
		}
		String driver = setting("db.driver", "com.mysql.cj.jdbc.Driver");
		try {
			Class.forName(driver);
		} catch (ClassNotFoundException e) {
			throw new SQLException("JDBC driver " + driver + " is not on the classpath", e);
		}
		return DriverManager.getConnection(setting("db.url", DEFAULT_URL),
				setting("db.username", "root"), setting("db.password", ""));
	}

	private static DataSource lookupDataSource() {
		if (!jndiChecked) {
			synchronized (DBConnect.class) {
				if (!jndiChecked) {
					String name = setting("db.jndiName", "jdbc/EcommerceDB");
					if (name.trim().length() > 0) {
						try {
							dataSource = (DataSource) new InitialContext().lookup("java:comp/env/" + name);
							LOG.info("Using container DataSource from JNDI: java:comp/env/" + name);
						} catch (NamingException e) {
							LOG.info("No JNDI DataSource 'java:comp/env/" + name + "' - using db.url settings");
						} catch (RuntimeException e) {
							LOG.info("JNDI not available (" + e + ") - using db.url settings");
						}
					}
					jndiChecked = true;
				}
			}
		}
		return dataSource;
	}

	/** System property, then environment variable (db.url -> DB_URL), then db.properties, then default. */
	private static String setting(String key, String def) {
		String v = System.getProperty(key);
		if (v == null) {
			v = System.getenv(key.toUpperCase().replace('.', '_'));
		}
		if (v == null) {
			v = FILE_PROPS.getProperty(key);
		}
		return v != null ? v.trim() : def;
	}

	private static Properties loadFileProperties() {
		Properties p = new Properties();
		InputStream in = DBConnect.class.getClassLoader().getResourceAsStream("db.properties");
		if (in != null) {
			try {
				p.load(in);
			} catch (Exception e) {
				LOG.log(Level.WARNING, "Could not read db.properties", e);
			} finally {
				try {
					in.close();
				} catch (Exception ignored) {
				}
			}
		}
		return p;
	}
}
