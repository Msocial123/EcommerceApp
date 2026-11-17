package com.conn;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;

/**
 * Closes the JDBC connections that servlets and JSPs opened with {@link DBConnect#getConn()}
 * once the request has finished, so connections are returned to the pool instead of leaking.
 *
 * <p>Runs only for the original REQUEST dispatch, so connections stay open through any
 * forward or include and are closed after the whole request is done.</p>
 */
@WebFilter(filterName = "ConnectionCleanupFilter", urlPatterns = "/*")
public class ConnectionCleanupFilter implements Filter {

	public void init(FilterConfig filterConfig) {
	}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		try {
			chain.doFilter(request, response);
		} finally {
			DBConnect.closeThreadConnections();
		}
	}

	public void destroy() {
	}
}
