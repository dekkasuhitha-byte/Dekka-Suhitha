-- ============================================================
--   HOSPITAL MANAGEMENT SYSTEM - SQL Project
--   Domain     : Healthcare
--   Author     : Suhitha
-- ============================================================


-- ============================================================
-- SECTION 1: DATABASE & TABLE CREATION
-- ============================================================

CREATE DATABASE IF NOT EXISTS HospitalDB;
USE HospitalDB;

-- 1. Departments
CREATE TABLE departments (
    dept_id       INT PRIMARY KEY AUTO_INCREMENT,
    dept_name     VARCHAR(100) NOT NULL UNIQUE,
    location      VARCHAR(100),
    head_doctor_id INT  -- FK added after doctors table
);

-- 2. Doctors
CREATE TABLE doctors (
    doctor_id     INT PRIMARY KEY AUTO_INCREMENT,
    first_name    VARCHAR(50)  NOT NULL,
    last_name     VARCHAR(50)  NOT NULL,
    specialization VARCHAR(100),
    dept_id       INT,
    phone         VARCHAR(15),
    email         VARCHAR(100) UNIQUE,
    hire_date     DATE,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Back-fill FK in departments
ALTER TABLE departments
    ADD CONSTRAINT fk_head_doctor
    FOREIGN KEY (head_doctor_id) REFERENCES doctors(doctor_id);

-- 3. Patients
CREATE TABLE patients (
    patient_id    INT PRIMARY KEY AUTO_INCREMENT,
    first_name    VARCHAR(50)  NOT NULL,
    last_name     VARCHAR(50)  NOT NULL,
    dob           DATE,
    gender        ENUM('Male','Female','Other'),
    blood_group   VARCHAR(5),
    phone         VARCHAR(15),
    email         VARCHAR(100),
    address       TEXT,
    registered_on DATE DEFAULT (CURRENT_DATE)
);

-- 4. Appointments
CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id     INT NOT NULL,
    doctor_id      INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status         ENUM('Scheduled','Completed','Cancelled') DEFAULT 'Scheduled',
    reason         TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id)  REFERENCES doctors(doctor_id)
);

-- 5. Medical Records
CREATE TABLE medical_records (
    record_id      INT PRIMARY KEY AUTO_INCREMENT,
    patient_id     INT NOT NULL,
    doctor_id      INT NOT NULL,
    appointment_id INT,
    diagnosis      TEXT,
    treatment      TEXT,
    notes          TEXT,
    record_date    DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (patient_id)     REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id)      REFERENCES doctors(doctor_id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

-- 6. Medicines
CREATE TABLE medicines (
    medicine_id   INT PRIMARY KEY AUTO_INCREMENT,
    medicine_name VARCHAR(150) NOT NULL,
    category      VARCHAR(100),
    unit_price    DECIMAL(10,2),
    stock_qty     INT DEFAULT 0
);

-- 7. Prescriptions
CREATE TABLE prescriptions (
    prescription_id INT PRIMARY KEY AUTO_INCREMENT,
    record_id       INT NOT NULL,
    medicine_id     INT NOT NULL,
    dosage          VARCHAR(100),
    duration_days   INT,
    FOREIGN KEY (record_id)    REFERENCES medical_records(record_id),
    FOREIGN KEY (medicine_id)  REFERENCES medicines(medicine_id)
);

-- 8. Rooms
CREATE TABLE rooms (
    room_id    INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(10) UNIQUE NOT NULL,
    room_type  ENUM('General','ICU','Private','Emergency'),
    dept_id    INT,
    is_occupied BOOLEAN DEFAULT FALSE,
    daily_rate  DECIMAL(10,2),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- 9. Admissions
CREATE TABLE admissions (
    admission_id   INT PRIMARY KEY AUTO_INCREMENT,
    patient_id     INT NOT NULL,
    doctor_id      INT NOT NULL,
    room_id        INT NOT NULL,
    admission_date DATE NOT NULL,
    discharge_date DATE,
    reason         TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id)  REFERENCES doctors(doctor_id),
    FOREIGN KEY (room_id)    REFERENCES rooms(room_id)
);

-- 10. Bills
CREATE TABLE bills (
    bill_id        INT PRIMARY KEY AUTO_INCREMENT,
    patient_id     INT NOT NULL,
    admission_id   INT,
    bill_date      DATE DEFAULT (CURRENT_DATE),
    room_charges   DECIMAL(10,2) DEFAULT 0,
    medicine_charges DECIMAL(10,2) DEFAULT 0,
    consultation_fee DECIMAL(10,2) DEFAULT 0,
    other_charges  DECIMAL(10,2) DEFAULT 0,
    total_amount   DECIMAL(10,2) GENERATED ALWAYS AS
                   (room_charges + medicine_charges + consultation_fee + other_charges) STORED,
    payment_status ENUM('Pending','Paid','Partial') DEFAULT 'Pending',
    FOREIGN KEY (patient_id)  REFERENCES patients(patient_id),
    FOREIGN KEY (admission_id) REFERENCES admissions(admission_id)
);


-- ============================================================
-- SECTION 2: SAMPLE DATA
-- ============================================================

INSERT INTO departments (dept_name, location) VALUES
('Cardiology',    'Block A, Floor 2'),
('Neurology',     'Block B, Floor 3'),
('Orthopedics',   'Block A, Floor 1'),
('Pediatrics',    'Block C, Floor 1'),
('General Medicine', 'Block D, Floor 1');

INSERT INTO doctors (first_name, last_name, specialization, dept_id, phone, email, hire_date) VALUES
('Ravi',    'Kumar',    'Cardiologist',    1, '9000000001', 'ravi.kumar@hospital.com',    '2018-06-15'),
('Priya',   'Sharma',   'Neurologist',     2, '9000000002', 'priya.sharma@hospital.com',  '2019-03-10'),
('Anil',    'Mehta',    'Orthopedic',      3, '9000000003', 'anil.mehta@hospital.com',    '2017-09-01'),
('Sunita',  'Verma',    'Pediatrician',    4, '9000000004', 'sunita.verma@hospital.com',  '2020-01-20'),
('Karthik', 'Nair',     'General Physician',5,'9000000005', 'karthik.nair@hospital.com',  '2021-07-05');

UPDATE departments SET head_doctor_id = 1 WHERE dept_id = 1;
UPDATE departments SET head_doctor_id = 2 WHERE dept_id = 2;
UPDATE departments SET head_doctor_id = 3 WHERE dept_id = 3;
UPDATE departments SET head_doctor_id = 4 WHERE dept_id = 4;
UPDATE departments SET head_doctor_id = 5 WHERE dept_id = 5;

INSERT INTO patients (first_name, last_name, dob, gender, blood_group, phone, email, address) VALUES
('Amit',    'Singh',   '1985-04-12', 'Male',   'O+',  '9100000001', 'amit@mail.com',    'Hyderabad'),
('Neha',    'Gupta',   '1992-08-25', 'Female', 'A+',  '9100000002', 'neha@mail.com',    'Bangalore'),
('Rahul',   'Joshi',   '1978-11-03', 'Male',   'B+',  '9100000003', 'rahul@mail.com',   'Chennai'),
('Divya',   'Rao',     '2000-01-15', 'Female', 'AB-', '9100000004', 'divya@mail.com',   'Pune'),
('Suresh',  'Patil',   '1965-06-22', 'Male',   'O-',  '9100000005', 'suresh@mail.com',  'Mumbai'),
('Lakshmi', 'Nair',    '1990-09-30', 'Female', 'A-',  '9100000006', 'lakshmi@mail.com', 'Hyderabad'),
('Vikram',  'Bose',    '1972-03-18', 'Male',   'B-',  '9100000007', 'vikram@mail.com',  'Kolkata'),
('Ananya',  'Das',     '1995-12-05', 'Female', 'O+',  '9100000008', 'ananya@mail.com',  'Delhi');

INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status, reason) VALUES
(1, 1, '2025-11-01', '10:00:00', 'Completed', 'Chest pain'),
(2, 2, '2025-11-02', '11:30:00', 'Completed', 'Severe headache'),
(3, 3, '2025-11-03', '09:00:00', 'Completed', 'Knee pain'),
(4, 4, '2025-11-04', '14:00:00', 'Completed', 'Fever'),
(5, 1, '2025-11-05', '10:30:00', 'Completed', 'Follow-up checkup'),
(6, 5, '2025-11-06', '12:00:00', 'Scheduled', 'General checkup'),
(7, 2, '2025-11-07', '15:00:00', 'Cancelled',  'Dizziness'),
(8, 3, '2025-11-08', '08:30:00', 'Scheduled', 'Back pain');

INSERT INTO medical_records (patient_id, doctor_id, appointment_id, diagnosis, treatment, record_date) VALUES
(1, 1, 1, 'Hypertension',             'Prescribed BP medication',   '2024-11-01'),
(2, 2, 2, 'Migraine',                 'Prescribed pain relievers',  '2024-11-02'),
(3, 3, 3, 'Knee Osteoarthritis',      'Physiotherapy recommended',  '2024-11-03'),
(4, 4, 4, 'Viral Fever',              'Rest and fluids advised',    '2024-11-04'),
(5, 1, 5, 'Coronary Artery Disease',  'Lifestyle changes + meds',  '2024-11-05');

INSERT INTO medicines (medicine_name, category, unit_price, stock_qty) VALUES
('Amlodipine 5mg',   'Antihypertensive', 12.50, 500),
('Paracetamol 500mg','Analgesic',         5.00, 1000),
('Ibuprofen 400mg',  'NSAID',             8.00, 800),
('Amoxicillin 250mg','Antibiotic',        15.00, 600),
('Metformin 500mg',  'Antidiabetic',      10.00, 700);

INSERT INTO prescriptions (record_id, medicine_id, dosage, duration_days) VALUES
(1, 1, '1 tablet twice daily', 30),
(2, 2, '1 tablet as needed',   7),
(3, 3, '1 tablet after meals', 14),
(4, 2, '1 tablet thrice daily',5),
(5, 1, '1 tablet once daily',  60);

INSERT INTO rooms (room_number, room_type, dept_id, is_occupied, daily_rate) VALUES
('101', 'General',   1, TRUE,  1500.00),
('102', 'ICU',       1, TRUE,  8000.00),
('201', 'Private',   2, FALSE, 4000.00),
('202', 'General',   2, TRUE,  1500.00),
('301', 'Emergency', 3, FALSE, 5000.00);

INSERT INTO admissions (patient_id, doctor_id, room_id, admission_date, discharge_date, reason) VALUES
(1, 1, 2, '2024-11-01', '2024-11-05', 'Hypertension management'),
(5, 1, 1, '2024-11-05', '2024-11-08', 'Cardiac monitoring'),
(2, 2, 4, '2024-11-02', '2024-11-04', 'Migraine treatment');

INSERT INTO bills (patient_id, admission_id, room_charges, medicine_charges, consultation_fee, other_charges, payment_status) VALUES
(1, 1, 32000.00, 375.00, 1000.00, 500.00, 'Paid'),
(5, 2,  4500.00, 750.00, 1000.00, 200.00, 'Partial'),
(2, 3,  3000.00, 175.00,  800.00, 100.00, 'Paid');


-- ============================================================
-- SECTION 3: ANALYTICAL SQL QUERIES
-- ============================================================

-- Q1. List all patients with their latest appointment and status
SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    a.appointment_date,
    a.status,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
WHERE a.appointment_date = (
    SELECT MAX(a2.appointment_date)
    FROM appointments a2
    WHERE a2.patient_id = p.patient_id
)
ORDER BY a.appointment_date DESC;


-- Q2. Total revenue per department
SELECT
    dep.dept_name,
    COUNT(DISTINCT b.bill_id)       AS total_bills,
    SUM(b.total_amount)             AS total_revenue,
    AVG(b.total_amount)             AS avg_bill_amount
FROM bills b
JOIN admissions adm ON b.admission_id = adm.admission_id
JOIN doctors doc     ON adm.doctor_id  = doc.doctor_id
JOIN departments dep ON doc.dept_id    = dep.dept_id
GROUP BY dep.dept_name
ORDER BY total_revenue DESC;


-- Q3. Doctors ranked by number of completed appointments
SELECT
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    d.specialization,
    dep.dept_name,
    COUNT(a.appointment_id) AS completed_appointments,
    RANK() OVER (ORDER BY COUNT(a.appointment_id) DESC) AS `rank`
FROM doctors d
JOIN appointments a    ON d.doctor_id = a.doctor_id AND a.status = 'Completed'
JOIN departments dep   ON d.dept_id   = dep.dept_id
GROUP BY d.doctor_id, d.first_name, d.last_name, d.specialization, dep.dept_name;


-- Q4. Patients admitted but not yet discharged (currently admitted)
SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    r.room_number,
    r.room_type,
    adm.admission_date,
    DATEDIFF(CURRENT_DATE, adm.admission_date) AS days_admitted
FROM admissions adm
JOIN patients p ON adm.patient_id = p.patient_id
JOIN rooms r    ON adm.room_id    = r.room_id
WHERE adm.discharge_date IS NULL;


-- Q5. Most prescribed medicines
SELECT
    m.medicine_name,
    m.category,
    COUNT(pr.prescription_id) AS times_prescribed,
    SUM(pr.duration_days)     AS total_prescription_days
FROM prescriptions pr
JOIN medicines m ON pr.medicine_id = m.medicine_id
GROUP BY m.medicine_id, m.medicine_name, m.category
ORDER BY times_prescribed DESC;


-- Q6. Monthly appointment trend
SELECT
    YEAR(appointment_date)  AS year,
    MONTH(appointment_date) AS month,
    MONTHNAME(appointment_date) AS month_name,
    COUNT(*)                AS total_appointments,
    SUM(CASE WHEN status = 'Completed'  THEN 1 ELSE 0 END) AS completed,
    SUM(CASE WHEN status = 'Cancelled'  THEN 1 ELSE 0 END) AS cancelled,
    SUM(CASE WHEN status = 'Scheduled'  THEN 1 ELSE 0 END) AS scheduled
FROM appointments
GROUP BY year, month, month_name
ORDER BY year, month;


-- Q7. Patient billing summary with outstanding amounts
SELECT
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    b.bill_date,
    b.total_amount,
    b.payment_status,
    CASE
        WHEN b.payment_status = 'Paid'    THEN 0
        WHEN b.payment_status = 'Partial' THEN b.total_amount * 0.5
        ELSE b.total_amount
    END AS estimated_due
FROM bills b
JOIN patients p ON b.patient_id = p.patient_id
ORDER BY estimated_due DESC;


-- Q8. Rooms occupancy report
SELECT
    r.room_type,
    COUNT(*)                                     AS total_rooms,
    SUM(CASE WHEN r.is_occupied THEN 1 ELSE 0 END) AS occupied,
    SUM(CASE WHEN NOT r.is_occupied THEN 1 ELSE 0 END) AS available,
    ROUND(
        100.0 * SUM(CASE WHEN r.is_occupied THEN 1 ELSE 0 END) / COUNT(*), 2
    )                                            AS occupancy_rate_pct
FROM rooms r
GROUP BY r.room_type;


-- Q9. Patients with multiple admissions (readmission analysis)
SELECT
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.blood_group,
    COUNT(adm.admission_id) AS total_admissions
FROM patients p
JOIN admissions adm ON p.patient_id = adm.patient_id
GROUP BY p.patient_id, patient_name, p.blood_group
HAVING COUNT(adm.admission_id) > 1
ORDER BY total_admissions DESC;


-- Q10. Department-wise doctor count and average experience (years)
SELECT
    dep.dept_name,
    COUNT(d.doctor_id)                           AS doctor_count,
    ROUND(AVG(DATEDIFF(CURRENT_DATE, d.hire_date) / 365.25), 1) AS avg_experience_years,
    GROUP_CONCAT(CONCAT(d.first_name, ' ', d.last_name) SEPARATOR ', ') AS doctors
FROM departments dep
JOIN doctors d ON dep.dept_id = d.dept_id
GROUP BY dep.dept_id, dep.dept_name
ORDER BY doctor_count DESC;


-- ============================================================
-- SECTION 4: VIEWS FOR REPORTING
-- ============================================================

-- View 1: Patient full profile with latest visit
CREATE OR REPLACE VIEW vw_patient_summary AS
SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.gender,
    p.blood_group,
    p.phone,
    COUNT(DISTINCT a.appointment_id)   AS total_appointments,
    COUNT(DISTINCT adm.admission_id)   AS total_admissions,
    MAX(a.appointment_date)            AS last_visit
FROM patients p
LEFT JOIN appointments a   ON p.patient_id = a.patient_id
LEFT JOIN admissions adm   ON p.patient_id = adm.patient_id
GROUP BY p.patient_id, patient_name, p.gender, p.blood_group, p.phone;

-- View 2: Doctor workload overview
CREATE OR REPLACE VIEW vw_doctor_workload AS
SELECT
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    d.specialization,
    dep.dept_name,
    COUNT(DISTINCT a.appointment_id)  AS total_appointments,
    COUNT(DISTINCT adm.admission_id)  AS total_admissions,
    COUNT(DISTINCT mr.record_id)      AS medical_records_created
FROM doctors d
LEFT JOIN departments dep  ON d.dept_id  = dep.dept_id
LEFT JOIN appointments a   ON d.doctor_id = a.doctor_id
LEFT JOIN admissions adm   ON d.doctor_id = adm.doctor_id
LEFT JOIN medical_records mr ON d.doctor_id = mr.doctor_id
GROUP BY d.doctor_id, doctor_name, d.specialization, dep.dept_name;
