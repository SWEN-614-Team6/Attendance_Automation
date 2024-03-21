import { Button, Modal, ModalHeader, ModalBody, ModalFooter,Form, FormGroup, Label, Input } from 'reactstrap';
import React from 'react';
import { useState, useRef } from 'react';
const uuid = require('uuid');

function App() {

  const [image, setImage] = useState('');
  const [classImage, setclassImage] = useState('');

  const [registerModal, setRegisterModal] = useState(false);
  const [updateModal, setUpdateModal] = useState(false);

  const [text_message,settext_message] = useState('');
  const [new_student_msg, setnew_student_msg] = useState('');

  const [studentlist, setstudentlist] = useState([]);

  const [selectedDate, setSelectedDate] = useState('');


  const toggleUpdateModal = () => {
    setUpdateModal(!updateModal);
    settext_message('');
  }

  const toggleRegisterModal = () => {
    setRegisterModal(!registerModal);
    setnew_student_msg('');

  }

  const handleSubmit = (event) => {
    event.preventDefault();

  const firstName = event.target.first_name.value;
  const lastName = event.target.last_name.value;
  const fileExtension = image.name.split('.').pop();
  event.target.first_name.value = '';
  event.target.last_name.value = '';

 const visitorImageName = `${firstName}_${lastName}.${fileExtension}`;

    fetch(`https://chcxp4zpi8.execute-api.us-east-1.amazonaws.com/dev5/register-new-student/${visitorImageName}`, {
    method : 'PUT',
    headers :  {
     // 'Content-Type' : 'image/jpeg'
     'Content-Type': `image/${fileExtension}`
    },
    body : image
   }).catch(error => {
    
    console.error(error);
   })
   setnew_student_msg('New Student added successfully');
  }

  const handleUpdateSubmit = (event) => {
    event.preventDefault();
   const visitorImageName = uuid.v4();
    
   const newfileExtension = classImage.name.split('.').pop();
   fetch(`https://chcxp4zpi8.execute-api.us-east-1.amazonaws.com/dev5/class/class-photos-bucket/${visitorImageName}`, {
    method : 'PUT',
    headers :  {
      'Content-Type': `image/${newfileExtension}`,
      'Origin': 'http://localhost:3000'
    },
    body : classImage
   }).then(async () => {
    const response = await authenticate(visitorImageName, newfileExtension);
    console.log(response);
    if(response.status === 'Success')
    {
     console.log(response.mylist);
     setstudentlist(response.mylist);
     settext_message(response.message);
      // settext_message(`${response['message']} :`);
    }
    else 
    {
      settext_message('Attendance Updation Failed');
    }
   }).catch(error => {
    console.error(error);
   })

  }
  
  async function authenticate(visitorImageName, newfileExtension)
  {
   const requestUrl = 'https://chcxp4zpi8.execute-api.us-east-1.amazonaws.com/dev5/studentidentify?'+ new URLSearchParams({
     objectKey : `${visitorImageName}`,
     date_of_attendance : `${selectedDate}`
   })
   return await fetch(requestUrl, {
     method : 'GET',
     headers : {
       'Accept' :'application/json',
       'Content-Type' : 'application/json',
       'Origin': 'http://localhost:3000'
     }
   }).then(response => response.json())
   .then ((data) => {
     return data;
   }).catch(error => console.error(error));
  
  }

  return (
   <div>
      
      <Button color="primary" onClick={toggleRegisterModal} >Add Student</Button>
       
      <Button color="primary" onClick={toggleUpdateModal}>Update Attendance</Button>

      <Modal isOpen={updateModal} toggle={toggleUpdateModal}>
        <ModalHeader toggle={toggleUpdateModal}>Upload Attendance</ModalHeader>
        
        <ModalBody>
          <Form onSubmit={handleUpdateSubmit}>
            <FormGroup>
              <Label for="upload_photo">Upload Class Photo</Label>
              <Input type='file' name='upload_photo' onChange={e => setclassImage(e.target.files[0])} />
            </FormGroup>

            <FormGroup>
              <Label for="date">Select Date</Label>
              <Input type='date' name='date' value={selectedDate} onChange={e => setSelectedDate(e.target.value)} />
            </FormGroup>

            
            <h3>{text_message}</h3>
            {studentlist.map((mylist, index) => (
                <p>{mylist.firstName} {mylist.lastName}</p>
            ))}


            <Button color='primary' type='submit'>Submit</Button>
          </Form>
        </ModalBody>
        <ModalFooter>
          <Button color="secondary" onClick={toggleUpdateModal}>Cancel</Button>
        </ModalFooter>

      </Modal>

      <Modal isOpen={registerModal} toggle={toggleRegisterModal}>
        <ModalHeader toggle={toggleRegisterModal}>Add Student's Details</ModalHeader>
        <ModalBody>

          <Form onSubmit={handleSubmit}>

            <FormGroup>
              <Label for="first_name">First Name</Label>
              <Input type="text" name="first_name" id="first_name" placeholder="Enter first name" />
            </FormGroup>

            <FormGroup>
              <Label for="last_name">Last Name</Label>
              <Input type="text" name="last_name" id="last_name" placeholder="Enter last name" />
            </FormGroup>

            <FormGroup>
              <Input type='file' name='image' onChange={e => setImage(e.target.files[0])} />
            </FormGroup>

            <FormGroup>
              <h3>{new_student_msg}</h3>
            </FormGroup>

            <Button color="primary" type="submit">Submit</Button>
          </Form>

        </ModalBody>
        <ModalFooter>
          <Button color="secondary" onClick={toggleRegisterModal}>Cancel</Button>
        </ModalFooter>
      </Modal>
       
   </div>
  );
}

export default App;
