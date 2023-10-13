import { LightningElement, track } from 'lwc';

export default class HospitalMgt extends LightningElement {
@track currentContent = 'PatientRegistration';
@track PatientRValue = false;    
@track AppointmentValue = false;
@track PatientValue = false;
@track DoctorValue = false;
@track MedicalRecordValue = false;
@track PharmacySystemsValue = false;
@track AnalyticsValue = false;


changeHandleAction(event) {
    const selected = event.detail.name;        

    this.currentContent = selected;

    if (selected == 'PatientRegistration'){
        this.PatientRValue = true;
    }else{
        this.PatientRValue = false;
    }
    if (selected == 'Appointment'){
        this.AppointmentValue = true;
    }else{
        this.AppointmentValue = false;
    }
    if (selected == 'Patient'){
        this.PatientValue = true;
    }else{
        this.PatientValue = false;
    }
    if (selected == 'Doctor'){
        this.DoctorValue = true;
    }else{
        this.DoctorValue = false;
    }
    if (selected == 'MedicalRecord'){
        this.MedicalRecordValue = true;
    }else{
        this.MedicalRecordValue = false;
    }
    if (selected == 'visuaPharmacySystemslforce'){
        this.PharmacySystemsValue = true;
    }else{
        this.PharmacySystemsValue = false;
    }
    if (selected == 'Analytics'){
        this.AnalyticsValue = true;
    }else{
        this.AnalyticsValue = false;
    }
}
}