"By default extract first sequence into a new file"
import sys
from Bio import SeqIO
from pathlib import Path

def get_reference(path_fasta, path_save):
    records = SeqIO.parse(path_fasta, "fasta")
    reference = next(records)
    
    Path(path_save).parent.mkdir(exist_ok=True,parents=True)
    SeqIO.write(reference, path_save, "fasta")

if __name__=="__main__":

    path_fasta = sys.argv[1]
    path_save = sys.argv[2]
    get_reference(path_fasta, path_save)
