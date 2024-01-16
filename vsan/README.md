# vsan

## troubleshooting

### If a node is not communicating properly, vms will be inaccessible.

Check members of the cluster
```
esxcli vsan cluster get
```

Review the `Sub-Cluster Member HostNames:` field. You should see all the members of your cluster.  If a cluster member is missing, re-join the missing member.

From a working cluster member. Copy the sub cluster UUID.
```
esxcli vsan cluster get | "Sub-Cluster UUID:"
```

On the not working cluster member. Leave and join the cluster.
```
esxcli vsan cluster leave
esxcli vsan cluster join -u <SUB CLUSTER UUID>
esxcli vsan cluster get
```

You should now see all the members of your cluster.
