# Network Scanner

A simple Bash-based network scanner for basic network and port scanning.

## Overview

`scanner.sh` is a Bash script created as part of my cybersecurity learning journey.

The scanner checks whether a target host is reachable, scans a user-defined range of TCP ports, identifies open and closed ports, and displays a basic service name for known ports.

## Features

* Target host input
* Target reachability check using `ping`
* Custom port range selection
* Port range validation
* TCP port scanning
* Parallel port scanning using background processes
* Basic service identification based on port numbers
* Scan duration measurement
* Automatic report generation
* Temporary files and directory cleanup

## Supported Services

The scanner currently has a basic lookup table for common ports:

| Port | Service    |
| ---- | ---------- |
| 21   | FTP        |
| 22   | SSH        |
| 23   | Telnet     |
| 25   | SMTP       |
| 53   | DNS        |
| 80   | HTTP       |
| 110  | POP3       |
| 143  | IMAP       |
| 443  | HTTPS      |
| 3306 | MySQL      |
| 5432 | PostgreSQL |
| 6379 | Redis      |
| 8080 | HTTP-Proxy |

Ports that are not included in the lookup table are displayed as `Unknown`.

## How It Works

The scanner follows this basic workflow:

```text
Start
  ↓
Ask for Target
  ↓
Check Target Reachability
  ↓
Ask for Port Range
  ↓
Validate Port Range
  ↓
Create Report Directory
  ↓
Create Temporary Directory
  ↓
Scan Ports in Parallel
  ↓
Collect Results
  ↓
Generate Report
  ↓
Cleanup
  ↓
End
```

## Requirements

* Linux
* Bash
* `ping`
* `timeout`
* `awk`

The script uses Bash's `/dev/tcp` feature to test TCP connections.

## Usage

Clone the repository:

```bash
git clone git@github.com:abdosharaf21/scanner.sh.git
```

Enter the project directory:

```bash
cd scanner-project
```

Make the script executable if necessary:

```bash
chmod +x scanner.sh
```

Run the scanner:

```bash
./scanner.sh
```

The script will ask for:

```text
Enter target host:
```

and then:

```text
Enter port range:
```

For example:

```text
127.0.0.1
```

and:

```text
1-100
```

## Reports

Scan results are automatically saved inside the `Reports` directory.

Example:

```text
Reports/
└── scan_127.0.0.1.txt
```

The report contains:

* Target
* Reachability status
* Port range
* Port state
* Basic service name
* Scan duration

## Project Status

**Current version:** Basic Network Scanner

This is an educational project focused on practicing:

* Bash scripting
* Variables
* User input
* Conditional statements
* Loops
* Associative arrays
* Background processes
* Parallel execution
* Temporary files
* File handling
* Basic network concepts
* TCP port scanning
* Report generation

Future improvements may extend the scanner with more advanced network and security assessment capabilities.

## Disclaimer

This project is intended for educational purposes and authorized security testing only.

Only scan systems and networks that you own or have explicit permission to test.

## Author

**Abdelrahman Sharaf**

Cybersecurity Student
