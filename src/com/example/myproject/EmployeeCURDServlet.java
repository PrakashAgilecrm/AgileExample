package com.example.myproject;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.PreparedQuery;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Query.Filter;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.datastore.Query.FilterPredicate;
import com.google.appengine.api.datastore.Transaction;


public class EmployeeCURDServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private List<Entity> users;
	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String userPath = request.getServletPath();
		if(userPath != null ){
			if (userPath.equalsIgnoreCase("/updateEmployee")) {
				updateEmp(request);
				response.getWriter().write("Employee Updated Successfully");
			}else if (userPath.equalsIgnoreCase("/deleteEmployee")) {
				deleteEmp(request);
				response.getWriter().write("Employee Deleted Successfully");
			}else if (userPath.equalsIgnoreCase("/saveEmployee")){
				saveEmp(request);
				response.getWriter().write("Employee Added Successfully");
			}else{
				empDetails(request, response);
			}
		}
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
	
	private void empDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		Query query = new Query("Employee").addSort("firstName", Query.SortDirection.ASCENDING);;
		users = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(40));
		
		RequestDispatcher dispatcher=request.getRequestDispatcher("/employeeDetailsWithAjax.jsp");
		request.setAttribute("list",users);
		dispatcher.forward(request, response);
	}
	
	private void saveEmp(HttpServletRequest request){
		String firstName = request.getParameter("firstName");  
		String lastName = request.getParameter("lastName");
		String designation = request.getParameter("designation");  
		String isIndian = request.getParameter("isIndian");
		
		Transaction txn = datastore.beginTransaction();
		Key empKey = KeyFactory.createKey("Employee", firstName);
		
		Entity employee = new Entity("Employee",empKey);
		employee.setProperty("firstName",firstName);
		employee.setProperty("lastName", lastName);
		employee.setProperty("designation", designation);
		employee.setProperty("isIndian", isIndian);
		datastore.put(employee);
		txn.commit();
	}
	private void updateEmp(HttpServletRequest request){
		String keyString = request.getParameter("keyString");
		
		Entity getEmp = getEntityByKeyString(keyString);
		if(getEmp != null){
			String firstName = request.getParameter("firstName");  
			String lastName = request.getParameter("lastName");
			String designation = request.getParameter("designation");  
			String isIndian = request.getParameter("isIndian");
			
			Transaction txn = datastore.beginTransaction();
			
			getEmp.setProperty("firstName",firstName);
			getEmp.setProperty("lastName", lastName);
			getEmp.setProperty("designation", designation);
			getEmp.setProperty("isIndian", isIndian);
			datastore.put(getEmp);
			
			txn.commit();
		}
	}
	private void deleteEmp(HttpServletRequest request){
		String keyString = request.getParameter("keyString");
		
		/*Entity getEmp = getEntityByKeyString(keyString);
		if(getEmp != null){
			datastore.delete(getEmp.getKey());
		}*/
		
		if(keyString != null && !keyString.trim().equalsIgnoreCase("")){
			Transaction txn = datastore.beginTransaction();
			Key key = KeyFactory.stringToKey(keyString.trim());
			datastore.delete(key);
			txn.commit();
		}
	}
	
	private Entity getEntityByKeyString(String keyStr){
		if(keyStr != null && !keyStr.trim().equalsIgnoreCase("")){
			
			Key key = KeyFactory.stringToKey(keyStr.trim());
			Entity getEmp = null;
			try {
				getEmp = datastore.get(key);
			} catch (EntityNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return getEmp;
		}
		return null;
	}


	public List<Entity> getUsers() {
		return users;
	}


	public void setUsers(List<Entity> users) {
		this.users = users;
	}

}
