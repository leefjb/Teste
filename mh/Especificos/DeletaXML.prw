#INCLUDE "FILEIO.CH"

User Function DeletaXML()
                 
	Local cpath := "\system\gestorxml\02429547000132\problemas\"
	Local axmls := {}

	aAdd( aXmls, "31181068532076000282550010001318211560879631" )
	aAdd( aXmls, "31181068532076000282550010001318221652536037" )
	aAdd( aXmls, "31181168532076000282550010001347811820516576" )
	aAdd( aXmls, "32180905607657001026550210000772011005688858" )
	aAdd( aXmls, "32181005607657001026550210000787801006969333" )
	aAdd( aXmls, "33181004713666000148550010001974781599715240" )
	aAdd( aXmls, "33181108512043000168550020000005271485938800" )
	aAdd( aXmls, "35180801645409000390550010002201911006987910" )
	aAdd( aXmls, "35180801645409000390550010002205041006990390" )
	aAdd( aXmls, "35180801645409000390550010002205051006990400" )
	aAdd( aXmls, "35180801645409000390550010002208491006990908" )
	aAdd( aXmls, "35180801645409000390550010002208501006990917" )
	aAdd( aXmls, "35180801645409000390550010002216671007031795" )
	aAdd( aXmls, "35180818397259000183550010000030731081635240" )
	aAdd( aXmls, "35180843283811001202550010053169881272410549" )
	aAdd( aXmls, "35180901513946000114550030015825931014650844" )
	aAdd( aXmls, "35180901513946000114550030015858961014684988" )
	aAdd( aXmls, "35180901513946000114550030015859231014685398" )
	aAdd( aXmls, "35180901513946000114550030015859471014685683" )
	aAdd( aXmls, "35180901513946000114550030015874151014700524" )
	aAdd( aXmls, "35180901513946000114550030015919871014753159" )
	aAdd( aXmls, "35180901513946000114550030016001041014840310" )
	aAdd( aXmls, "35180901645409000390550010002260831007233816" )
	aAdd( aXmls, "35180901645409000390550010002261401007234381" )
	aAdd( aXmls, "35180901645409000390550010002261441007234429" )
	aAdd( aXmls, "35180901645409000390550010002282701007291044" )
	aAdd( aXmls, "35180901645409000390550010002284461007295835" )
	aAdd( aXmls, "35180901645409000390550010002284651007296969" )
	aAdd( aXmls, "35180901645409000390550010002287371007305030" )
	aAdd( aXmls, "35180901645409000390550010002291061007316851" )
	aAdd( aXmls, "35180901645409000390550010002295641007328510" )
	aAdd( aXmls, "35180901772798000233550010003608151007279797" )
	aAdd( aXmls, "35180901772798000233550010003617831007311517" )
	aAdd( aXmls, "35180901772798000233550010003620461007320519" )
	aAdd( aXmls, "35180901772798000233550010003622911007328168" )
	aAdd( aXmls, "35180907330175000106550010000172951005349056" )
	aAdd( aXmls, "35180907330175000106550010000173341002239551" )
	aAdd( aXmls, "35180954611678000130550010000336871007205576" )
	aAdd( aXmls, "35180954611678000130550010000337151005884359" )
	aAdd( aXmls, "35181001513946000114550030016045621014891830" )
	aAdd( aXmls, "35181001513946000114550030016158751015013740" )
	aAdd( aXmls, "35181001513946000114550030016169591015024985" )
	aAdd( aXmls, "35181001513946000114550030016169631015025020" )
	aAdd( aXmls, "35181001513946000114550030016207881015066812" )
	aAdd( aXmls, "35181001645409000390550010002297721007352430" )
	aAdd( aXmls, "35181001645409000390550010002298241007354296" )
	aAdd( aXmls, "35181001645409000390550010002298381007354615" )
	aAdd( aXmls, "35181001645409000390550010002302531007368264" )
	aAdd( aXmls, "35181001645409000390550010002302951007370196" )
	aAdd( aXmls, "35181001645409000390550010002304241007380913" )
	aAdd( aXmls, "35181001645409000390550010002304251007380929" )
	aAdd( aXmls, "35181001645409000390550010002304431007381680" )
	aAdd( aXmls, "35181001645409000390550010002305581007385498" )
	aAdd( aXmls, "35181001645409000390550010002307571007395306" )
	aAdd( aXmls, "35181001645409000390550010002307631007395362" )
	aAdd( aXmls, "35181001645409000390550010002309901007403711" )
	aAdd( aXmls, "35181001645409000390550010002316701007427551" )
	aAdd( aXmls, "35181001645409000390550010002318271007429902" )
	aAdd( aXmls, "35181001645409000390550010002319361007432533" )
	aAdd( aXmls, "35181001645409000390550010002321201007439458" )
	aAdd( aXmls, "35181001645409000390550010002333291007487607" )
	aAdd( aXmls, "35181001645409000390550010002333311007487680" )
	aAdd( aXmls, "35181001645409000390550010002333601007488727" )
	aAdd( aXmls, "35181001645409000390550010002334571007495162" )
	aAdd( aXmls, "35181001645409000390550010002334811007495494" )
	aAdd( aXmls, "35181001645409000390550010002335301007496080" )
	aAdd( aXmls, "35181001645409000390550010002338231007506176" )
	aAdd( aXmls, "35181001645409000390550010002338391007506842" )
	aAdd( aXmls, "35181001645409000390550010002341111007517971" )
	aAdd( aXmls, "35181001645409000390550010002341171007518050" )
	aAdd( aXmls, "35181001645409000390550010002341921007519433" )
	aAdd( aXmls, "35181001645409000390550010002346531007534865" )
	aAdd( aXmls, "35181001645409000390550010002347521007537439" )
	aAdd( aXmls, "35181001645409000390550010002347711007539151" )
	aAdd( aXmls, "35181001645409000390550010002347811007539719" )
	aAdd( aXmls, "35181001645409000390550010002347821007539724" )
	aAdd( aXmls, "35181001645409000390550010002348771007543808" )
	aAdd( aXmls, "35181001645409000390550010002349241007553791" )
	aAdd( aXmls, "35181001645409000390550010002349571007555450" )
	aAdd( aXmls, "35181001645409000390550010002351401007561705" )
	aAdd( aXmls, "35181001645409000390550010002355601007601469" )
	aAdd( aXmls, "35181001645409000390550010002357651007607723" )
	aAdd( aXmls, "35181001772798000233550010003628541007365526" )
	aAdd( aXmls, "35181001772798000233550010003632141007379540" )
	aAdd( aXmls, "35181001772798000233550010003634321007388050" )
	aAdd( aXmls, "35181001772798000233550010003643051007410685" )
	aAdd( aXmls, "35181001772798000233550010003643171007410988" )
	aAdd( aXmls, "35181001772798000233550010003654041007440196" )
	aAdd( aXmls, "35181001772798000233550010003658271007449793" )
	aAdd( aXmls, "35181001772798000233550010003667791007475501" )
	aAdd( aXmls, "35181001772798000233550010003669651007480454" )
	aAdd( aXmls, "35181001772798000233550010003691021007541232" )
	aAdd( aXmls, "35181001772798000233550010003691231007542352" )
	aAdd( aXmls, "35181003495939000162550010000019921008550059" )
	aAdd( aXmls, "35181005785287000126550550000145741000203580" )
	aAdd( aXmls, "35181007330175000106550010000174581007699140" )
	aAdd( aXmls, "35181007330175000106550010000174591002119585" )
	aAdd( aXmls, "35181007586045000210550010000070521344672454" )
	aAdd( aXmls, "35181009570531000194550010000013181000007777" )
	aAdd( aXmls, "35181009570531000194550010000013431000007770" )
	aAdd( aXmls, "35181054611678000130550010000337561000035119" )
	aAdd( aXmls, "35181101513946000114550030016298291015170651" )
	aAdd( aXmls, "35181101513946000114550030016314951015187482" )
	aAdd( aXmls, "35181101513946000114550030016316291015189065" )
	aAdd( aXmls, "35181101513946000114550030016316861015189703" )
	aAdd( aXmls, "35181101513946000114550030016375451015249993" )
	aAdd( aXmls, "35181101513946000114550030016391601015266425" )
	aAdd( aXmls, "35181101513946000114550030016407221015282204" )
	aAdd( aXmls, "35181101513946000114550030016502981015391270" )
	aAdd( aXmls, "35181101645409000390550010002362071007626040" )
	aAdd( aXmls, "35181101645409000390550010002362571007626549" )
	aAdd( aXmls, "35181101645409000390550010002364111007637143" )
	aAdd( aXmls, "35181101645409000390550010002364251007637378" )
	aAdd( aXmls, "35181101645409000390550010002364441007637578" )
	aAdd( aXmls, "35181101645409000390550010002364451007637583" )
	aAdd( aXmls, "35181101645409000390550010002366621007646347" )
	aAdd( aXmls, "35181101645409000390550010002367191007647925" )
	aAdd( aXmls, "35181101645409000390550010002368511007653910" )
	aAdd( aXmls, "35181101645409000390550010002368871007654943" )
	aAdd( aXmls, "35181101645409000390550010002368881007654959" )
	aAdd( aXmls, "35181101645409000390550010002371601007666367" )
	aAdd( aXmls, "35181101645409000390550010002382561007730380" )
	aAdd( aXmls, "35181101645409000390550010002384221007738058" )
	aAdd( aXmls, "35181101645409000390550010002384351007738315" )
	aAdd( aXmls, "35181101645409000390550010002384451007738419" )
	aAdd( aXmls, "35181101645409000390550010002385861007745545" )
	aAdd( aXmls, "35181101645409000390550010002386571007746260" )
	aAdd( aXmls, "35181101645409000390550010002386761007746451" )
	aAdd( aXmls, "35181101645409000390550010002386771007746467" )
	aAdd( aXmls, "35181101645409000390550010002386941007746638" )
	aAdd( aXmls, "35181101645409000390550010002387011007747002" )
	aAdd( aXmls, "35181101645409000390550010002387091007748023" )
	aAdd( aXmls, "35181101645409000390550010002388031007755919" )
	aAdd( aXmls, "35181101645409000390550010002390231007762854" )
	aAdd( aXmls, "35181101645409000390550010002393451007779050" )
	aAdd( aXmls, "35181101645409000390550010002393641007779276" )
	aAdd( aXmls, "35181101645409000390550010002394161007779797" )
	aAdd( aXmls, "35181101645409000390550010002394501007780797" )
	aAdd( aXmls, "35181101645409000390550010002394881007782193" )
	aAdd( aXmls, "35181101645409000390550010002396131007784919" )
	aAdd( aXmls, "35181101645409000390550010002397511007791954" )
	aAdd( aXmls, "35181101645409000390550010002398141007793088" )
	aAdd( aXmls, "35181101645409000390550010002405091007825652" )
	aAdd( aXmls, "35181101645409000390550010002405231007825791" )
	aAdd( aXmls, "35181101645409000390550010002407581007836706" )
	aAdd( aXmls, "35181101645409000390550010002407591007836711" )
	aAdd( aXmls, "35181101645409000390550010002407601007836720" )
	aAdd( aXmls, "35181101645409000390550010002407691007836904" )
	aAdd( aXmls, "35181101772798000233550010003723271007668114" )
	aAdd( aXmls, "35181101772798000233550010003771061007843074" )
	aAdd( aXmls, "35181101772798000667550010000001081007739170" )
	aAdd( aXmls, "35181104440002000152550010000337641575963065" )
	aAdd( aXmls, "35181105785287000126550550000149981000208350" )
	aAdd( aXmls, "35181105785287000126550550000150291000392221" )
	aAdd( aXmls, "35181105785287000126550550000150621000392919" )
	aAdd( aXmls, "35181107330175000106550010000175971009815560" )
	aAdd( aXmls, "35181107330175000106550010000176111005178877" )
	aAdd( aXmls, "35181109570531000194550010000013561000007771" )
	aAdd( aXmls, "35181109570531000194550010000013651000007770" )
	aAdd( aXmls, "35181130970796000176550000000018061009008007" )
	aAdd( aXmls, "35181201645409000390550010002441841008017309" )
	aAdd( aXmls, "41180918291007000175550010000016721521545328" )
	aAdd( aXmls, "41180922714386000136550010000027541635494581" )
	aAdd( aXmls, "41180923314819000129550010000070131544521462" )
	aAdd( aXmls, "41181004737413000104550010000140481009799177" )
	aAdd( aXmls, "41181004737413000104550010000140491008119811" )
	aAdd( aXmls, "41181004737413000104550010000140531007664860" )
	aAdd( aXmls, "41181004737413000104550010000140541002236271" )
	aAdd( aXmls, "41181023314819000129550010000071661845128530" )
	aAdd( aXmls, "41181104737413000104550010000141511003748877" )
	aAdd( aXmls, "41181104737413000104550010000141551005373152" )
	aAdd( aXmls, "41181118291007000175550010000017641510992716" )
	aAdd( aXmls, "41181118291007000175550010000018161376871776" )
	aAdd( aXmls, "42181000379858001008550010000353991565130770" )
	aAdd( aXmls, "42181033250713000243550550001148601000106215" )
	aAdd( aXmls, "42181033250713000243550550001148611000113367" )
	aAdd( aXmls, "42181075877092000191550010000391251319501001" )
	aAdd( aXmls, "42181075877092000191550010000391411571446960" )
	aAdd( aXmls, "42181133250713000243550550001160101000188863" )
	aAdd( aXmls, "42181133250713000243550550001171581000204544" )
	aAdd( aXmls, "42181133250713000243550550001173831000016148" )
	aAdd( aXmls, "42181133250713000243550550001173861000024827" )
	aAdd( aXmls, "42181081601825000163550010000260881788444429" )
	aAdd( aXmls, "43180889054050000165550010014564351020986003" )
	aAdd( aXmls, "43180887827689002405550020000651891254676121" )
	aAdd( aXmls, "43180887827689002405550020000651901838390857" )
	aAdd( aXmls, "42190121318524000103550010004906321004019710" )
	aAdd( aXmls, "42190121318524000103550010004907491008184157" )
	aAdd( aXmls, "42190121318524000103550010004907691000184150" )
	aAdd( aXmls, "42190121318524000103550010004907861009136125" )
	aAdd( aXmls, "43180803484457000107550010000598991059899360" )
	aAdd( aXmls, "43180804328070000124550010000322551200902119" )
	aAdd( aXmls, "43180804983576000177550010000068801000068809" )
	aAdd( aXmls, "43180808976823000169550010000485861754580051" )
	aAdd( aXmls, "43180902336327000164550010000135971000035583" )
	aAdd( aXmls, "43180904328070000124550010000327501281342032" )
	aAdd( aXmls, "43180908736011000812550010000045511980987147" )
	aAdd( aXmls, "43180908736011000812550010000045741869606690" )
	aAdd( aXmls, "43180926982803000182550010000003851000003857" )
	aAdd( aXmls, "43180972457211000169550010000000961000423453" )
	aAdd( aXmls, "43180973297509000111550020000489551005760158" )
	aAdd( aXmls, "43180987020517000120550010000783461603863031" )
	aAdd( aXmls, "43180987020517000120550010000783471585020047" )
	aAdd( aXmls, "43180987020517000120550010000783481842670689" )
	aAdd( aXmls, "43180987827689002405550020000660101192510791" )
	aAdd( aXmls, "43180987827689002405550020000660891733208449" )
	aAdd( aXmls, "43180987827689002405550020000660921911360506" )
	aAdd( aXmls, "43180987827689002405550020000661111819146460" )
	aAdd( aXmls, "43180987827689002405550020000661131255078465" )
	aAdd( aXmls, "43180987827689002405550020000661381733208445" )
	aAdd( aXmls, "43180987827689002405550020000661521934788855" )
	aAdd( aXmls, "43180987827689002405550020000661691779860605" )
	aAdd( aXmls, "43180987827689002405550020000661851911360507" )
	aAdd( aXmls, "43180987827689002405550020000662231911360500" )
	aAdd( aXmls, "43180987827689002405550020000662391192510790" )
	aAdd( aXmls, "43180987827689002405550020000662551888038000" )
	aAdd( aXmls, "43180987827689002405550020000662561819146468" )
	aAdd( aXmls, "43180987958674000181558900210362401827898740" )
	aAdd( aXmls, "43180987958674000181558900211484331968209160" )
	aAdd( aXmls, "43180989054050000165550010014677731021167625" )
	aAdd( aXmls, "43180989054050000165550010014700381021206927" )
	aAdd( aXmls, "43180992224823000119550050000372131000606597" )
	aAdd( aXmls, "43181003484457000107550010000609221060922270" )
	aAdd( aXmls, "43181004328070000124550010000328141041036513" )
	aAdd( aXmls, "43181004328070000124550010000328971101357569" )
	aAdd( aXmls, "43181004328070000124550010000329351151446142" )
	aAdd( aXmls, "43181004328070000124550010000330981290921236" )
	aAdd( aXmls, "43181004383146000114550010000382271000483402" )
	aAdd( aXmls, "43181004983576000177550010000070011000070014" )
	aAdd( aXmls, "43181007244030000192550010000450931000574660" )
	aAdd( aXmls, "43181008618763000102550020000003321939957133" )
	aAdd( aXmls, "43181008702530000193550000000001721562315115" )
	aAdd( aXmls, "43181008736011000812550010000048591017881629" )
	aAdd( aXmls, "43181008976823000169550010000494301271302305" )
	aAdd( aXmls, "43181010144148000153550010000061791222205300" )
	aAdd( aXmls, "43181013374200000156550010000115901588289246" )
	aAdd( aXmls, "43181017523868000179550020000000691474361512" )
	aAdd( aXmls, "43181017523868000179550020000000711543573470" )
	aAdd( aXmls, "43181026982803000182550010000004041000004044" )
	aAdd( aXmls, "43181073297509000111550020000491681001599785" )
	aAdd( aXmls, "43181073297509000111550020000496871001205534" )
	aAdd( aXmls, "43181073297509000111550020000497101000862337" )
	aAdd( aXmls, "43181073297509000111550020000497111009578833" )
	aAdd( aXmls, "43181073297509000111550020000497711009558830" )
	aAdd( aXmls, "43181073297509000111550020000499631005668118" )
	aAdd( aXmls, "43181087020517000120550010000785541082121531" )
	aAdd( aXmls, "43181087020517000120550010000787061064567381" )
	aAdd( aXmls, "43181087020517000120550010000787711155208862" )
	aAdd( aXmls, "43181087020517000120550010000787841231414705" )
	aAdd( aXmls, "43181087138145000131550010000485681349639821" )
	aAdd( aXmls, "43181087138145000131550010000486381047507570" )
	aAdd( aXmls, "43181087827689002405550020000663241274984829" )
	aAdd( aXmls, "43181087827689002405550020000663581274984827" )
	aAdd( aXmls, "43181087827689002405550020000663711819146460" )
	aAdd( aXmls, "43181087827689002405550020000663721255078467" )
	aAdd( aXmls, "43181087827689002405550020000663951320160376" )
	aAdd( aXmls, "43181087827689002405550020000664361255078466" )
	aAdd( aXmls, "43181087827689002405550020000664531945721521" )
	aAdd( aXmls, "43181087827689002405550020000664541716754070" )
	aAdd( aXmls, "43181087827689002405550020000665401257312278" )
	aAdd( aXmls, "43181087827689002405550020000665541320160374" )
	aAdd( aXmls, "43181087827689002405550020000665621526754433" )
	aAdd( aXmls, "43181087827689002405550020000665931157526121" )
	aAdd( aXmls, "43181087827689002405550020000667031838390852" )
	aAdd( aXmls, "43181087827689002405550020000667061911360506" )
	aAdd( aXmls, "43181087827689002405550020000667651733208445" )
	aAdd( aXmls, "43181087827689002405550020000667691911360506" )
	aAdd( aXmls, "43181087827689002405550020000667811733208449" )
	aAdd( aXmls, "43181087827689002405550020000667941733208447" )
	aAdd( aXmls, "43181087827689002405550020000668721139131141" )
	aAdd( aXmls, "43181087827689002405550020000669121577540406" )
	aAdd( aXmls, "43181087827689002405550020000670001838390857" )
	aAdd( aXmls, "43181087827689002405550020000670051157526126" )
	aAdd( aXmls, "43181087827689002405550020000670551139131141" )
	aAdd( aXmls, "43181087827689002405550020000671311819146468" )
	aAdd( aXmls, "43181087827689002405550020000671511733208441" )
	aAdd( aXmls, "43181087827689002405550020000671891779860602" )
	aAdd( aXmls, "43181087958674000181558900212451121204255650" )
	aAdd( aXmls, "43181087958674000181558900213302721400734166" )
	aAdd( aXmls, "43181087958674000181558900214278521022553699" )
	aAdd( aXmls, "43181087958674000181558900215291881472200610" )
	aAdd( aXmls, "43181087958674000181558900215683341242576589" )
	aAdd( aXmls, "43181087958674000181558900216007211416468180" )
	aAdd( aXmls, "43181088115134000107550050000165451000165453" )
	aAdd( aXmls, "43181088258884000120550170000024121009311150" )
	aAdd( aXmls, "43181088297544000108550550002179161565171031" )
	aAdd( aXmls, "43181089054050000165550010014722931021243018" )
	aAdd( aXmls, "43181089054050000165550010014746541021283250" )
	aAdd( aXmls, "43181089054050000165550010014770721021322416" )
	aAdd( aXmls, "43181089054050000165550010014785661021346115" )
	aAdd( aXmls, "43181089054050000165550010014800511021369406" )
	aAdd( aXmls, "43181089054050000165550010014800521021369411" )
	aAdd( aXmls, "43181089054050000165550010014805681021377152" )
	aAdd( aXmls, "43181089054050000165550010014831851021417599" )
	aAdd( aXmls, "43181089054050000165550010014851311021447690" )
	aAdd( aXmls, "43181089237911006858550000000336161275274782" )
	aAdd( aXmls, "43181089237911006858550000000336171774351771" )
	aAdd( aXmls, "43181089237911006858550000000338421380044091" )
	aAdd( aXmls, "43181092660406001433550050005719421000217358" )
	aAdd( aXmls, "43181092660406001433550050005725431000246706" )
	aAdd( aXmls, "43181092726819000400550010000421831003668240" )
	aAdd( aXmls, "43181092749241000156550010003131651005773033" )
	aAdd( aXmls, "43181092785989000104550010003102661003320361" )
	aAdd( aXmls, "43181092821701000100550050141472831924906660" )
	aAdd( aXmls, "43181092821701000100550050142227871534565515" )
	aAdd( aXmls, "43181092821701000100550050142233501353869787" )
	aAdd( aXmls, "43181092980796000104550010000225351747212723" )
	aAdd( aXmls, "43181093201101000101550550000136761620921016" )
	aAdd( aXmls, "43181100212675000102550010002917511705514585" )
	aAdd( aXmls, "43181100212675000366550020001648151705582404" )
	aAdd( aXmls, "43181100212675000366550020001650831705582545" )
	aAdd( aXmls, "43181100212675000366550020001653221705582660" )
	aAdd( aXmls, "43181104328070000124550010000331421011031321" )
	aAdd( aXmls, "43181104328070000124550010000331691051022173" )
	aAdd( aXmls, "43181104328070000124550010000332111080901533" )
	aAdd( aXmls, "43181104328070000124550010000332491120959526" )
	aAdd( aXmls, "43181104328070000124550010000333201190951041" )
	aAdd( aXmls, "43181104328070000124550010000333861230906221" )
	aAdd( aXmls, "43181104328070000124550010000334311270854599" )
	aAdd( aXmls, "43181104328070000124550010000335001301351037" )
	aAdd( aXmls, "43181104474886000166550010000171901118979490" )
	aAdd( aXmls, "43181104983576000177550010000070991000070994" )
	aAdd( aXmls, "43181105150637000501550010001020721600085348" )
	aAdd( aXmls, "43181105596445000108550010000132341000132340" )
	aAdd( aXmls, "43181105677050000121550010001971781000000192" )
	aAdd( aXmls, "43181105798240000105550010000007661141773070" )
	aAdd( aXmls, "43181106016957000102550010000383951302346770" )
	aAdd( aXmls, "43181108976823000169550010000496991054259540" )
	aAdd( aXmls, "43181108976823000169550010000497031686229455" )
	aAdd( aXmls, "43181108976823000169550010000497811537032460" )
	aAdd( aXmls, "43181173297509000111550020000506391003112109" )
	aAdd( aXmls, "43181173297509000111550020000506561005185112" )
	aAdd( aXmls, "43181173297509000111550020000506791005112101" )
	aAdd( aXmls, "43181173297509000111550020000503801001379337" )
	aAdd( aXmls, "43181173297509000111550020000503811008208845" )
	aAdd( aXmls, "43181173297509000111550020000504821009811211" )
	aAdd( aXmls, "43181173297509000111550020000501081001999692" )
	aAdd( aXmls, "43181173297509000111550020000500461005112116" )
	aAdd( aXmls, "43181112035062000118550010000162391003119077" )
	aAdd( aXmls, "43181117523868000179550020000000741922615630" )
	aAdd( aXmls, "43181121853131000191550010000016281000007262" )
	aAdd( aXmls, "43181173297509000111550020000507141002272931" )
	aAdd( aXmls, "43181173297509000111550020000507421006911216" )
	aAdd( aXmls, "43181173297509000111550020000508331000667638" )
	aAdd( aXmls, "43181173297509000111550020000508671005025586" )
	aAdd( aXmls, "43181173749889000188550010000619251000619255" )
	aAdd( aXmls, "43181187020517000120550010000789351643661572" )
	aAdd( aXmls, "43181187020517000120550010000789361840105173" )
	aAdd( aXmls, "43181187020517000120550010000790051247575289" )
	aAdd( aXmls, "43181187020517000120550010000790061585072267" )
	aAdd( aXmls, "43181187020517000120550010000790121267426275" )
	aAdd( aXmls, "43181187020517000120550010000790161681712324" )
	aAdd( aXmls, "43181187020517000120550010000790291461508025" )
	aAdd( aXmls, "43181187020517000120550010000791531151117355" )
	aAdd( aXmls, "43181187138145000131550010000497561421292533" )
	aAdd( aXmls, "43181187138145000131550010000499711766602216" )
	aAdd( aXmls, "43181187827689002405550020000672131139131146" )
	aAdd( aXmls, "43181187827689002405550020000672471320160371" )
	aAdd( aXmls, "43181187827689002405550020000673261059057989" )
	aAdd( aXmls, "43181187827689002405550020000673941176449964" )
	aAdd( aXmls, "43181187827689002405550020000674331274984821" )
	aAdd( aXmls, "43181187827689002405550020000675631059057983" )
	aAdd( aXmls, "43181187827689002405550020000675741934788852" )
	aAdd( aXmls, "43181187827689002405550020000677291320160370" )
	aAdd( aXmls, "43181187827689002405550020000677701255078462" )
	aAdd( aXmls, "43181187827689002405550020000678561838390850" )
	aAdd( aXmls, "43181187827689002405550020000680271320160372" )
	aAdd( aXmls, "43181187827689002405550020000680281274984824" )
	aAdd( aXmls, "43181187827689002405550020000680391888038009" )
	aAdd( aXmls, "43181187827689002405550020000680411819146467" )
	aAdd( aXmls, "43181187958674000181558900216736181388866859" )
	aAdd( aXmls, "43181187958674000181558900217277711558526170" )
	aAdd( aXmls, "43181187958674000181558900217604611206383259" )
	aAdd( aXmls, "43181187958674000181558900217999141410399604" )
	aAdd( aXmls, "43181187958674000181558900219579161077407829" )
	aAdd( aXmls, "43181187958674000181558900219992031331571491" )
	aAdd( aXmls, "43181187958674000181558900219992421112589423" )
	aAdd( aXmls, "43181188115134000107550050000171161000171164" )
	aAdd( aXmls, "43181188241617000140550010000041031034470953" )
	aAdd( aXmls, "43181188297544000108550550002219451313375645" )
	aAdd( aXmls, "43181189054050000165550010014892131021514869" )
	aAdd( aXmls, "43181189054050000165550010014937921021586085" )
	aAdd( aXmls, "43181189054050000165550010014939231021588138" )
	aAdd( aXmls, "43181189054050000165550010014960661021622664" )
	aAdd( aXmls, "43181189054050000165550010014961111021623366" )
	aAdd( aXmls, "43181189237911006858550000000340531405612843" )
	aAdd( aXmls, "43181189848543937080550020004122101000103259" )
	aAdd( aXmls, "43181192660406001433550050005737501000314853" )
	aAdd( aXmls, "43181192821701000100550050143527071029192304" )
	aAdd( aXmls, "43181193234086000106550010207921511002784840" )
	aAdd( aXmls, "43181194230349000163550010000058291000058292" )
	aAdd( aXmls, "35180902525807000173550010000058571000299450" )
	aAdd( aXmls, "35180902525807000173550010000058581000299474" )
	
	ProcRegua( Len( aXmls ) )
	
	For nX := 1 To Len( aXmls )
	
		IncProc("Deletando arquivo "+ cValToChar( nX ) +" de "+ cValToChar( Len( aXmls ) ) )
		
		cFile := cpath + aXmls[ nX ] + "-procnfe.xml"
		
		If File( cFile )
			FErase( cFile )
		EndIf

		cFile := cpath + aXmls[ nX ] + "-proccte.xml"
		
		If File( cFile )
			FErase( cFile )
		EndIf
	
	Next
	
Return