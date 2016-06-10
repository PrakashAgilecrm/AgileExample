<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="java.util.List" %>	
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Employee Details</title>
</head>
<body>
	<h4>Current Employee details.</h4>
	
	<%
	Entity emp =(Entity)request.getAttribute("emp");
	if(emp != null){
	%>
	
	ProjectId: <%= emp.getAppId() %><br>
	Kind Name: <%= emp.getKind() %><br>
	ID/Name: <%= emp.getKey().getId() %>/<%= emp.getKey().getName() %><br>
	First Name: <%= emp.getProperty("firstName") %><br>
	Last Name: <%= emp.getProperty("lastName") %><br>
	Designation: <%= emp.getProperty("designation") %><br>
	Indian: <%= emp.getProperty("isIndian") %><br>
	<%
	}
	%>
	
	<h4>All Employee details.</h4>
	<%
	List<Entity> list =(List<Entity>)request.getAttribute("list");
	for(Entity empl : list){
	%>
		ID/Name: <%= empl.getKey().getId() %>/<%= empl.getKey().getName() %><br>
		First Name: <%= empl.getProperty("firstName") %><br>
		Last Name: <%= empl.getProperty("lastName") %><br>
		Designation: <%= empl.getProperty("designation") %><br>
		Indian: <%= empl.getProperty("isIndian") %><br><br>
	<%
	}
	%>
	
	<h4>All Employee details using jstl tag</h4>
		<c:forEach items="${list}" var="usr">
	 	<table>
	 			<tr>
	        		<td>ID/Name :</td>
	        		<td>${usr.key.id}/${usr.key.name}</td>
	        	</tr>
	        	<tr>
	        		<td>First Name :</td>
	        		<td>${usr.properties.firstName}</td>
	        	</tr>
	        	<tr>
	        		<td>Last Name :</td>
	        		<td><c:out value="${usr.properties.lastName}" /></td>
	        	</tr>
	        	<tr>
	        		<td>Designation :</td>
	        		<td>${usr.properties.designation}</td>
	        	</tr>
	        	<tr>
	        		<td>Indian :</td>
	        		<td>${usr.properties.isIndian}</td>
	        	</tr>
	        </table>
	        <br>
	 </c:forEach>
	
</body>
</html>