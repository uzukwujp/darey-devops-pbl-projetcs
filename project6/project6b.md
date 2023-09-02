#### Step 1 — Prepare a Web Server 

1. Launch an EC2 instance that will serve as "Web Server". Create 3 volumes in the same AZ as your Web Server EC2, each of 10 GiB.

Learn How to Add EBS Volume to an EC2 instance [here](https://www.youtube.com/watch?v=HPXnXkBzIHw)

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project6/volume_creation.png" width="936px" height="550px">


2. Attach all three volumes one by one to your Web Server EC2 instance

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project6/attach_volume.png" width="936px" height="550px">


2. Open up the Linux terminal to begin configuration

3. Use [`lsblk`](https://man7.org/linux/man-pages/man8/lsblk.8.html) command to inspect what block devices are attached to the server. Notice names of your newly created devices. All devices in Linux reside in /dev/ directory. Inspect it with `ls /dev/` and make sure you see all 3 newly created block devices there - their names will likely be `xvdf`, `xvdh`, `xvdg`.

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project6/lsblk.png" width="936px" height="550px">



4. Use [`df -h`](https://en.wikipedia.org/wiki/Df_(Unix)) command to see all mounts and free space on your server

5. Use `gdisk` utility to create a single partition on each of the 3 disks


```
sudo gdisk /dev/xvdf
```

Output
"""
GPT fdisk (gdisk) version 1.0.3

Partition table scan:
  MBR: not present
  BSD: not present
  APM: not present
  GPT: not present

Creating new GPT entries.

Command (? for help branch segun-edits: p
Disk /dev/xvdf: 20971520 sectors, 10.0 GiB
Sector size (logical/physical): 512/512 bytes
Disk identifier (GUID): D936A35E-CE80-41A1-B87E-54D2044D160B
Partition table holds up to 128 entries
Main partition table begins at sector 2 and ends at sector 33
First usable sector is 34, last usable sector is 20971486
Partitions will be aligned on 2048-sector boundaries
Total free space is 2014 sectors (1007.0 KiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048        20971486   10.0 GiB    8E00  Linux LVM

Command (? for help): w

Final checks complete. About to write GPT data. THIS WILL OVERWRITE EXISTING
PARTITIONS!!

Do you want to proceed? (Y/N): yes
OK; writing new GUID partition table (GPT) to /dev/xvdf.
The operation has completed successfully.
Now,  your changes has been configured succesfuly, exit out of the gdisk console and do the same for the remaining disks.
"""



5. Use `lsblk` utility to view the newly configured partition on each of the 3 disks.

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project6/new_partitions.png" width="936px" height="550px">


6. Install [`lvm2`](https://en.wikipedia.org/wiki/Logical_Volume_Manager_(Linux)) package using `sudo yum install lvm2`. Run `sudo lvmdiskscan` command to check for available partitions.

**Note:** Previously, in Ubuntu we used `apt` command to install packages, in RedHat/CentOS a different package manager is used, so we shall use `yum` command instead.

7. Use [`pvcreate`](https://linux.die.net/man/8/pvcreate) utility to mark each of 3 disks as physical volumes (PVs) to be used by LVM

```
sudo pvcreate /dev/xvdf1
sudo pvcreate /dev/xvdg1
sudo pvcreate /dev/xvdh1

```

8. Verify that your Physical volume has been created successfully by running `sudo pvs`

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project6/pvs.png" width="936px" height="550px">



9.  Use [`vgcreate`](https://linux.die.net/man/8/vgcreate) utility to add all 3 PVs to a volume group (VG). Name the VG **webdata-vg**

> 
```
sudo vgcreate webdata-vg /dev/xvdh1 /dev/xvdg1 /dev/xvdf1
```

10. Verify that your VG has been created successfully by running `sudo vgs`

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project6/vgs.png" width="936px" height="550px">


11. Use [`lvcreate`](https://linux.die.net/man/8/lvcreate) utility to create 2 logical volumes.  **apps-lv** (***Use half of the PV size***), and **logs-lv** ***Use the remaining space of the PV size***. **NOTE**: apps-lv will be used to store data for the Website while, logs-lv will be used to store data for logs. 

```
sudo lvcreate -n apps-lv -L 14G webdata-vg
sudo lvcreate -n logs-lv -L 14G webdata-vg
```


12. Verify that your Logical Volume has been created successfully by running `sudo lvs`

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project6/lvs.png" width="936px" height="550px">


13.  Verify the entire setup
```
sudo vgdisplay -v #view complete setup - VG, PV, and LV
sudo lsblk 
```
<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project6/lsblk3.png" width="936px" height="550px">




1.  Use `mkfs.ext4` to format the logical volumes with [ext4](https://en.wikipedia.org/wiki/Ext4) filesystem

```
sudo mkfs -t ext4 /dev/webdata-vg/apps-lv
sudo mkfs -t ext4 /dev/webdata-vg/logs-lv
```

15. Create **/var/www/html** directory to store website files

     `sudo mkdir -p /var/www/html`

16. Create **/home/recovery/logs** to store backup of log data


      `sudo mkdir -p /home/recovery/logs`


17. Mount **/var/www/html** on **apps-lv** logical volume

```
sudo mount /dev/webdata-vg/apps-lv /var/www/html/
```

18. Use [`rsync`](https://linux.die.net/man/1/rsync) utility to backup all the files in the log directory **/var/log** into **/home/recovery/logs** (*This is required before mounting the file system*)

```
sudo rsync -av /var/log/. /home/recovery/logs/
```

19. Mount **/var/log** on **logs-lv** logical volume. (*Note that all the existing data on /var/log will be deleted. That is why step 15 above is very 
important*)

```
sudo mount /dev/webdata-vg/logs-lv /var/log
```

20. Restore log files back into **/var/log** directory

```
sudo rsync -av /home/recovery/logs/log/. /var/log
```

21. Update `/etc/fstab` file so that the mount configuration will persist after restart of the server.

The UUID of the  device will be used to update the `/etc/fstab` file;


`sudo blkid`

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project6/blkid.png" width="936px" height="550px">



sudo vi `/etc/fstab`

Update `/etc/fstab` in this format using your own UUID and rememeber to remove the leading and ending quotes.

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project6/fstab.png" width="936px" height="550px">


22.  Test the configuration and reload the daemon
   
     ```
     sudo mount -a
     sudo systemctl daemon-reload
     ```

23.   Verify your setup by running `df -h`, output must look like this:

<img src="https://darey-io-nonprod-pbl-projects.s3.eu-west-2.amazonaws.com/project6/df-h.png" width="936px" height="550px">
