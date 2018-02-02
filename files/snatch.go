package main

import (
	"flag"
	"fmt"
	"log"
	"time"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
	"os"
)

func main() {

	var snatchGroup string

	flag.StringVar(&snatchGroup, "snatch-group", "", "the snatch group to look for")
	flag.Parse()

	if snatchGroup == "" {
		fmt.Println("Please set a snatchgroup")
		os.Exit(1)
	}

	log.SetOutput(os.Stdout)

	sess := session.Must(session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
	}))

	l := 1
	for l < 2 {

		var freeInstances = []string{}
		var freeIps = []string{}

		///////////////////   Instances
		params := &ec2.DescribeInstancesInput{
			Filters: []*ec2.Filter{
				&ec2.Filter{
					Name:   aws.String("instance-state-name"),
					Values: []*string{aws.String("running")},
				},
				&ec2.Filter{
					Name:   aws.String("tag:snatch_group"),
					Values: []*string{aws.String(snatchGroup)},
				},
			},
		}

		ec2Svc := ec2.New(sess)
		result, err := ec2Svc.DescribeInstances(params)
		if err != nil {
			fmt.Println("Error", err)
		} else {
			for _, x := range result.Reservations {
				for _, i := range x.Instances {
					if i.PublicIpAddress == nil {
						freeInstances = append(freeInstances, *i.InstanceId)
						//fmt.Println(reflect.TypeOf(*i.InstanceId))
					}
				}
			}
		}

		///////////////////   Eips
		eipResult, err2 := ec2Svc.DescribeAddresses(&ec2.DescribeAddressesInput{
			Filters: []*ec2.Filter{
				{
					Name:   aws.String("tag:snatch_group"),
					Values: aws.StringSlice([]string{snatchGroup}),
				},
			},
		})
		if err2 != nil {
			fmt.Println("Unable to elastic IP address, %v", err2)
		}
		for _, k := range eipResult.Addresses {
			j := fmt.Sprintf("%d", k.AssociationId)
			if j == "0" {
				freeIps = append(freeIps, *k.AllocationId)
			}
		}

		///////////////////   Results
		if len(freeInstances) > 0 {
			if len(freeInstances) == len(freeIps) {
				for z, _ := range freeInstances {
					input := &ec2.AssociateAddressInput{
						AllocationId: aws.String(freeIps[z]),
						InstanceId:   aws.String(freeInstances[z]),
					}
					assoc, assoc_err := ec2Svc.AssociateAddress(input)
					if assoc_err != nil {
						fmt.Println(assoc_err)
					}
					log.Println(
							"Attaching ", freeIps[z],
							" to ", freeInstances[z], " with ",
							*assoc.AssociationId)
				}
			}
		}
		time.Sleep(30 * time.Second)
	}
}
