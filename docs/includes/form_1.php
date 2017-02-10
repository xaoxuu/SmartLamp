<?php	
	if(empty($_POST['email']) && strlen($_POST['email']) == 0)
	{
		return false;
	}
	
	$email = $_POST['email'];
	
	$to = 'receiver@yoursite.com'; // Email submissions are sent to this email

	// Create email	
	$email_subject = "Message from smartlamp.";
	$email_body = "You have received a new message. \n\n".
				  "Email: $email \n";
	$headers = "MIME-Version: 1.0\r\nContent-type: text/plain; charset=UTF-8\r\n";	
	$headers .= "From: contact@yoursite.com\n";
	$headers .= "Reply-To: $email";	
	
	mail($to,$email_subject,$email_body,$headers); // Post message
	return true;			
?>