package main;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CSVParser {


	Map<String,String> map = new HashMap<>();
	List<Map<String,String>> records = new ArrayList<>();
	public String scrubQuote(String s) {
		String clean = s;
		clean = clean.replaceAll("\r\n","");
		clean = clean.replaceAll("\"","");
		clean = clean.replaceAll("\n", "");
		return "\"" + clean + "\"";
	}
	public void readFile(String fileName) throws IOException  {
		try {
			FileReader f = new FileReader(fileName);
			BufferedReader inStream = new BufferedReader(f);
	        String s;
	        List<String> header = null;
	        List<String> record = null;
	        int counter=0;
	        while ((s = inStream.readLine()) != null) {
	        	if (counter==0) {
	        		header = new ArrayList<String>(Arrays.asList(s.split(",")));
	        	} else {
	                record = new ArrayList<String>(Arrays.asList(s.split(",")));
	                for (int i=0;i<header.size();i++) {
	                	map.put(scrubQuote(header.get(i).trim()), scrubQuote(record.get(i).trim()));
	                }
	                records.add(map);
	        	}
	        	counter++;
	        }
	        inStream.close();
	        System.out.println("{\n  \"payload\":[");
	        records.stream().forEach((r) -> {
	        	System.out.println("    " + r +",");
	        });
	        System.out.println("  ]\n}\n");

		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}

	}

	public static void main (String[] args)  {
		CSVParser csv = new CSVParser();
		try {
			csv.readFile("./testdata.txt");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
