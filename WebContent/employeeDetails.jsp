<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="java.util.List" %>	
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Employee Details</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
	
  	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
  	<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
  	
<style type="text/css">
	 .pop{
	 	border: 1px solid #ff0000;
	  	border-radius: 5px;
	  	padding: 2px 6px;
	  	color: #ff0000;
	 }
	 
	 #tableId tr td{vertical-align: middle;}
	 
	 .center{text-align: center;}
</style>
<script type="text/javascript">

	function validateForm(){
		var flag = true;
		if($('#firstName').val().trim() == ''){
			$('#spn_firstName').html('Please enter First name');
			$('#spn_firstName').show();
			flag = false;
		}
		if($('#lastName').val().trim() == ''){
			$('#spn_lastName').html('Please enter Last name');
			$('#spn_lastName').show();
			flag = false;
		}
		if($('#designation').val().trim() == ''){
			$('#spn_designation').html('Please enter designation');
			$('#spn_designation').show();
			flag = false;
		}
		if($("[id^='isIndian_']").is(':checked') == false){
			$('#spn_isIndian').html('Please select one');
			$('#spn_isIndian').show();			
			flag = false;
		}
		return flag;
	}
	
	function removeError(event){
		$('#spn_'+event.name).html('');
		$('#spn_'+event.name).hide();
	}

	function removeAllError(){
		$("[id^='spn_']").html('');
		$("[id^='spn_']").hide();
		setDefault();
	}
	function setDefault(){
		$("#titleHeader").html("Add Employee");
		$("#empId").val("");
		$("#keyString").val("");
		$('#firstName').val("");
		$('#lastName').val("");
		$('#designation').val("");
		
		//$("[id^='isIndian_']").removeAttr('checked');
		$("[id^='isIndian_']").prop("checked",false);
		
		$("#empForm").attr("action","saveEmp");
		$("#submitValue").attr("onclick","return validateForm();");
		$("#submitValue").html("Save");
		$("#submitValue").removeClass("btn-danger");
		$(".table tr").each(function(i, tr){
			$(tr).children("td").find(":input[type='text']").removeAttr("disabled");
		});
	}
	
	function showModal_Update(val,empIdOrName, keyStr){
		var firstName = $("#firstName_"+val).html();
		var lastName = $("#lastName_"+val).html();
		var designation = $("#designation_"+val).html();
		var isIndian = $("#isIndian_"+val).html();
		
		$("#titleHeader").html("Update Employee");
		$("#empId").val(empIdOrName);
		$("#keyString").val(keyStr);
		$('#firstName').val(firstName);
		$('#lastName').val(lastName);
		$('#designation').val(designation);
		
		if(isIndian == "Yes"){
			//$("#isIndian_Yes").attr('checked', 'checked');
			$("#isIndian_Yes").prop("checked",true);
		}else{
			//$("#isIndian_No").attr('checked', 'checked');
			$("#isIndian_No").prop("checked",true);
		}
		
		$("#empForm").attr("action","updateEmp");
		$("#submitValue").html("Update");
		$("#myModal").modal();
	}
	
	function showModal_Delete(val,empIdOrName, keyStr){
		var firstName = $("#firstName_"+val).html();
		var lastName = $("#lastName_"+val).html();
		var designation = $("#designation_"+val).html();
		var isIndian = $("#isIndian_"+val).html();
		
		$("#titleHeader").html("Delete Employee");
		$("#empId").val(empIdOrName);
		$("#keyString").val(keyStr);
		$('#firstName').val(firstName);
		$('#lastName').val(lastName);
		$('#designation').val(designation);
		
		if(isIndian == "Yes"){
			//$("#isIndian_Yes").attr('checked', 'checked');
			$("#isIndian_Yes").prop("checked",true);
		}else{
			//$("#isIndian_No").attr('checked', 'checked');
			$("#isIndian_No").prop("checked",true);
		}
		
		$("#empForm").attr("action","deleteEmp");
		$("#submitValue").html("Delete");
		$("#submitValue").addClass("btn-danger");
		$("#submitValue").removeAttr("onclick");
		
		$(".table tr").each(function(i, tr){
			$(tr).children("td").find(":input[type='text']").attr("disabled","disabled");
		});
		$("#myModal").modal();
	}
	
</script>

</head>
<body>
	<br><br>
	<div class="container">
		<div class="col-md-12 well well-sm">
		  	<div class="col-md-6">
		  		<h4>Employee CURD using AppEng Datastore</h4>
		  	</div>
		  	<div class="col-md-6">
		 	 	<button type="button" class="btn btn-primary btn-small pull-right" data-toggle="modal" data-target="#myModal">Add&nbsp;<span class="glyphicon glyphicon-plus-sign"></span></button>
		 	</div>
  		</div>
  		
		<table class="table table-bordred table-striped" id="tableId">
		  <thead>
		    <tr>
		    	<th class="col-md-1">Sr.No.</th>
		      	<th class="col-md-2">ID/Name</th>
		     	<th class="col-md-2">First Name</th>
		      	<th class="col-md-2">Last Name</th>
		      	<th class="col-md-2">Designation</th>
		      	<th class="col-md-1 center">Indian</th>
		      	<th class="col-md-1 center">Edit</th>
		      	<th class="col-md-1 center">Delete</th>
		    </tr>
		  </thead>
		  <tbody>
		    <%
		    List<Entity> list =(List<Entity>)request.getAttribute("list");
		    if(list != null){
			%>
				<c:forEach items="${list}" var="emp" varStatus="stat">
		        	<tr>
		        		<td><c:out value="${stat.count}."/></td>
		        		<td id="idOrName_${stat.count}">
			        		<c:choose>
			        			<c:when test="${emp.key.id != 0}">
			        				${emp.key.id}
			        				<c:set var="idOrName" value="${emp.key.id}"/>
			        			</c:when>
			        			<c:otherwise>
			        				${emp.key.name}
			        				<c:set var="idOrName" value="${emp.key.name}"/>
			        			</c:otherwise>
			        		</c:choose>
		        		</td>
		        		<td id="firstName_${stat.count}">${emp.properties.firstName}</td>
		        		<td id="lastName_${stat.count}">${emp.properties.lastName}</td>
		        		<td id="designation_${stat.count}">${emp.properties.designation}</td>
		        		<td id="isIndian_${stat.count}" class="center">${emp.properties.isIndian}</td>
		        		
		        		<%
		        			Entity e = (Entity)pageContext.getAttribute("emp");
		        			Key k = e.getKey();
		        			String empKeyStr = KeyFactory.keyToString(k);
		        			pageContext.setAttribute("empKeyStr", empKeyStr);
		        		%>
		        		
		        		<td class="center">
							<button type="button" class="btn btn-primary btn-sm" onclick="showModal_Update('${stat.count}','${idOrName}','${empKeyStr}');" ><span class="glyphicon glyphicon-edit"></span></button>
		        		</td>
		        		<td class="center">
					      	<button type="button" class="btn btn-danger btn-sm" onclick="showModal_Delete('${stat.count}','${idOrName}','${empKeyStr}');"><span class="glyphicon glyphicon-trash"></span></button>
		        		</td>
		        	</tr>
			 	</c:forEach>
			 <%
		    	}
			 %>
		  </tbody>
		</table>
	</div>
	
	<!-- Modal -->
	<div id="myModal" class="modal fade" role="dialog">
	  <div class="modal-dialog modal-lg">
	    <!-- Modal content-->
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" onclick="removeAllError();" class="close" data-dismiss="modal">&times;</button>
	        <h4 class="modal-title" id="titleHeader">Add Employee</h4>
	      </div>
	      <form action="saveEmp" method="POST" id="empForm">
			<input type="hidden" name="empId" id="empId" value=""/>
			<input type="hidden" name="keyString" id="keyString" value=""/>
			<div class="modal-body">
				<div class="container">
					<div class="row">
				    	<div class="col-md-9">
				    		<table class="table table-hover table-bordered ">
								<tr>
								 	<th class="col-md-4" >First Name</th>
								 	<td class="col-md-8">
								 		<input type="text" name="firstName" id="firstName" onkeypress="removeError(this);" />
								  		<span class="pop" id="spn_firstName" style="display: none;"></span>
								 	</td>
								</tr>
								<tr>
									<th class="col-md-4" >Last Name</th>
									<td class="col-md-8">
										<input type="text" name="lastName" id="lastName" onkeypress="removeError(this);" />
								  		<span class="pop" id="spn_lastName" style="display: none;"></span>
									</td>
								</tr>
								<tr>
									<th class="col-md-4" >Designation</th>
									<td class="col-md-8">
										<input type="text" name="designation" id="designation" onkeypress="removeError(this);" />
								  		<span class="pop" id="spn_designation" style="display: none;"></span>
									</td>
								</tr>
								<tr>
									<th class="col-md-4" >IsIndian</th>
									<td class="col-md-8">
										<input type="radio" value="Yes" name="isIndian" id="isIndian_Yes" onclick="removeError(this);"/> Yes &nbsp;
										<input type="radio" value="No" name="isIndian" id="isIndian_No" onclick="removeError(this);"/>No
								  		<span class="pop" id="spn_isIndian" style="display: none;"></span>
									</td>
								</tr>
							</table>
						</div>
					</div>
				</div>
		      </div>
		      <div class="modal-footer">
		      	<button type="submit" class="btn btn-primary" onclick=" return validateForm();" id="submitValue" >Save</button>
		        <button type="button" onclick="removeAllError();" id="close" class="btn btn-default" data-dismiss="modal">Close</button>
		      </div>
	      </form>
	    </div>
	
	  </div>
	</div>
</body>
</html>