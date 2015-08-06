plsa source code undeer Map-reduce frame
the input is doct word pair per-line
E_step M_step according to EM-algorithm

init folder: 
map: 	input source data, output doc-word
reduce: init EM parameters

EM folder:
E-step:
update p(topic|doc, word)

M-step:
update p(topic|doc) p(word|topic)=N(word,topic)|N(topic)

run scirpt:
map-reduce process