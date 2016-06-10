<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="java.util.List" %>	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Employee Details</title>
</head>
<body>
	<h4>Employee details.</h4>
	<br>
	<%
	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	Query query = new Query("Employee").addSort("firstName", Query.SortDirection.ASCENDING);;
	List<Entity> users = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(10));
	if (users.isEmpty()) {
	%>
	    <p>no record found</p>
	<%
	} else {
	%>
	    <%
	    for (Entity user : users) {
	    %>
	        <table>
	        	<tr>
	        		<td>First Name :</td>
	        		<td><%= user.getProperty("firstName") %></td>
	        	</tr>
	        	<tr>
	        		<td>Last Name :</td>
	        		<td><%= user.getProperty("lastName") %></td>
	        	</tr>
	        	<tr>
	        		<td>Designation :</td>
	        		<td><%= user.getProperty("designation") %></td>
	        	</tr>
	        	<tr>
	        		<td>Indian :</td>
	        		<td><%= user.getProperty("isIndian") %></td>
	        	</tr>
	        </table>
	        <br>
	   <%
	    }//for
	}//else
	%>
	
</body>
</html>