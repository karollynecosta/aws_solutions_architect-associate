# Aws Cloud Solutions Architect - SAA-C02

Guia de estudos para a certificação.
Mín. de pontos para aprovação: 710 pts.
Curso feito: Udemy - Stephane Mareek

# Indice de estudos
1. [IAM & Aws CLI](#IAM)
2. [EC2](#EC2)
3. [High Availability and Scalability: ELB & ASG](#ELB+ASG)
4. [Aws Fundamentals - RDS + Aurora + ElastiCache](#RDSAuroraElasti)

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
	Case use: high-performance database that requires an IOPS of 210,000 for its underlying filesystem
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
EBS - one zone, one instance at time,
EFS - multi-AZ, multi instances linux at time, share website files, more expensive, pay per use.
```

## ELB & ASG <a name="ELB+ASG"></a>

Concepts:
1 - Scalability:
```
Means that an application can handle greater loads by adapting
Can be:
	Vertical Scalability: increasing the SIZE of the instance
						  is very commom for non distrtibuited systems, such as database
						  RDS, ElastiCache
						  Has a hardware limity

	Horizontal Scalability(= elasticity): increase the NUMBER of instances for the app
										  implies distributed systems
										  web app/ moderns app
```

2 - High Availability
```
Means that you are running your app in at least 2 DC/AZ
The goal is to survive a DC loss
Can be:
	Passive: RDS Multi AZ
	Active: horizontal scaling
```

3 - Load Balancing
```
Are servers that forward traffic to multiple servers (EC2) downstream
Why use?
	Spread load across multiple downstream instances
	Expose a single point of access to your app
	Do regular health checks to your instances
	Provide SSL termination (HTTPS)
	enforce stickiness with cookies
	HA across zones
	Separate public traffic from private traffic
```

Elastic Load Balancer - ELB:
```
Is a managed load balancer: Aws guarentees that it will be  working
							It costs less to setup your own load balancer but it well be a lot more effort
							It is integrated with manu Aws offerings / services
							Provide static DNS

Health Checks: are crucial, checa se a instances consegue receber o trafego ou não
			   They enable to know if instances it forwards traffic to  are available to reply to requests
			   Is done on a port and a route
			   If the response is not 200, the EC2 is unhealthy 

4 Types of ELB:
	Classic Load Balancer (v1 - old generation) - 2009 - CLB:
		Supports TCP (layer 4)
		Http & Https (layer 7)
		Health checks are TCP or HTTP based
		fixed hostname: xxx.region.elb.amazonaws.com

	Application Load Balancer (v2 - new generation) - 2016 - ALB: 
		Is layer 7 HTTPS
		Load balancing to  multiple HTTP applications across machines(target groups) and to the same machine(containers)
		Support for HTTP/2 and WebSocket
		Support redirects from HTTP to HTTPS
		Routing tables to diff target groups: 
			based on path in URL
			on hostname in URL
			on Query string/Headers
		Are great fit for Micro services & container-based app (Docker & amazon ECS)
		Has a port mapping feature toredirect to a dynamic port in ECS
		www --> route/user->External ALB --> Http-> Target Group
		Target Groups: Ec2 instances (can be Auto Scaling Group) - HTTP
					   EC2 tasks (managed by ECS) - HTTP
					   LambdaFunctions - Http request is translated into a JSON event
					   IP Addresses - must be private IP
					   ALB can route to multiple target groups
					   Healthy check by the group
		Have fixed hostname
		The ALB don't see the IP of the client directly, they are inserted in the header X-Forwarded-For
		X-Forwarded-Port X-Forwarded-Protocol are available in the header too.

	Network LoadBalancer (v2) - 2017 - NLB:
		Layer 4 allow to:
			Forward TCP & UDP traffic to your instancces
			Handlemilions of request  per second
			less latency 
		Has one static IP per AZ, supports assigning Elastic IP
		Are usedfor extreme performance, TCP or UDP traffic
		Not included in Aws free tier
		
	Gateway LB - 2020 - GWLB: Layer 3 - IP Protocol
		makes it easy to deploy, scale, and manage your third-party virtual appliances. It gives you one gateway for distributing traffic across multiple virtual appliances, while scaling them up, or down, based on demand. This eliminates potential points of failure in your network and increases availability.

Can be: private or public

Security Groups:
Users --> HTTPS/HTTP from anywhere -> SG --> Http Restricted to ALB(allow traffic only from ELB) --> EC2

Sticky Sessions (session affinity/ sessões fixadas): CACHE DE COOKIES
	implement stickiness(ligação) so that the same client is always redirected to the same instance behind a load balancer
	works for CLB& ALB
	Work with the "cookie" used for stickiness has an expiration date. They are:
		Application-based Cookies: 
			Custom  cookie: generated by the target
							Can incluse any custom attributes required by app
							Cookie name must be specified individually for each target group
							Don't use AWSALB, AWSALBAPP, AWSALBTG -- reserved by ELB
			Application cookie: Generated by the load balancer
								Cookie name is AWSALBAPP
		
		Duration-based Cookies: Cookie generated by the load balancer
								Cookie name isAWSALB for ALB, AWSELB for CLB
	Use case: make sure the user doesn't lose session data
			  
Cross-Zone Load Balancing:
	Each load balancer instance distributes evenly across all registered instances in all AZ.
	ALB: Always on
		 No chargesfor inter AZ data
	
	NLB: Disabled by default
		 You pay charges for inter AZ data if enabled
	
	CLB: Console: Enabled by default
		 CLI/API: Disabled by default
		 No charges for inter AZ data

SSL/TLS: 
	An SSL Certificate allows traffic between your clients and your load balancer to be encrypted in transit(in-flight encryption)
	SSL refers to Secure Sockets Layer,used to encrypt connections

	TLS refers to Transport Layer Security, which is a newer version, are mainly used(mais usados)

	Public SSl certificates are issued by CA(Comodo, GoDaddy, letsencrypt...), have an expiration date and reniewd
	Load Balancer uses an X.509 certificate(SSL/TLS server certificate)
	You can manage certificates using ACM(Aws Certificate Manager) or upload your own
	
	HTTPS Listener: You must specify a default certificate or an list of certs to multiple domain
					Clients can use SNI(Server Name INdication) to specify the hostname they reach
					Ability to specify a security policy to support older version of SSL/TLS
	
	SNI: solves the problem of loadinf multiple SSL certificates onto  one  web server
		 It's a newer protocol, and requires the client to indicate the hostname of the target server in the initial SSL handshake
		 The server will then find the correct certificate, or return the default one
		 Works for ALB & NLB & CloudFront
	
	Certificates resume: CLB(v1) ==> Only one SSL certificate
						 ALB(v2) + NLB == multiple listeners with multiple SSL cert, uses SNI to make it work
						 
Connection Draining:
	Feature naming: CLB = Connection Draining
					ALB & NLB = Deregistration Delay
	Give some time to complete "in-flight requests" while the EC2 is de-registering/unhealthy
	Stops sending new requests to the EC2 which is unhealthy
	Between 1 to 3600 sec (default: 300 sec)
	Can be disabled (set value 0)
	Set to a low value if your requests are short	

Auto Scaling Group - ASG: 
	Scale out(add EC2 inst) to match an increased load
	Sclae in (remove Ec2) to match a decreased load
	Ensure we have a min and a max number of machines running
	Automatically register new instances to a load balancer
	Have: A Launch configuration(AMI + Instance type, User Data, EBS vol, SG, SSH key pair)
		  Min Size/ MAx Size/ Initial Capacity
		  Network + Subnets information
		  Load Balancer Information
		  Scaling Policies
	
	Auto Scaling Alarms: It is possible to scale an ASG based on CloudWatch alarms
						 An alarm monitors metrics (average CPU)
						 Can create scale-out or scale-in policies
	
	ASG Brain Dump: scalingpolicie can even be on custom metrics or based on a schedule (if you know tour visitors patterns)
					ASG use Launch configurations or Launch Templates
					To update an ASF, you must provide a new launch conf
					IAM roles attached to an ASG will get assigned to EC2
					ASG are free. You pay for the  underlying resources being launched
					ASG can terminate instances marked as unhealthy by an LB (and replace them automatically)
	
	Dynamic Scaling Policies:
		Target Tracking Scaling: easy to set-up, Ex.: average CPU stay at around 40%
		Simple / Step Scaling: When a CloudWatch alarmis triggered (CPU>70%), then add 2 units
		Schedule Actions: Anticipate ascaling basedon known usage patterns. ex.: increase the min capacity to 10 at 12pm Fridays.
	
	Predictive Scaling:
		Continuously forecast load and schedule scaling ahead
	
	Good metrics to scale on: CPUUtilization: Average CPU
							  RequestCountPerTarget: make sure the number of requests per  EC2 is stable
							  Average NetworkIn/Out

	Scaling Cooldowns(esfriamento):
		after scaling activity happens, you are in the cooldown period == 300 seconds
		during the cooldown, the ASG will not launch or terminate additional ec2
		Use a ready-to-use AMI to reduce configuration time
	
	ASG Default Termination Policy: 1. Find the AZ which has the most number of instances
									2. If there are multiple instances in the AZ to choose from, delete the one with the oldest launch conf
									3. ASG tries the balance the number of instances across AZ by default.

	Lifecycle Hooks: By default as soon as instance is launched in an ASG it's in service
				     You have the ability to perform extra  steps before the instance goes in service (pending  state) and before the instance is terminated(terminated)
	
	Launch Template vs Launch COnfiguration:
		Both: Id of the AMI, instance type, key pair, SG, tags, user data...
		Launch conf(legacy):Must be re-created every time
		Launch Template (newer): Can have multiple versions
								 Create  parameters subsets (partial confforre-use and inheritance)
								 Provisioning using both On-Demand and Spot (or mix)
								 Can use T2 and  is recommended by Aws.
```

## RDS + Aurora + ElastiCache <a name="RDSAuroraElasti"></a>

RDS:
```
Relational DAtabase Service
It's a managed DB service for DB use SQL as query language
Can be: Postgres, MySQL, MAriaDB,Oracle,SQL server, Aurora(aws proprietary database)

Advantage of RDS vs EC2:
	RDS is a managed service:	
		Automated provisioning, OS patching
		countinuous backup and restore to specific timespamt (Point in Time Restore)
		monitoring dashboard
		scaling capacity - vertical or horizontal

		But you CAN'T access throught SSH

RDS Backups:
	Are automaticaly enabled in RDS
	Daily full backup of the databse
	Transaction logs are backed-up by RDS every 5 min
	ability to restore any point in time
	7 days retention (can be 35 days)

DB Snapshots:
	Manually trirggered by the user
	Retention of backup for as long as you want

Store Auto Scaling:
	Helps you increase storage on your RDS dynamically
	When RDS detects you are running out of free database storage, it scales automatically
	Avoid manually scaling your DB store
	You have to set Maximum Storage Threshold
	Automatically modify storage if:
		Free storage is less than 10% of allocated storage
		Low storage lasts at least 5 min
		5 hours have passed since last modification
	Useful for app with unpredictable workloads
	Supports all RDS engines

Read Replicas: **important**
	Help to scale your read/write capacity
	Up to 5 read replicas
	Within AZ, Cross AZ or Cross Region
	Replication is ASYNC, so reads are eventually consistent
	Replicas can be promoted to their own DB
	App must updatetheconnection string to leverage read replicas
	Use cases: 
		You have a Prod DB that is taking on normal load, you want to run reporting app to run some analytics.
		You create a Read Replica to run the new workload there.The prod app is unaffected.
		Read replicas are used for SELECT(=read) only kind of statements (not INSERT, UPDATE, DELETE)
	Network Cost:
		For RDS Read Replicas within the SAME region, you don't pay the fee(honorarios)
		For Cross Region, you pay!

Multi AZ (Disaster Recovery):
	SYNC replication == one standby DB
	One DNS name - automatic app failover to standby
	Increase availability
	Failover in case of loss of AZ, loss of network, instance or storage failure
	No manual intervention ins apps
	Not used for scaling
	the Read Replicas can setup as Multi AZ for Disaster Recovery(DR)

How a RDS can go from Single-AZ to Multi-AZ?
	Zero downtime operation (no need to stop)
	Just click on "modify" for the DB
	Happens internally:	A snapshot is taken
						A new DB is restored from the snapshot in a new AZ
						Synchronization is established between the two DB

RDS Security - Encryption:
	At rest encryption: Possibility to encrypt the master & replicas with Aws KMS - AES-256 encryption
						Encryption has to be defined at launch time
						If the master is not encrypted, the read replicas cannot be encrypted
						Transparent Data Encryption (TDE) available for Oracle and SQL Server
	
	In-flight encryption: SSL certificates to encrypt data to RDS in flight
						  Provide SSL options with trust certificate when cnnecting with databse
						  To enforce SSL: PostgreSQL: rds.force_ssl=1 in the Parameter Groups;
						  				  MySQL: Within theDB: GRANT USAGE ON *.*TO 'mysqluser'@'%' REQUIRE SSL;
	
	Encryption Operations:
		Encrypting RDS backups: Un-encrypted create a snapshots un-encrypted
								Encrypted create a snapshots encrypted
								To encrypt a backup you can Copy a snapshot into an encrypted one
		To Encrypt an un-encrypted RDS: Create a snapshot of the un-encrypted DB
										copy the snapshot and enable encryption for the snapshot
										Restore the DB from the encrypted snapshot
										Migrate app to the new DB and delete the old DB
	
RDS Security - Network & IAM
	Network Security: RDS are usually deployed within a private subnet,not in a public one
					  RDS security works by leveraging SG - it controls which IP /SG can communicate with RDS
	Access Management: IAM policies help  control who can manage RDS (throught the API)
					   Traditional User&Pass can be used to login into 
					   IAM-based auth can be used to login in RDS Mysql & PostgreSQL
	IAM authentication: just need an authentication token obtained throught IAM & RDSAPI calls
						Auth token has lifetime of 15min
						Benefitis: Network in/out must be encrypted using ssl
								   IAM to centrally message users instead of DB
								   Can leverage IAM Roles andEC2 profiles for easy integration
	Aws responsability:no ssh access, no manual DB/OS patching
						
```

Amazon Aurora:
```
Aurora is proprietary technology from Aws (NOT OPEN SOURCED)
Postgres/Mysql are supported as Aurora DB
is Cloud Optimized and claims 5x performance improvement over MySQL on RDS, over 3x of Postgres on RDS
Automatically grows in increments of 10GB, up to 64TB
Can have 15 replicas while Mysql has 5, and the replication process is faster (sub 10 ms replica lag)
Failoverin Autora  is instantaneous. It's HA native.
Aurora costs more than RDS(20% more) - but is more efficient

HA and Read Scaling:
	6 copies of your data across 3 AZ: 4 copies out 6 needed for writes
									   3 copies out of 6 need for reads
									   Self healing with peer-to-peer replication
									   Storage isstriped across 100s of volumes
	One Aurora Instance takes writes (MASTER)
	Automatedfailover for master in less than 30 sec
	Master+up to 15 Aurora Read Replicas serve reads

Aurora DB Cluster:
	Writer Endpoint -- point to tha mster
	Reader Endpoint - Connection Load Balancing 
					  (make the orchestration between the replicas and the master into Replicas ASG)
	Custom Endpoint - Run analytical queries on specific replicas
					  Define a subset of Aurora Instances as a Custom Endpoint
					  Grupo separado de instancias para rodar cargas específicas

Features: Routine Maintenance
		  Advance Monitoring
		  Automated Patching

Aurora Security:
	Similar to RDS, uses the same engines


```