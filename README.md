# Aws Cloud Solutions Architect - SAA-C02

Guia de estudos para a certificação.
Mín. de pontos para aprovação: 710 pts.
Curso feito: Udemy - Stephane Mareek

# Indice de estudos
1. [IAM & Aws CLI](#IAM)
2. [EC2](#EC2)
    1. [Aws Global Infrastructure](#GlobalInfra)
	2. [Cloud Economics](#CloudEconomics)
	3. [Supporting Aws Infrastrtucture](#SupAwsInfra)
	4. [Cenários](#cenarios01)

## IAM & Aws CLI <a name="IAM"></a>
Identity and Access Management, is:

```
Global service
Root account is created by default
User is individual, can be grouped
Groups only contain users, not other groups
Policies = Json with permissions == Users or Groups
Least privilege principle
Inline Policie = permission direct to one user
```

CloudShell:
```
is the terminal in the Management Console
all the functionalities of Aws CLI
```

Roles:
```
Usuários que performam serviços precisam de permissões, a melhor prática é criar um Role.
Common roles:
	Ec2 Instances Role
	Lambda function
	Roles for CloudFormation
```

Security Tools:
```
IAM Credentials Report (account-level):
	lists all your account's users and thestatus of their credentials
	Audit permissions

IAM Access Advisor (user-level):
	Shows the service permissions granted to a user and when those services were last accessed.
	Great to revise policies.
```

Best Practices:
```
Não utilizar a root account.
Um usuario físico = um usuário aws
Strong password policy + MFA
Create Roles for giving permissions to Aws services
AccessKEys for Programmatic Access(CLI/SDK)
```

## EC2 <a name="EC2"></a>
Is one of the most popular of Aws' offering
EC2 = Elastic Compute Cloud - Infra as a Service:
```
Virtual  machines - EC2
Storing data on virtual drives - EBS
Distributing load across machines - ELB
Scaling the services using ASG(auto-scaling group)
```

EC2 sizing & Configuration options:
```
OS: linux, windows ow Mac OS
Compute power & cores  (CPU)
random-access memry (RAM)
Storage space:
	EBS & EFS - Network-attached
	Ec2 Instance Store - Hardware
Public Ip address
Firewal rules - Security group
Bootstrap script: User Data
```

EC2 User Data
```
Bootstrap our instance using an Ec2 User data script
Bootstrapping = running commands when machine starts
				executado uma vez quando a instancia inicia
				Install updates / softwares / common files from the internet
				run with root user
```

Instance Types
```
Naming convention: m5.2xlarge
				   m: instance class
				   5: generation
				   2xlarge: size within the instance class

General purpose: Balance with Compute x Memory x Networking
Compute optimized: possibilidade de alta performance de processamento como Media transcoding/high performance webservers/
				   high performance computing (HPC) / Scientific modeling & machine learning / dedicated gaming servers
				   C.
Memory Optimized
Storage Optimized: High, sequential read and write access to large data
```

Security Group:
```
Are the fundamental of network security in Aws.
Controll how traffic isallowed into or out of our EC2 
only contain ALLOW RULES
can reference by IP or others SG
They Regulate:
			Access to Ports
			Authorised IP ranges -Ipv4/6
			Control of inbound network (from other to the instance) - BLOCKED BY DEFAULT
			Control of outbount network (from the instance to the world) - AUTHORISED BY DEFAULT
			Can be attached to MULTIPLE instances
			Locked down to a region /VPC combination
			Does live "outside" the EC2
			It's good to maitain one separate SG for  ssh access

Classic Ports to know:
	22 = SSH ( Secure Shell ) - log into a Linux instance
	21 = FTP (File Transfer Protocol) - upload files using SSH
	80 = HTTP - access unsecure websites
	443 = HTTPS - access secure websites
	3389 = RDP (Remote Desktop Protocol) - log into a windows instance
```

SSH  Summary Table:
```
SSH is a utilitary command tools to connect into instances
Putty is availabily for Windows <10
Is one of  the most important function. It allows you to control a remote machine, all using the command line. 
EC2 Instance Connect works to connect by the console
```

EC2 Instances Purchasing Options
```
On-Demand Instances: short workloads, predictable pricing
					 Pay for what you use:
						Linux - billing per second, after the first minute
						all other - billing per hour
					 Has the highest cost but no upfront payment
					 No long-term commitment
					 Recommended for short-term and un-interrupted workloads
					 

Reserved: Min 1 YEAR
		Reserved Instances: long workloads, like DB
								Up to 75% discount compared to On-demand
								Reservation period: 1 year = +discount || 3 years = +++ discount
								Specific instance type	

		Convertible Reserved Instances: long workloads with flexible instances
										can change the EC2 instance type
										Up to 54% discount

		Schedule Reserved Instances: every Thursday between 3 ad 6 pm during 1 year.
	
Spot Instances: short workloads, cheap, can lose instances (less reliable - menos confiáveis)
				you can "lose" at any poitn of time 
				Discount of up to 90%
				The MOST cost-efficient instances
				Useful for workloads that are resilient to failure:
					batch jobs / Data analysis / Image processing / flexible starts and end
				NOT GREAT FOR CRITICAL JOBS
				Max spot price:get the instance while current spot price < max you can choose to stop or terminate your instance with a 2 min grace period.
				Spot Block: block sport instance ruing a specified time frame(1 to 6h) without interruptions
				How to terminate?
					First cancel  a Spot Requests, and then terminate the associated Spot Instance
					Only cancel Spot Instance requests that are OPEN, ACTIVE or DISABLED.

Spot Fleets: set of Spot Instances + (optional) On-Demand Instances
			 will try to meet the target capacity with price contraints
			 Define possible launch pools
			 Stops lauching instances when reaching capacity or max cost
			 Strategies to allocate:
			 	lowestPrice: from the pool with the lowest price (cost optimization, short workloads)
				diversified: distributed acrossall pools (great for availability, long worklads)
				capcaityOptimized: pool with the  optimal capacity for the number of instances
			 Allow us to automatically request Spot Instances with the lowest price

Dedicated Hosts: book an entire physical server, control isntance placement
				 Is a physical server with EC2 instance capacity fully dedicated to your use
				 Compliance requirements and use existing software licenses
				 3 year period reservation
				 more expensive
				 BYOL - Bring your own license

Dedicated Instances: instances running on hardware that's dedicated to you
					 may share hardware
					 no control over instance placement, can move hardware afterstop/start
			
```

Private x Public IP (IPv4):
```
IPv4: 1.160.1.240
	is still the most common format used online
	allows 3.7 bilions of options

Private Connectios can communicate with the public hosts between Internet Gateway(public) >> www
Public IP: means themachine can be identified on the internet (WWW)
		   Must be unique across the whole web
		   Can be geo-located easily

Private IP: means the machine can only be identified on a private network only
			the IP must be unique across the private network
			Machines connect to WWW using an internet gateway (proxy)
			Only a specified range of IPs can be used as private IP

Elastic IP: when you stop and then start an EC2, it can change its public IP
			if you need a FIXED PUBLIC IP for your instance == Elastic IP
			IPv4
			Mask the failure of an instance or  softwareby rapidly remapping the address to another instance.
			Only 5 Elastic IP by default.
			try avoid ElasticIP: instead, use a random public IP and registera DNS nameto  it
								 or, use a Load Balancer and don't use a public IP  
```

EC2 Placement Groups
```
When you want to control over the EC2 instance placement strategy
When you create, you specify one of the following:
	Cluster: clusters instances into a low-latency group in a single AZ
			 PRO: great network
			 Cons: If the rack fails, all instances fails at the same time
			 Use Case: Big DAta job that needs to complete  fast
			 		   App that needs extremely low latency and high network throughput

	Spread: spreads(propagação) instances across underlying hardware (max 7 instancer per group per AZ)
			critical applications
			PRO: Can span across AZ
				 Reduce risk in simultaneous failure
				 EC2 intancesareon differentphysical hardware
			Cons: Limited to 7 instances per AZ
			Use case: App that needts to maximize high availability
					  CriticalApp where each instancemust be isolatedfrom failure from each other

	Partition: spreads instances across many different partitions (which rely on different sets of racks) within an AZ.
			   Scales to 100s of EC2 instances per group
			   Use Case: Big Data applications = Hadoop, Cassandra,Kafka
			   Each partition represents a rack on Aws
			   Up to 7 partitions per AZ
			   Can span across multiple AZ in the same Region
			   Up to 100s of EC2
			   A partition failure can affect manu Ec2, but won't affect other partitions
			   EC2 get access to the partition information as  metadata

```

Elastic Network Interfaces (ENI):
```
Logical component ina VPC that represents a virtual network card
can have the following attributes:
	Primary privateIPv4, one or more secondary Ipv4
	One Elastic IP per private IPv4
	One Public Ip
	One or more security group
	A MAC address
Can create ENI independently and attach them on the EC2 for failover
Limitated to a specific AZ
```

EC2 Hibernate:
```
The in-memory (RAM) state is preservated
the instance  boot is much faster! (OS is not stopped / restarted)
The RAM state is written to a file in the root EBS vlume
The root EBS volume must be encrypted
Doesnt support all the instances families
RAM size bust be less tha 150GB
AMI:Linux AMi, Ubuntu,  Amazon...
Root volume: MUST be EBS, encrypted, not instance store, and large
Available for on-demand and Reserved Instances
An instance cannot be hibernated more than 60 days

Use cases:  long-running processing
			saving the RAm state
			services that take time to initialize

```

EC2 Nitro:
```
New virtualization technology
Allows for better perfomance:
	Better networking options
	Hight speed EBS, for 64K EBS IOPS
Better underlying security
Instance types: AI, C5...
			    Bare metal
```

vCPU:
```
Multipple threads can run on one CPU
Each thread is represented as a virtualCPU
Ex.: m5.2xlarge
	 4 CPU
	 2 threadsperCPU
	 => 8 vCPU in total

Can change the vCPU options:
	of CPU cores: decrease ir to decrease licensing costs
	of threads percore: disable multithreading to have 1 thread per CPU, helpful for HPC workloads
```

Ec2 Capacity Reservations:
```
ensure you have EC2 Capacity when needed
Manual or planned end-date for the reservation
No need 1 or 3 years commitment
Capacity access i immediate, you get billed as soon as it starts
Specify: the AZ in which toreservethecapacity
		 number of instances for which to reservecapacity
		 the intance attributes, including the instance  type, tenancy, OS
Combinewith Reserved Instances and SavingPlanstodo cost saving
```

EBS Volume:
```
Elastic Block Store Volume, is a network drive you can attach to your instances while they ryn
"Network USB stick":
					Can be detacged from an EC2 instand and attached to another
					have a provisioned capacity (size in GBs, and IOPS)
					Linked to an AZ
					pode ser adicionado mais EBS, contanto que esteja na mesma AZ.
Allows your instances to persist data, even after their termination
Can only be mounted to one instance at time, but exist multi-attach feature for some EBS
Bound to a specific AZ
Free tier: 30GB of free EBS storage type oftype SSD or Magnetic per month
Delete on termination Attribute:
	In creation, there as option.
	Controls the EBS behavior when an EC2 instance terminate
		By default, the root EBS volume is deleted
		By default, any other attachedEBSvolume is not deleted
	this  can be controlled bu Console/ CLI
	Use case: preserve root volume when instance is terminated, to save data. 

Volume Types:
	6 types:
		gp2/gp3 (SSD) = General purposethat balances price and performance
						Cost effective storage, low-lattency
						Case use: system boot volumes, virtual desktops, ddevelopment and test environments
						1  - 16 GB 
		io1 / io2 (SSD) = Highest-performancefor mission-critical low-latency or high-throughtput workloads
						  Case use: Databasesworkloads
						  			4 Gib - 16 Tib
									App that need more than 16K IOPS
									Max IOPS: 64K for Nitro EC2 & 32K for other
						  io2 Block Express ( 4 Gib - 64 Tib): sub-milisecond latency
						  									   MAxPIOPS: 256K with an IOPS:GiB ratio of 1L:1
						  Support EBS multi-attach
		st1 (HDD) = low Cost HDD designed for frequently accessed, throughput-intensive workloads
					Cannot be a boot volume
					125 Mib to 16 Tib
					Throughput Optimized HDD: Big Data, DAta warehouse, Log Proccessing
		sc1 (HDD) =  lowest cost volume designed for less frequently accessed workloads
					for data that is infrequently accessed
					Scenarios where lowest cost is important
					Max throughput 250Mib/s max IOPS 250

	Characterized in Size | Throughput | IOPS (I/O Ops per Sec)
	Only GP2/3 and io1/2 can be used as boot volume
```

EBS Snapshots:
```
Make a backup of your EBSvolume at a point in time
Not necessary to detach volume to do snapshot, but recommended
Can copy snapshots across AZ or Region
```

AMI - Amazon Machine Image:
```
AMI area customization of an EC2 instance:
	Your add your own software, configuration, Os...
	Faster boot, because the software is pre-built in
AMI are built for a specif region
You can  launch EC2 instances from:
	A Public AMI: Aws provider
	Your own AMI: you make and maintain them yourself
	An Aws Marketplace: an AMI someone else made ( and sells)
```

EC2 Instance Store
```
EBS volumes are network drives with good but "limited" performance
If you need a HIGH-PERFORMANCE hardware disk == Ec2 Instance Store
	Better I/O performance
	Lose their storafeif they're stopped(ephemeral)
	Good for buffer / cache / scratch data / temporary content
	Risk of data loss if hardware fails
	Backups and Replication are your responsability
```

EBS multi-attach - io1/io2 family
```
Attach the same EBS volume to multiple EC2 instancces in the same AZ
Each instance has full read & write permissionsto the volume
Use case:
	Achieve higher app availability in clustered Linux App (ex.: Teradata)
	App must manage concurrent writeoperations
Must use a file sys that's cluster-aware (not XFS, EX4..)
```

EBS Encryption:
```
When you created an encrypted EBS volume, you get:
	DAta at rest in encrypted inside the volume
	All the data in flight moving between the instance and thevolume is encrypted
	All snapshots are encrypted
Encryption and decryption are handled transparently (nothing to do)
Encryption has: minimal impact on latency
				leverages keys frorm KMS (AES-256)
				Copying an unencrypted snapshot allows encryption

Encrypt an Unencrypted EBS volume:
	Create an snapshot
	Encrypt the snapshot ( Actions > using copy)
	create new ebs volume from the snapshot encrypted
	now you can attach the ebs volume to an EC2
				
```

EBS RAID Options:
```
EBS is  already redundant storage (replicated within an AZ)
RAID is possible as long as your OS supports it, some options:
	RAID 0 (increase performance): Ec2 + one logical volume (+1EBS volume behind)
								   Combining 2 or more volumes and getting the total disk space
								   But one disk fails, all the data is failed
								   Use cases: an App that needts a lot of IOPS and doesn't need fault-tolerance
								   			  a database that has replication already built-in
											  using this, we can have big disk with a lot of IOPS

	RAID 1 (increase fault-tolerance): Mirroring a volume to another
									   If one disk fails, our logical volume is still working
									   We have to send the data to two EBS volume at the same time (2x network)
									   Use case: App that need increase volume fault tolerance
									   			 App where you need to service disks
	RAID 5/6 - (not recommended fo EBS)
```

EFS - Elastic File System:
```
Managed NFS (network file system) that can be mouted on many Ec2
Works with EC2 in multi-AZ
Highly available, scalable, expensive (3x gp2), pay per use, no capacity planning!
Use case: content management we serving, data sharing, Wordpress
		  use NFSc4 protocol
		  compatible withLinux base AMI (NOT WINDOWS)
Uses SG to control Access to EFS
encryption at rest using KMS

Performancce & Storage Classes:
	EFS Scale:  1K of concurrent NFS clients, 10 GB= /s throughput
				Can grow to Petabyte0scale network file system, automatically
	Performance Mode (set at EFS creation time): General purpose (default): latency-sensitive use cases (web server, CMS...)
												Max I/O - higher laency, throughtput, highly parallel (BIG DATA, MEDIA PROCESSING)
	Throughput mode: Bursting (1 TB = 50 Mib/s + burst of up to 100 Mib/s)
					 Provisioned: set your throughput regardless of storage size
	Storage Tiers: Lifecycle management feature - move file after N days
				   Standard: for frequently accessed files
				   Infrequent access (EFS-IA): cost to retrieve files, lower price to store
```

EFS x EBS:
```
EBS - one zone
EFS - multi-AZ
```