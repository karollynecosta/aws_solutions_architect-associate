# Aws Cloud Solutions Architect - SAA-C02

Guia de estudos para a certificação.
Mín. de pontos para aprovação: 710 pts.
Curso feito: Udemy - Stephane Mareek

# Indice de estudos
1. [IAM & Aws CLI](#IAM)
2. [EC2](#EC2)
3. [High Availability and Scalability: ELB & ASG](#ELB+ASG)
4. [Aws Fundamentals - RDS + Aurora + ElastiCache](#RDSAuroraElasti)
5. [Route53](#Rout53)
6. [Solutions Architect Discussions](#solArch)
7. [Amazon S3](#S3)
8. [AWS SDK, IAM Roles & Policies](#SDKRolesPolicies)
9. [Advanced S3 & Athena](#AdvancedS3Ath)
10. [CloudFront & Global Accelerator](#CloudFrontGlb)
11. [Aws Storage Extras](#AdvancedStorage)


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
Use case: Use EBS io2 Block Express volumes on Nitro-based EC2 instances to achieve a maximum Provisioned IOPS of 256,000
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
					CANNOT be a boot volume
					125 Mib to 16 Tib
					Throughput Optimized HDD: Big Data, DAta warehouse, Log Proccessing
		sc1 (HDD) =  lowest cost volume designed for less frequently accessed workloads
					for data that is infrequently accessed
					Scenarios where lowest cost is important
					Max throughput 250Mib/s max IOPS 250

	Characterized in Size | Throughput | IOPS (I/O Ops per Sec)
	Only GP2/3 and io1/2 can be used as boot volume
	CANNOT be a boot volume: Throughput Optimized HDD (st1) + Cold HDD (sc1)
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
EFS - multi-AZ, multi instances LINUX at time, share website files, more expensive, pay per use.
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
					   IP Addresses - must be PRIVATE IP
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
	**Up to 5 read replicas**
	Within AZ, Cross AZ or Cross Region
	Replication is ASYNC, so reads are eventually consistent
	Replicas can be promoted to their own DB
	App must update the connection string to leverage read replicas
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
*Can have 15 read replicas* while Mysql has 5, and the replication process is faster (sub 10 ms replica lag)
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
	Each Read Replica is associated with a priority tier (0-15). In the event of a failover, Amazon Aurora will promote the Read Replica that has the highest priority (the lowest numbered tier).
	If two or more Aurora Replicas share the same priority, then Amazon RDS promotes the replica that is largest in size.
	If two or more Aurora Replicas share the same priority and size, then Amazon Aurora promotes an arbitrary replica in the same promotion tier.
	read replica vai promover a que tiver com maior prioridade(ord crescente), ex: entre 0-10, Tier-1(32GB) e Tier10(16TB), a Tier-1 será a escolhida.

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

Aurora Serverless: 
	Automated DB instantiation and auto-scaling based on actual usage
	Good for infrequent, intermittent or unpredictable workloads
	No capacity planning need
	Pay per second, can be more cost-effective

Aurora Multi-Master:
	Immediate failover for write node (HA)
	every node does r/w

Global Aurora:
	Aurora Cross Region Read Replicas: Useful for disaster recovery
									   Simple to put in place
	
	Aurora Global Database (recommended): 1 primary Region (r/w)
										  Up to 5 sec(read-only) regions, replication lag is less than 1 sec
										  Up to 16 Read Replicas per second region
										  Helps for decreasing latency
										  Promoting another region (for disaster recovery) has an RTO of <1 min
										  Use case: Disaster recovery

Aurora Machine Learning:
	Enables your to add ML-based predictions to your app via SQL
	Simple, optimized, and secure integration between Aurora and Aws ML services
	Supported services: Aws SageMaker (use with any ML model)
						Aws Comprehend (for sentiment analyst)
	don't need experience with ML 
	Use cases: fraud detection, ads targeting, sentiment analysis, product recommendations

```

Amazon ElastiCache:
```
Is to get managed Redis or Memcached
Caches are in-memory dB with really high performance, low latency
Helps reduce load off of DB for read intensive workloads
Help make your app stateless [recursos isolados](https://www.redhat.com/pt-br/topics/cloud-native-apps/stateful-vs-stateless)
Aws takes care of OS maintenance/patching/backup/failure recovery

Using ElastiCache involves heavy app code changes!

Architecture DB Cache:
	App queries ElastiCache, if not available, get from RD and store in ElastiCache.
	Helps relieve load in RDS 
	Cache must have an invalidation strategy to make sure only the most current data is used in there.

Architecture User Session Store:
	User logs into any of the app
	The app WRITES the session data into ElastiCache
	The user hits another instance of our app
	The instance retrieves the data and the user is already logged in

Redis vs Memcached:
	Redis: multi AZ with Auto-failover
		  read replicas to scale reads and have high availability
		  data durability using AOF persistence
		  Backup and restore features
		  Use case: Gaming Leaderboards are computationally complex, so Redis Sorted sets guarantee both uniqueness and element ordering.
		  			Each time a new element added, it's ranked in real time, then added in correct order
	
	Memcached: Multi-node for patitioning data (sharding - fragmentos)
			   No HA(replication)
			   Non persistent
			   No backup and restore
			   Multi-threaded architecture

Cache Security:
	All caches in ElatiCache: Do not support IAM auth
							  IAM policies on ElastiCache are only used for AWS API-level security
	Redis AUTH: can be user/ppass when you create a Redis cluster
		        This is an extra level of security for your cache
				Support SSL in flight encryption
	Memcached: supports SASL-based auth(advanced)

Patterns for ElastiCache:
	Lazy Loading: all the read data is cached, data can become stale in cache
	Write Throught: Adds or update data in the cache when written to a DB(no stale data)
	Session Store: store temporary session data in a cache (using TTL features)
				
```

List of Ports to be familiar with
```
Here's a list of standard ports you should see at least once. You shouldn't remember them (the exam will not test you on that), but you should be able to differentiate between an Important (HTTPS - port 443) and a database port (PostgreSQL - port 5432) 

Important ports:

	FTP: 21
	SSH: 22
	SFTP: 22 (same as SSH)
	HTTP: 80
	HTTPS: 443
	
	RDS Databases ports:
		PostgreSQL: 5432
		MySQL: 3306
		Oracle RDS: 1521
		MSSQL Server: 1433
		MariaDB: 3306 (same as MySQL)
		Aurora: 5432 (if PostgreSQL compatible) or 3306 (if MySQL compatible)
```

## Route53 <a name="Route53"></a>

DNS:
```
Domain Name System - translate the human friendly hostnames into the machine IP addresses
www.google.com => 17.125.35.33
DNS is the backbone of the internet
DNs uses hierarchical naming structure:   .com
									   example.com
									   www.example.com
									   api.example.com

DNS Terminologies:
	Domain Register: Aws Route53, GoDaddy...
	DNS records: A, AAAA, CNAME, NS
	Zone file: contains DNS records
	Name Server: resolves DNS queries (Authoritative or Non-Authoritative)
	Top Level Domain (TLD): .com,.us,.in,.gov,.org....
	Second Level Domain (SLD): amazon.com, google.com

	[FQDN(Fully Qualified Domain Name)]
	Htttp://api.www.example.com.
	Protocol://DomainName(subdomain.subdomain.SLD.TLD.root)  

DNS Works:
Web Browser --> request access to example.com --> Local DNS Server --> TLD DNS Server(.com) + SLD DNS Server --> return the answer.
```

Aws Route 53:
```
A highly available, scalable, fully managed and Authoritative DNS
	Authoritative = the client can update the DNS records
Is a Domain Register
Ability to check the health of your resources
The ONLY Aws Service which provides 100% availability SLA
Why 53? 53 is a reference to the traditional DNS port. 

Records:
	How you want to route traffic for a domain
	Each record contains: 
		Domain/Subdomain name - example.com
		RecordType: A - maps a hostname to IPv4
					AAAA - maps a hostname to IPv6 
					CNAME - maps a hostname to another hostname
						The target is a domain name which must have an A or AAAA
						Can't create a CNAME record for the top node of a DNS namespace(Zone Apex)
						Ex.: you can't create example.com, but you can create for www.example.com
					NS - Name Servers for the Hosted Zone
						Control how traffic is routed for a domain
		Value - 123.456.22.11
		Routing Policy - how route53 responds to queries
		TTL (Time To Live) - amount of time the record cached at DNS Resolvers
			High TTL - 24h: Less traffic on route53
							Possbile outdated records
			Low TTL - 60sec: MOre traffic on rout53($$)
							 Records are outdated for less time
							 Easy to change records
			Except for Alias records, TTL is mandatory for each DNS record

	Alias Records: Maps a hostname to an Aws Resource (DNS --> Type A --> Value: ALB)
				   An extension to DNS functionality
				   Automatically recognizes changes in the resource's IP addresses
				   It can be used fot he top node of a DNS namespace != of CNAME
				   Is always of type A/AAAA for Aws resources
				   You can't set the TTL
				   Targets: ELB
				   			CloudFront
							Api Gateway, VPC Endpoints
							Elastic Beanstalk
							S3 Websites
							route53 records	 
					Cannot set for EC2 DNS name
	
	Route53 supports the following DNS record types:
		A/aaaa/cname/NS
		CAA/DS/MX/NAPTR/PTR/SOA/TXT/SPF/SRV

	Hosted Zones: A container for records that define how to route traffic to a domain and its subdomains
				  Public Hosted Zones: contains records that specify how to route traffic on the Internet (app.meypublicdomain.com)
				  Provate hosted Zones: contain records that specify how you route traffic within one or more VPC(app2.company.internal)
				  You pay $0.50 per month
	
	CNAME vs Alias:
		When you want to redirect your ALB to your DNS, you can use:
			CNAME: points a hostname to any other hostname (app.mydomain.com => blabla.anything.com)
				   ONLY FOR NON ROOT DOMAIN
				   test.domain.com >> Type: cNAME >> Value: the ALB

			Alias: points a hostname to an Aws Resource (app.mydomain.com => blabla.anything.com)
				   WORK FOR ROOT DOMAIN AND NON ROOT DOMAIN(aka.mydomain.com)
				   Free of charge
				   Native health check
				   domain.com >> Type A >> Value: Alias (set the ALB)

Commands to check the availability of our domain:
	`sudo yum install -y bind-utils`
	nslookup test.exemple.com
	dig test.exemple.com

Routing Policies:
	Define how Route53 responds to DNS queries
	Supports: 
		Simple: route traffic to a single resource
				can specify multiple values in the same record
				If multiple values are returned, a rendom on is chosen by the client
				when Alias enabled, specify only one Aws resource
				Can't be associate with healthy checks
		
		Weighted: control the % of the requests that go to each specific resource
				  assign each record a relative weight(max 100)
				  DNs records must have the same name and type
				  Can be associate with healthy checks
				  Use cases: load balancing between regions, testing new app version
				  			 If you want to stop sending traffic to a resouce --> weight=0
							 If all records are 0, they will be divide equally 
		
		Latency-based: redirect to the resource that has the least latency close to us
					   super helpful when latency for users is a priority
					   latency is based on traffic between users and Aws Region
					   Germany users may be directed to the US
					   Can be associate with Health Checks(has a failover capability)
		
		Failover (Active-Passive): Create 2 instances, and set the HC. If the first become unhealthy, then the second is up to respond to DNS requests

		Geolocation: different from latency-based!
					 Is based on user location!
					 Specify location by Continent, Country or by US State
					 Should create a "Default" record (in case the's no match on location)
					 Use cases: website localization, restrict content distribution, load balancing
					 Can be associate with HC
		
		Geoproximity: Route traffic to your resources bases on the geographic location of users and resources
					  Ability to shift more traffic to resouces based on the defined bias(valor):
					  	To change the size of the geografic region: To expand(1 to 99) more traffic to the resource
						  											To shrink (-1 to -99) less traffic to the resource
					  Resources can be: Aws resources or Non-Aws resources
		
		Multi-Value: Use when routing traffic to multiple resources
					 Route53 return multiple values/resources
					 Can be associate with HC(return only healthy resources)
					 Up to 8 health records are returned for each
					 Is not substitute to ELB


Traffic Flow: Simplify the process of creating and maintaining records in large and complex conf
			  It's a visual editor to manage complex routing decision trees
			  Configurations can be saved as Traffic Flow Policy

Health Checks: HTTP health checks are only for public resources
			   Integrated with CloudWatch metrics
			   Automated DNS Failover: 1. Monitor an endpoint: About 15 global health checkers:
																	Healthy/Unhealthy threshold - 3 by default
																	Supported protocol: HTTP, HTTPS and TCP
																	Ability to choose which locations you want route53 to use
															   Health pass only when the endpoint responds with the 2xx and 3xx status code
															   Can be setup to pass/fail based on the text in the first 5120bytes of the response
															   Configure you roter/firewall to allow incoming requests from route53 HC
			   						   2. Monitor other health check(calculate): combine the results of multiple HC into a single HC
										  										 can use OR, AND or NOT
																				 can monitor up to 256 child HC
																				 Specify how many if the checks need to pass to make the parent pass
																				 Usage: perfom maintenance to your website without causing all HC to fail
									   3. Monitor CloudWatch Alarms(full control)
			   Monitor Private hosted zones: with CloudWatch Metric and associate a CloudWatch Alarm, then the HC will check

Godaddy(3rd Party) as Registrar & Route53 as DNS Service:
	Register on GoDaddy + Public Hosted Zone(will deliver the name servers, that have to be add in Godaddy)
```

## Solutions Architect Discussions <a name="solArch"></a>

Case 1: Stateless Web App
```
whatisthetime.com allows people to know what time it is
don't need a DB // don't srote data on the host = stateless

Scaling horizontally: Group of 3 Private EC2 instances in +2 AZ within ASG --> Restricted Security groups rules --> 
					  ELB + health checks --> Clients requests --> DNS Query within Route53
```

Case 2: Stateful Web App
```
myclothes.com allows people to buy clothes online
There's a shopping cart
hundreds of users at the same time
require some kind of storage == stateful

 - Introduce Stickiness(para manter os dados da sessão)
 - Introduce User Cookies: cookies must be validated and must be less than 4kb
 - Introduce Server Session with ElastiCache: DNS queries by route53 --> User requests 
 											 --> ELB with multi-az --> ASG with 3 groups of EC2 in different AZ 
											 --> Elasticache store/retrieve session data and make sure the data is secure
 - Storing User Data in a DB: DNS with route53 --> Users requests
							  --> multiAZ ELB --> ASG with 3 groups of EC2 in different AZ 
							  --> RDS storing/retrieve user data(address, name, etc)
 - Scaling Reads: DNS with route53 --> Users requests
				--> multiAZ ELB --> ASG with 3 groups of EC2 in different AZ 
				--> RDS master --> RDS replica
 - Scaling Reads - write through: DNS with route53 --> Users requests
						--> multiAZ ELB --> ASG with 3 groups of EC2 in different AZ 
						--> Check if the info is already in cache in ElastiCache
						--> Caso nao tenha:
					    --> RDS read/write 
 - Multi Az - survive disaster: DNS with route53 --> Users requests
						--> multiAZ ELB --> ASG with 3 groups of EC2 in different AZ 
						--> Check if the info is already in cache in ElastiCache MultiAz
						--> Caso nao tenha:
					    --> RDS read/write MultiAz
 - Security Group rules: Route53 --> Client Request
						--> Rule: Open HTTP/S to 0.0.0.0/0 --> ELB multiAZ
						--> Rule: restrict traffic to EC2 SG from the ELB --> ASG with groups of ec2 in differents az
						--> Rule: restrict traffic to ElastiCache SG from the Ec2 SG --> Elasticache MultiAZ
						--> Rule: restrict traffic to RDS SG from the Ec2 SG --> RDs MultiAZ
```

Case 3: Stateful Web App mywordpress.com
```
Fully scalable Wordpress website
that website access and correctly display picture uploads
our user data should be stored in MySql DB

 - RDS Layer or
 - Aurora MySQL: benefits of Multi Az Read Replicas
 - Storing images with EBS: DNS with route53 --> Users send image
						--> multiAZ ELB --> EC2 and one EBS volume attached
						Obs: the problem with EBs is that it only works within one instance
 - Storing images with EFS: DNS with route53 --> Users send image
						--> multiAZ ELB --> EC2 + ENI(Elastic Network Interfaces) 
						--> One EFS storing the images
						Obs.: the EFS is shared with many instances
```

Instantiating Applications quickly(rapidamente):
```
EC2 instances: 
	Use Golden AMI: install your app, OS dependencies...before hand and launh your EC2 from the AMI
	Booststrap using User DAta: for dynamic configuration, use User Data Scripts
	Hybrid: mis golden AMi and User Data (Elastic Beanstalk)

RDS DB:
	Restore from a snapshot: the DB will have schemas and data ready!

EBS Volumes:
	Restore from snapshot: the disk will already be formatted and have data!

```

ElasticBeanstalk:
```
Is a developer centric view of deploying an app on Aws
It uses all the component's we've seen before: EC2, ASG, ELB, RDS///
Managed Service: automatically handles capacity provisioning...
				 just tha pp code is the responsibility of the developer
We still have full control over the conf
Is free but you pay for the underlying instances
Components:
	Application: collections of Elastic Beanstalk components(environments, versions, conf...)
	Application Version: an iteration of your app code
	Environment:
		Collection of Aws resources running an app version(only one app version at a time)
		Tiers: Web server environment Tier(ELB) & Worker Environment Tier(SQS Queue)
		You can create multiple environments(dev, test/qa, prod...)
Supports: Go, Java, .NET, PHP, Python...or you can write a template for your language. 
```

## Amazon S3 <a name="S3"></a>

Resume:
```
Infinitely scaling storage
Many websites use S3 as a backbone
Amazon S3 allows people to store objects(files) in "buckets"(directories)
Buckets must have: globally unique name
				   defined at the region level
				   no uppercase, no underscore, 3-63 characteres long
				   not an IP, must start with lowercase letter or number
```

Objects:
```
 objects have a key
		 The key is the full path:
		 	s3://my-bucket/myfile.txt
		    composed of prefix+object name
		 Values are the content of the vody:
		 	Max object is 5TB
			If > 5GB, must use "multi-part upload"
		 Metadata is a list of text key/value pairs - system or user metadata
		 Tags: unicode key/value - useful for security/lifecycle
		 Version ID (if versioning is enabled)
```

Versioning:
```
you can version your files, it is enabled at the bucket level
Same key overwrite will increment the version: 1,2,3...
It is best practice to version your buckets: Protect against unintend deletes and has easy roll back to previous version
Notes: Any file that is not versioned prior to enabling versioning will have version "null"
	   Suspending versioning does not delete the previous versions
```

Encryption for Objects:
```
Make your objects secures 
There are 4 methods of encrypting objects:
	SSE-S3: encrypts S3 objects using keys handled & managed by Aws
		    objects is encrypted server side
			AES-256 encryption type
			Must set header: "x-amz-server-side-enc":"AES256"
			HTTPS/HTTPS

	SSE-KMS: leverage KMS to manage encryption keys
			 user control + audit trail
			 objects is encrypted server side
			 Must set header: "x-amz-server-side-encryption":"aws:kms"
			 Object --> HTTP/S + Header --> KMS encryption -- S3 Bucket.

	SSE-C: when you want to manage your won encryption keys
		   S3 does not store the encryption key you provide
		   HTTPS must be used
		   Encryption key must provided in HTTP headers, for every HTTP request made
		   Object + Client side data key --> HTTPS only + DataKey in Header --> Client encryption -- Bucket.

	Client Side Encryption: clients must encrypt data themselves before sending to S3
							clients must decrypt data themselves when retrieving from S3
							customer fully manages the keys and encryption cycle

Encryption in trasit(SSL/TLS): 
	S3 exposes: HTTP endpoint: non encrypted
				HTTPS endpoint: encryption in flight
	You're free to use the endpoint you want, but HTTPS is recommended by default
	HTTPS is mandatory for SSE-C
	in flight == SSL/TLS
```

S3 Security:
```
User based:
	IAM policies - which API calls shoud be alloewd for a specific user from IAM console
				   an IAM principal can access an S3 object if: the user permissions allow it OR the resource policy allows it
				   												and there's no explicit DENY

Resource Bases:
	Bucket Policies - bucket wide rules from the S3 console - allows cross account
					  JSON based policies: Resources buckets and objects
										   Actions: Set of API to allow or Deny
										   Effect: Allow/Deny
										   Principal"The account or user to apply the policy to
					  Use to: Grant public access to the bucket
					  		  Force objects to be encrypted at upload
							  Grand access to another account (Cross Account)
					  Block Public Access throught: new access control list (ACLs)
					  								any access control lists(ACLs)
													new public bucket or access point policies
													these setting were created to prevent company data leaks

	Objects Access Control List (ACL) - finer grain
	Bucket Access Control List (ACL) - less commom

Networking:
	Supports VPC ENdpoint (for instances in VPC without www internet)
Logging and Audit:
	S3 Access Logs can be stored in other S3 bucket
	API calls can be logged in Aws CloudTrail
User Security:
	MFA Delete: MFA can be required in versioned buckets to delete objects
	Pre-Signed URLs: URLs that are valid only for a 3600 sec limited time
					 Opção usada para quando precisamos visualizar o objeto por um tempo, mas sem deixá-lo público.
					 Can change timeout with --epires-in [time-by-seconds] argument 
					 Users given a pre-signed URL inherit the permissions of the person who generate the URL for GET/PUT
					 Examples:
					 	Allow only logged-in users to download a premium video 
						Allow temporarily a user to upload a file to a precise location in our bucket


```

S3 Websites:
```
S3 can host static websites and have them accessible on the www
The website URL: <bucket-name>.s3-website.<Aws-Region>.amazonaws.com
				If return 403(Forbidden) error, make sure the bucket policy allows public reads!
				Use Aws Policy Generator			
```

S3 CORS:
```
An ORIGIN is a scheme(protocol), host(domain) and port
	https://www.exemple.com (443 for HTTPS and 80 for HTTP)
CORS = Cross-Origin Resource Sharing
Web Browser based mechaninsm to allow requests to other origins while visiting the main origin
	Same origin: http://example.com/app  & http://example.com/app3
	Different origins: http://www.example.com  & http://other.example.com
The requests won't be fulfilled unless the other origin allows for the requests, using CORS Headers
	ex: Access-control-allow-origin

"A origem http://www.ex.com está me direcionando para o seu site, voce permite isso Cross Origin http://www.crossother.com ?
--> Sim, o www.ex.com está permitido via Access-Control-Allow-Origin, com os Access-Control-Allow-Methods: GET,PUT,DELETE"

If a client does a cross-origin request on our s3 bucket, we need to enable the correct CORS headers
**It's a popular exam question**
You can allow for a specific origin or for *(all origins) ON THE CROSS ORIGIN BUCKET, the origin bucket only make a request. 
```

S3 Consistency Model:
```
Strong consistency as of December 2020
After a: successful write of a new object (new PUT)
		 or an overwrite or delete of an existing object (overwrite PUT/DELETE)
...any: subsequent read request immediately receives the latest version of the object(read after write consistency)
		subsequent list request immediately reflects changes(list consistency)
Available at no additional cost, without any perfomance impact
```

## AWS SDK, IAM Roles & Policies <a name="SDKRolesPolicies"></a>
EC2 Metadata:
```
Metadata = info about the instance
Userdata = lunch script of the Ec2 instance

In the Ec2:
	curl http://169.254.169.254/latest/meta-data/  # return the meta-data

```

SDK Overview:
```
Perform actions on Aws directly from your applications code
Languages: Java, .NET, PHP, Python(boto3 botocore), Go, Ruby
When calling DynamoDB this use Aws SDK.
Default region: us-east-1
```

## Advanced Amazon S3 & Athena <a name="AdvancedS3Ath"></a>

S3 MFA-Delete:
```
Enable Versioning on the S3, so you will need MFA to:
	Permanently delete an object version
	Suspend versioning on the bucket

You don't need MFA for: enabling versioning, listing deleted versions
Only root account can enbale/disable MFA-Delete by using the CLI.
```

S3 Default Encryption vs Bucket Policies:
One way to "force encryption" is to use a bucket policy and refuse any API call to PUT an S3 object without encryption headers.
```
{
	"Version": "2012-10-17",
	"Id": "PutObjectPolicy",
	"Statement": [
		{
			"Sid": "DenyIncorrectEncryptionHeader",
			"Effecty": "Deny",
			"Principal": "*",
			"Action": "s3:PutObject",
			"Resource": "arn:aws:s3::<bucket>/*",
			"Condition": {
				"Null": {"s3:x-amz-server-side-encryption": true}
			}
		}
	]
}
```

Another way is to use the default encryption in S3.
order: 1 - Default encryp
	   2 - bucket policie

S3 Access Logs:
```
For audit purpose, you may want to log all access to S3 buckets
Any request made to S3, from any account, authorized or denied, will be logged into another S3 bucket.
That data can be analyzes using data analysis tools/Athena.
Warning: do not set your logging bucket to be the monitored bucket
		 It will create a logging loop, and your bucket will grow in size exponentially
```

S3 Replication (CRR & SRR):
```
Must enable versioning in source and destination buckets:
	After activating, only new objects are replicated
	For DELETe operations: can repolciate delete markers from source to target (optional)
						   deletions with a version IS are not replicated (to avoid malicious deletes)
	There ir no "chaining = encademento" of replication: if bucket 1 has replication into bucket 2, which has replication into bucket 3. then objects created in bucket 1 are not replicated to bucket 3.
Cross Region Replication = CRR
Same Region Replication = SRR
Buckets can be in different accounts
Copying is async
Must give proper IAm permissions to S3

Asynchronous: eu-west-1 --> us-east1

CRR - use cases: Compliance
				 lower latency access
				 replication across accounts
				 
SRR - use cases: Log aggregation
				 Live replication between production and test accounts
```

S3 Storage Classes:
```
S3 Standard - General Purpose:
	High durability of objects across multiple AZ
	99,99% Availability over a given year
	Sustain 2 concurrent facility failure
	use Cases: Big Data analytics,
			   Mobile & gaming app
			   content distribution...

S3 Standard-Infrequent Access (IA):
	Suitable for data that is less frequently accessed, but requires rapid access when needed
	99.9% Availability
	Low cost compared to Amazon S3 Standard
	Sustain 2 concurrent facility failures
	Use Cases: as a data store for disaster recovery, backups...

S3 One Zone-IA:
	Data is stored in a single AZ
	99.5% Availability
	Low latency and high throughput performance
	Suports SSL for data at transit and encryption at rest
	Low cost compared to IA (20%)
	Use CAses: Storing secondary backup copies of on-premise data, or storing data you can recreate

S3 Intelligent tiering:
	Same low latency and hight throughout perfomance of S3 standard
	Small monthly monitoring and auto-tiering fee
	Automatically moves objects between two access tiers based on changing access patterns
	Designed for durability of 99.9% over a giver year across multiple AZ
	Resilient against events that impact an entire AZ

Amazon Glacier:
	Not public objects
	Low cost object storage meant for archiving/backup
	Data is retained for the longer term - 10 years
	Alternative to on-premise magnetic tape storage
	Average annual durability is 99.99%
	Cost per storage per month ($0.004 / GB) + retrieval cost
	Each item in Glacier is called "Archive" (+ 40TB)
	Archives are stored in Vaults
	3 retrieval options:
		Expedited - 1 to 5 min
		standard - 3 to 5h
		Bulk - 5 to 12h
		Minimum storage duration = 90 days
	
	Vault Lock: Adopt a WORM(Write Once Read Many) model
				Lock the policy for future edits (can no longer be changed)
				Helpful for compliance and data retention
	
Amazon Glacier Deep Archive:
	For long term storage - cheaper:
		Standard - 12h
		Bulk - 48h
		Minimum storage duration = 180 days


S3 Reduced Redundancy Storage (deprecated)
```

S3 Lifecycle Rules:
```
Transition actions:
	It defines when objects are transitioned to another storage class.
		Ex.: Move obj to Standard IA class 60 days after creation
			 Move to glacier for archiving after 6 months
		INVALID lifecycle Transitions: S3 Intelligent-Tiering => S3 Standard
									   S3 One Zone-IA => S3 Standard-IA
										* => *Standard*

Expiration actions: 
	Configure objects to expire(DELETE) after some time.
		Ex.: Access log files can be set to deleter after 365 days
			 Can be used to delete old versions of files (if versioning is enabled)
			 Can be used to delete incomplete multi-part uploads

Rules can be created for:
	A certain prefix (s3://bucket/mp3/*)
	Certain objects tags (Department:Finance)

Scenario 1:
"App on EC2 creates images thumbnails after profile photos are uploaded to S3. These thumbnails can be easily recriated, and only need to be kept for 45 days. the source images should be able to be immediately retrieved for these 45 days, anda afterwards, the user can wait up to 6hours. How would you design this?"
	-- S3 source images can be on Standard, with lifecycle configuration to transition them to GLACIER Standard after 45 days.
	-- S3 thumbnails can be ONEZONE_IA, with a lifecycle configuration to expire them (delete) after 45 days.

scenario 2:
"You should be able to recover your deleted S3 objects immediately for 15 days, although this may happen rarely. After this time, and for up to 365 days, deletec objects should be recoverable within 48h"
	-- Enable S3 verisoning in order to have object versions
	-- You can transition there "noncurrent version" of the object to S3_IA
	-- You can transition afterwards there noncurrent to DEEP_ARCHIVE Bulk.
```

S3 Analytics - Storage Class Analysis
```
You can setup s3 analytics to help determine when to transition objects from Stardard to Standard_IA
does not work for ONEZONE_IA or GLACIER
Report is updated daily
Takes about 24h to 48h to first start
Good first step to put together Lifecycle rules
```

S3 Baseline Performance:
```
S3 automatically scales to high requests rates, latency 100-200ms
Your app can achieve at least 3.500 PUT/COPY/POST/DELETE and 5.500 GET/HEAD request per second per prefix in a bucket.
There are no limits to the number of prefixes in a bucket.
If you spread reads across all four prefixes evenly, you can achieve 22K request per second fot GET and HEAD

S3 - KMS limitation:
	If you use SSe-KMS, you may be impacted by the KMS limits
	When you upload, it calls the GenerateDatakey KMS API
	When you download, it calls the Decrypt KMS API
	Count towards the KMS wuota per second, you can increase using the Service Wuotas Console. 

S3 Performance:
	Multi-Part upload:
		recommended for file > 100MB
		must use for files > 5GB
		Can help parallelize uploads (speed up transfer)

	S3 Transfer Acceleration:
		Increase transfer speed by transferring file to an Aws edge location which will forward the data to the S3 bucket in the target region.
		Compatible with multi-art upload

	S3 Byte-Range Fetches:
		Parallelize GETs by requesting specific byte ranges
		Better resilience in case of failures
		Can be used to speed up downloads
		Can be used to retrieve only partial data (ex.: head of file)	
```

S3 Select & Glacier Select:
```
retrieve less data using SQL by performing server side filtering
Can be filter by rows & columns *simples Sql statements*
Less network transfer, less CPU cost client-size
```

S3 Event Notification:
```
S3:ObjectCreated..
Object name filtering possibile (*.jpg)
Use case: generate thumbnails of images uploaded to S3
Can create as many S3 events as desired
S3 event notif typically deliver events in seconds but can sometimes take a minute or longer
If you want to ensure that an event notification is send every successful write, you can enable versioning on your bucket.
```

S3 Requester Pays:
```
In general, bucket owners pay for all S3 storage and data transfer costs associated with their bucket.
Whith requester Pays buckets, the requester pays the cost of the request and the data download from the bucket.
Helpgul when you want to share large datasets with other accounts.
The requester mus be authenticated in Aws (cannot be anonymous)
```

Athena:
```
Serveless service to perform analytics directly against S3 files
Uses SQL language to query the files
Has a JDBS / ODBC driver
Charged per query and amount of data scanned
Supports CSV, JSON, ORC, Avro, and Parquet (built on Presto)
Use cases: BI, analytics, reporting, VPC Flow Logs
		   ELB Logs, CloudTrail trails...

		   ANALYZE DATA DIReCTLY ON S3 ==> USE ATHENA
```

S3 Object Lock:
```
enable versioning
Adopt WORM model
Block an object version deletion for a specified amount of time
Object retention:
	Retention Period: specifies a fixed period
					  Different versions of a single object can have different retention modes and periods
					  When you apply a retention period to an object version explicitly, you specify a Retain Until Date for the object version.
	Legal Hold: same protection, no expiry date

Modes:
	Governance mode: users can't overwrite or delete an object version or alter its lock setting unless they have special permissions

	Compliance mode: a protected object verison can't be overwriteen or deleted by any user, including the root user in your Aws account. When an object is locked in compliance mode, its  retention mode can't be changed, and irs retention period can't be shortned. 
```

## CloudFront & Global Accelerator <a name="CloudFrontGlb"></a>

CloudFront == CDN
```
Content Delivery Network = CDN
Improves read performance, content is cached at the edge
216 points of presence globally *edge locations*
DDoS protection, ingration with Shield and WAF
Can expose external HTTPS and can talk to internal HTTPS backends

CloudFront Origins:
	S3 Bucket: For distributing files and caching them at the edge
			   Enhance security with cloudfront OriginAccessIdentity(OAI) + S3 bucket policy
			   Cloudfront can be used as an ingress (to upload files)
	
	Custom Origin (HTTP): 
		ALB: Client --> Request --> SG(ALB Public) --> Allow SG of ALB --> SG(EC2 private)
		EC2: Client --> Req --> Edge locations --> Allow public IP of edge locations --> SG(ec2 public)
		S3 website (enable bucket as a static s3 website)
		Any HTTP backend you want

CloudFront Multiple Origin:
	To route to different kind of origins based on the content type
	Based on path pattern: /images/* --> S3 Bucket
						   /api/* --> ALB

CloudFront Origin Groups:
	To increase HA and do failover
	Origin group: one primary and onde secondary origin
				  If th eprimary origin fails, the second one is used


CloudFront Geo Registriction:
	Restric who can access your distribution:
		Whitelist
		Blacklist
	The country is determined using Geo-IP database
	Use case: Coyright Laws to control access to content

Cloudfront vs S3 CRR:
	CloudFront: Global Edge Network
				Files are cached fot a TTL (maybe a day)
				Great for static content that must be available everywhere
	S3 CRR: Must be setup for each region you want replication to happen
			Files are update in near real-time
			Read only
			Freat for dynamic content that needs to be available at low-latency in few regions

Cloudfront Signed URL / Signed Cookies
	When you want to distribute paid shared content to premium users over the world.
	Attach a policy with:
		Includes URL expiration
		Includes IP ranges to access the data from
		trusted signers (which Aws accounts can create signed URL)
	How long should be URL be valid for?
		Shared content: make ir short (movie, music)
		Private content: for years (private to the user)
	
	Signed URL = access to individual files (one signed URL per file)
	Signed Cookies = access to multiple files (one signed coolie for many files)

CloudFront Signed URL vs S3 Pre-Signed URL:
	Cloudfront: Allow access to a path, no matter the origin
				Account wide key-pair, only the root can manage it
				Can filter by IP, path, date, expiration
				Can leverage caching features
	
	S3 Pre-Signed: Issue a request as the person who pre-signed the URL
				   Uses the IAM key of the signing IAM principal
				   Limited lifetime

CloudFront Field Level Encryption:
	Protect user sensitive information throught app stack
	Adds an additional layer of security along with HTTPS
	Sensitive information encrypted at the edge close to user
	Usage: Specify set of fields in POST requests(up to 10) and sprecify te public key to encrypt them

Cloudfront Pricing:
	The cost of data out per edge location varies
	Price Classes:
		1. Price Class All: all regions -- best performance
		2. Price Class 200: most regions, but excludes the most expensive regions
		3. Price Class 100: only the least expensive regions

CloudFront Multi-tier cache:
	Regional edge caches that improve latency.

	Bypass: Dynamic content, as determined at request time (cache-behavior configured to forward all headers)
			Proxy methods PUT/POST/PATCH/OPTIONS/DELETE go directly to the origin
```

Aws Global Accelerator:
```
Application with global users who want to access it directly.
We wish to go as fast as possible through Aws network to minimize network

UnicastIP: one server holds one IP address
AnycastIP: All server hold the same IP address and the client is routed to the nearest one.

Global Accelerator: leverage aws internal net to route to your app
					2 Anycast IP are created for your app
					The anycast send traffic directly to Edge Locations
					The Edge locations send the traffic to your app
					Work with: elastic IP, instances, ALB, NLB, public or private
					Consistent Performance: Intelligent routing to lowest latency and fast regional failover
											No issue with client cache (because the IP don't change)
											Internal Aws network
					Health Checks: helps make your app global, great for sisaster recovery
					Security: only 2 external IP need to be whitelisted
							  DDoS protection thanks to Aws Shield

Global Accelerator vs CloudFront:
	They both use Aws global network and its edge locations around the world
	Both sevices integrate with Aws Shield for DDoS protection

	Cloudfront: Improves performance for both cacheable content (images and videos)
				Dynamic content (API acceleation an d dynamic site delivery)
				Content is served at the edge

	Global Accelerator: Improves performance for a wide range of app over TCP or UDP
						Proxying packets at the edge to app running in one or more Aws regions
						Good fit for non-HTTP use cases, such as gaming(UDP), IoT (MQTT), or VoiceIP(voip)
						Good for HTTP use cases that require static IP or deterministic, fast regional failover.
```

## Aws Storage Extras <a name="AdvancedStorage"></a>
Aws Snow Family:
```
Highly-secure, portable devices to collect and process data at the edge, and migrate data into and out of AWS
Offer offiline devices to perform data migrations
If takes more than a week to transfer over the network, use Snowball devices!

Data migration:
	Aws Services: Snowcone: it's a small box
							Small, portable computing anywhere, rugged & secure, withstands harsh environments(desert, rain)
							Light (4.5 pounds, 2.1 kg)
							Device used for edge computing, store and data transfer
							8 TB of usable storage
							Use Snowcone where snowball does not fit
							Must provide your own battery / cables
							Can be sent back to Aws offline, or connect ir to internet and use Aws DataSync to send data

				  Snowball edge: its a huge box
				  				 Physical data transport solution: move TB or PBs of data in or out of Aws
								 Alternative to moving data over the network
								 Pay per data transfer job
								 80 TB usable store
								 Provide block storage and S3-compatible object storage
								 Snowball Edge Storage Optimized: 80Tb of HGG capcaity for block volume and s3 storage
								 Snowball Edge Compute Optimized: 42Tb of HGG capcaity for block volume and s3 storage
								 Use cases: large data cloud migrations, DC decommission, disaster recovery

				  Snowmobile: it's a TRUCK (caminhão)
				  			  Transfer exabytes of data (1 EB = 1000 PB = 10000000 TBs)
							  High security: temparature controlled, GPS, 24/7 video surveillance
							  Better than snowball if your transfer more than 10PB

	Challenges: Limited connectivity/bandwidth
				High network cost
				Shared bandwith
				Connection stability

Usage process: 
	1. Request Snowball devices from the Aws console for delivery
	2. Install the snowball client / AWs OpsHub on your servers
	3. Connect the snowball to your servers an copy files using the client
	4. Ship back the device when you're done
	5. Data will be loaded into an S3 bucket
	6. Snowball is completely wiped
	

Edge computing:
	What is Edge computing?
		Process data while it's being create on an edge location.
			can be: a truck on the road, shipt on the sea...
		These locations may have:
			limited / no internet access
			limited / no easy access to computing power
		we setup a snowball Edge / Snowcone device to do edge computing
		Use cases: Preprocess data
				   Machine learning at the edge
				   Transcoding media streams
		Eventually we can ship back the device to Aws (for transferring data for example)

	Snowcone (smaller):
		2 CPUs, 4GB of memory, wired or wireless access
		USB-C power using a cord or the optional battery

	Snowball Edge - Compute optimized:
		52 vCPUs, 208 GiB of RAM
		Optional GPU (useful for video processing or machine learning)
		42 TB usable storage

	Snowball Edge - Storage optimized:
		Up to 40 vCPUs, 80 Gib RAM
		Objects storage clustering available
	
	All: can run EC2 & Lambda functions (using aws IoT Greengrass)
	Long-term deployment options: 1 and 3 years discounted pricing

Aws OpsHub:
	To use Snow Familly devices, you need a CLI
	you can use Aws OpsHub (software to install) to manage Snow family device:
		Unlicking and configuring single or clusted devices
		Transferring files
		Launching and managing isntances 
		monitor devices metrics (storage, active instances)
		Launch compatible Aws services on your devices (DataSync, NFS, EC2)

```

Snowball into glacier:
```
Snowball cannot import to Glacier directly
Must use S3 first, in combination with an S3 lifecycle policy.
```

Aws Storage Gateway:
```
Problem: Hybrid Cloud for storage, S3 is proprietary technology (unlike NFS / EFS), so how do you expose the S3 data on-premises?

Solution: Aws Storage Gateway
	Bridge between on-premises data and cloud data in S3
	Use cases: disaster recovery, backup & restore, tiered storage
	3 types: **important to know the diff**
		File Gateway: Configured S3 buckets are accessible using NFS and SMB protocol
					  Supports S3 standard, S3 IA, S3 One Zone IA
					  Bucket access using IAm roles for each File Gateway
					  Most recently used data is cached in the file gateway
					  Can be mounted on many servers
					  Integrated with AD for user authentication
					  
		Volume Gateway: Block storage using iSCSI protocol backed by S3
						Backed by EBS snapshots which can help restore on-premises volumes!
						Cached volumes: low latency access to most recent data
						Stored Volumes: entire dataset is on premise, scheduled backups to S3					

		Tape Gateway: Some companies have backup process using physical tapes
					  With Tape Gateway, companies use the same process but, in the Cloud
					  Virtual Tape Library (VTL) backed by S3 and Glacier
					  Back up data using existing tape-based processes (and iSCSI interface)
					  Works with leading backup software vendors
	
	Storage Gateway - Hardware appliance: 
		Using Storage Gateway means you nedd on-premises virtualization
		Otherwise, you can use a Storage Gateway Hardware Appliance
		You can buy it on amazon.com
		Works with File, Volume and tape Gateway
		Has the required CPU, memory, network, sSD cache resources
		Helpful for daily NFS backups in small data centers

Tips for exam:
	On-premises data to the cloud == Storage Gateway

	File access/NFS - user auth with AD == File Gateway (backed by s3)

	Volumes/ Block Storage / iSCSI == Volume gateway (backed by s3 with EBS snapshot)

	VTL Tape Solution / Backup with iSCSI == Tape Gateway (s3 and glacier)

	No on-premises virtualization == Hardware applicance
```

Amazon FSx for Windows (FIle Server):
```
Problem: EFS is a shared POSIX ssystem for linux system
Resolution: FSx for Windows
	Is a fully managed Windows file system shared drive
	Supports SMB protocol & NTFS
	Microsoft AD integration, ACLs, user quotas
	Built on SSD, scale up to 10s of GB, millions os IOPS, 100s PB of data
	Can be accessed from your on-premise infrastructure
	Can be configured to be Multi-AZ (HA)
	Data is backed-up daily to S3
```

Amazon FSx for Lustre:
```
Lustre is a type of parallel distributed file system, for large-scale computing
the name Lustre is derived from "Linux" and "cluster"
use cases: Machine learning, High Performance Computing(HPC)
		   Video Processing, Financial Modeling, Eletronic Design Automation
Scales up to 100s GBs, millions of IOPS, sub-ms latencies
Seamless integration with S3: Can read S3 as a file system (through FSx)
							  Can write the output of the computations back to S3
Can be used from on-premises servers

FSx File System Deployment Options:
Scratch File System: temporary storage
					 Data is not replicated (doesn't persist if file server fails)
					 High burst (6x faster, 200mbp per Tib)
					 usade: short-term processing, optimize costs

Persistent File System: Long-term storage
						Data is replicated within same AZ
						Replace failed files within minutes
						Usage: long-term processing, store sensitive data

```

Aws Transfer Family:
```
a fully-managed service for file transfers into and out of Amazon S3 or EFS using the FTP protocol
Supported Protocols:
	Aws Transfer for FTP (within VPC)
	Aws Transfer for FTPS (File Transfer Protocol over SSL(FTPS))
	Aws Transfer for STPS (Secure File Transfer Protocol(SFTP))
Managed infrastructure, Scalable, reliable, Highly Available (multi-AZ)
Pay per provisioned endpoint per hour + data transfers in GB
store and manage users credentials within the service
Integrate with existing auth systems (Microsoft AD, LDASP, Okta, Amazon Cognito, custom)
Usage: sharing files, public datasets, CRM, ERP...
```

Resume:
```
S3: Object store
Glacier: Object Archival
EFS: Network File System for Linux intances, POSIX 
FSx for Windows: NFS for Windows Server
FSx for Lustre: High Performance Computing Linux file system
EBS volume: Network storage for one Ec2 instance at a time
Instance Storage: Physical store for your EC2 
Storage Gateway: File gateway, Volume Gateway(cache & stored), Tape Gateway
Snowball / Snowmobile: to move large amount of data to the cloud, physically
Database: for specific workloads, usually with indexing and querying
```

## Practice Test Tips

GuardDuty:
```
When a company decides to stop use GuardDuty service + delete all existing findings: 
 ==> Disable the service in the general settings - 
 Disabling the service will delete all remaining data, including your findings and configurations before relinquishing the service permissions and resetting the service. So, this is the correct option for our use case.

Logs supported: VPC Flow Logs, DNS logs, CloudTrail events
```

Order of the storage charges($$$) incurred for the test file on storage types:
```
Cost of test file storage on S3 Standard < Cost of test file storage on EFS < Cost of test file storage on EBS
```

The company has been asked to block access from two countries and allow access only from the home country of the company ==> Configure AWS WAF on the Application Load Balancer in a VPC. 

Deletion of Customer Master Key(CMK) of KMS:
```
To delete a CMK in AWS KMS you schedule key deletion.
You can set the waiting period from a minimum of 7 days up to a maximum of 30 days.
The default waiting period is 30 days. During the waiting period, the CMK status and key state is Pending deletion.
To recover the CMK, you can cancel key deletion before the waiting period ends. After the waiting period ends you cannot cancel key deletion, and AWS KMS deletes the CMK.
```

The product team at a startup has figured out a market need to support both STATEFUL and STATELESS client-server communications via the APIs developed using its platform:
```
API Gateway creates RESTful APIs that enable stateless client-server communication and API Gateway also creates WebSocket APIs that adhere to the WebSocket protocol == which enables stateful, full-duplex communication between client and server
```

AWS Lambda currently supports 1000 concurrent executions per AWS account per region. If your Amazon SNS message deliveries to AWS Lambda contribute to crossing these concurrency quotas, your Amazon SNS message deliveries will be throttled. You need to contact AWS support to raise the account limit. 

To prevent your API from being overwhelmed by too many requests == Amazon API Gateway, Amazon SQS and Amazon Kinesis 

Continue to be processed even if any instance goes down, as the underlying application architecture would ensure the replacement instance has access to the required dataset == Use Instance Store based EC2 instances.

Company wants to migrate 70TB de cada 10 applicações para a Aws == Order 10 Snowball Edge Storage Optimized devices to complete the one-time data transfer + Setup Site-to-Site VPN to establish connectivity between the on-premises data center and AWS Cloud.