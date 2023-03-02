# credits: https://gist.github.com/sciccolella/0c223012eb00b27a5c08f2bd8a09f95e
def main(args):
    bam_file = args.BAM
    bam = pysam.AlignmentFile(bam_file, "rb")
    seqs = {}
    r = [None]
    if args.region:
        r = [args.region.split(":")[0]] + [int(x) for x in args.region.split(":")[1].split("-")]

    for read in bam.fetch(*r):
        seqs[read.query_name] = ""
        # check len(read), are they of the same len?
        
    for plp_col in bam.pileup(*r):
        pos = plp_col.reference_pos
        if len(r) == 1 or (pos > r[1] and pos < r[2]):
            for plp_read in plp_col.pileups:
                if not plp_read.is_del and not plp_read.is_refskip:
                    seqs[plp_read.alignment.query_name] += plp_read.alignment.query_sequence[plp_read.query_position]
                else:
                    seqs[plp_read.alignment.query_name] += "-"
    for k in seqs:
        print(">", k, sep="")
        print(seqs[k])

if __name__ == "__main__":
    import pysam
    import argparse

    parser = argparse.ArgumentParser(description=str(__file__))
    parser.add_argument('BAM', type=str, help="BAM file")
    parser.add_argument('-r', '--region', type=str, help="REGION", required=False)

    args = parser.parse_args()
    main(args)