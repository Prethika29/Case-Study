create database CARS;
use CARS;

-- Table: Law Enforcement Agencies
create table law_enforcement_agencies (
    agency_id int auto_increment primary key,
    agency_name varchar(100),
    jurisdiction varchar(100),
    contact_info text
);

-- Table: Officers
create table officers (
    officer_id int auto_increment primary key,
    first_name varchar(50),
    last_name varchar(50),
    officer_name varchar(100) generated always as (concat(first_name, ' ', last_name)),
    badge_number varchar(20) unique,
    ranks varchar(50),
    contact_info text,
    agency_id int,
    foreign key (agency_id) references law_enforcement_agencies(agency_id)
);

-- Table: Victims
create table victims (
    victim_id int auto_increment primary key,
    first_name varchar(50),
    last_name varchar(50),
    victim_name varchar(100) generated always as (concat(first_name, ' ', last_name)),
    date_of_birth date,
    gender enum('male', 'female', 'other'),
    contact_info text
);

-- Table: Suspects
create table suspects (
    suspect_id int auto_increment primary key,
    first_name varchar(50),
    last_name varchar(50),
    suspect_name varchar(100) generated always as (concat(first_name, ' ', last_name)),
    date_of_birth date,
    gender enum('male', 'female', 'other'),
    contact_info text
);

-- Table: Incidents (No direct victim_id or suspect_id)
create table incidents (
    incident_id int auto_increment primary key,
    incident_type varchar(50),
    incident_date datetime,
    latitude decimal(9,6),
    longitude decimal(9,6),
    incident_description text,
    incident_status enum('open', 'closed', 'under investigation'),
    officer_id int,
    agency_id int,
    foreign key (officer_id) references officers(officer_id),
    foreign key (agency_id) references law_enforcement_agencies(agency_id)
);

-- Many-to-Many Junction Table: Incident & Victims
create table incident_victims (
    incident_id int,
    victim_id int,
    primary key (incident_id, victim_id),
    foreign key (incident_id) references incidents(incident_id),
    foreign key (victim_id) references victims(victim_id)
);

-- Many-to-Many Junction Table: Incident & Suspects
create table incident_suspects (
    incident_id int,
    suspect_id int,
    primary key (incident_id, suspect_id),
    foreign key (incident_id) references incidents(incident_id),
    foreign key (suspect_id) references suspects(suspect_id)
);

-- Table: Evidence
create table evidence (
    evidence_id int auto_increment primary key,
    evidence_description text,
    location_found varchar(100),
    incident_id int,
    foreign key (incident_id) references incidents(incident_id)
);

-- Table: Reports
create table reports (
    report_id int auto_increment primary key,
    incident_id int,
    foreign key (incident_id) references incidents(incident_id),
    reporting_officer int,
    foreign key (reporting_officer) references officers(officer_id),
    report_date date,
    report_details text,
    report_status enum('draft', 'finalized')
);

-- Insert: Law Enforcement Agencies
insert into law_enforcement_agencies (agency_name, jurisdiction, contact_info) values
('Delhi Police', 'Delhi', 'delhi.police@gov.in,9876543210'),
('Mumbai Police', 'Mumbai', 'mumbai.police@gov.in, 9012345678'),
('Chennai Police', 'Chennai', 'chennai.police@gov.in, 9123456780'),
('Kolkata Police', 'Kolkata', 'kolkata.police@gov.in, 8907654321'),
('Bangalore Police', 'Bangalore', 'bangalore.police@gov.in, 8097654321');
select * from law_enforcement_agencies;

-- Insert: Officers
insert into officers (first_name, last_name, badge_number, ranks, contact_info, agency_id) values
('Raj', 'Verma', 'IND1001', 'Inspector', 'raj.verma@police.in, 89012345678', 1),
('Ravi', 'Patel', 'IND1002', 'Sub Inspector', 'ravi.patel@police.in, 7890654321', 2),
('Vikram', 'Reddy', 'IND1003', 'Constable', 'vikram.reddy@police.in, 7098654321', 3),
('Amit', 'Singh', 'IND1004', 'Head Constable', 'amit.singh@police.in, 7654321890', 4),
('Arjun', 'Das', 'IND1005', 'DSP', 'arjun.das@police.in, 7123456890', 5);
select * from officers;

-- Insert: Victims
insert into victims (first_name, last_name, date_of_birth, gender, contact_info) values
('Suresh', 'Sharma', '1992-05-10', 'male', 'suresh.sharma@gmail.com, 7890123456'),
('Rahul', 'Kumar', '1988-11-25', 'male', 'rahul.kumar@gmail.com, 6123457890'),
('Ajay', 'Nair', '1995-03-18', 'male', 'ajay.nair@gmail.com, 6234578901'),
('Amit', 'Joshi', '1984-07-14', 'male', 'amit.joshi@gmail.com, 6345789012'),
('Kiran', 'Mehta', '2000-09-30', 'male', 'kiran.mehta@gmail.com, 6543217890');
select * from victims;

-- Insert: Suspects
insert into suspects (first_name, last_name, date_of_birth, gender, contact_info) values
('Rohan', 'Yadav', '1990-02-20', 'male', 'rohan.yadav@gmail.com, 6789012345'),
('Sunil', 'Bhat', '1993-06-12', 'male', 'sunil.bhat@gmail.com, 7654321890'),
('Manoj', 'Mishra', '1980-10-05', 'male', 'manoj.mishra@gmail.com, 7568904321'),
('Anil', 'Rao', '1997-01-25', 'male', 'anil.rao@gmail.com, 7412356890'),
('Deepak', 'Sen', '2002-04-11', 'male', 'deepak.sen@gmail.com, 7312456890');
select * from suspects;

-- Insert: Incidents (excluding victim/suspect for now)
insert into incidents (incident_type, incident_date, latitude, longitude, incident_description, incident_status, officer_id, agency_id) values
('Mobile Theft', '2023-06-10', 28.613939, 77.209023, 'Mobile stolen at market', 'open', 1, 1),
('Street Fight', '2023-07-15', 19.076090, 72.877426, 'Small fight near bus stop', 'closed', 2, 2),
('House Break', '2023-08-01', 13.082680, 80.270718, 'House lock broken at night', 'under investigation', 3, 3),
('Wall Damage', '2023-09-20', 22.572646, 88.363895, 'Wall painted with spray', 'open', 4, 4),
('Cash Robbery', '2023-10-05', 12.971599, 77.594566, 'Cash taken from shop', 'closed', 5, 5);
select * from incidents;

-- Insert: Incident-Victim mapping
insert into incident_victims (incident_id, victim_id) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);
select * from incident_victims;


-- Insert: Incident-Suspect mapping
insert into incident_suspects (incident_id, suspect_id) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);
select * from incident_suspects;

-- Insert: Evidence
insert into evidence (evidence_description, location_found, incident_id) values
('Phone case found', 'Market area', 1),
('Wood stick found', 'Near footpath', 2),
('Broken lock', 'House gate', 3),
('Spray can', 'Wall corner', 4),
('Cash bag found', 'Suspect room', 5);
select * from evidence;

-- Insert: Reports
insert into reports (incident_id, reporting_officer, report_date, report_details, report_status) values
(1, 1, '2023-06-11', 'Phone case under check', 'draft'),
(2, 2, '2023-07-16', 'Fight ended, case closed', 'finalized'),
(3, 3, '2023-08-02', 'House break checked', 'draft'),
(4, 4, '2023-09-21', 'Wall issue noted', 'draft'),
(5, 5, '2023-10-06', 'Robbery confirmed', 'finalized');
select * from reports;