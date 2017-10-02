import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class CSVParser {

	Map<String,String> map = new HashMap<>();
	List<Map<String,String>> records = new ArrayList<>();
	/**
	 * Quick scrub
	 * @param s input strng
	 * @return clean string
	 */
	public String scrubQuote(String s) {
		String clean = s.trim();
		clean = clean.replaceAll("\"","");
		clean = clean.replaceAll("(.*)\\\\r\\\\n(.*)","$1$2");
		clean = clean.replaceAll("(.*)\\\\n(.*)","$1$2");
		return "\"" + clean + "\"";
	}
	/**
	 * slurp file in and scrub strings into lists, make maps
	 * @param fileName input file
	 * @throws IOException trouble reading file
	 */
	public void readFile(String fileName) throws IOException  {
		try {
			FileReader f = new FileReader(fileName);
			BufferedReader inStream = new BufferedReader(f);
	        String s;
	        List<String> header = null;
	        List<String> record = null;
	        int counter=0;
	        while ((s = inStream.readLine()) != null) {
	        	List<String> fields = (new ArrayList<>(Arrays.asList(s.split(",")))).stream().map( e -> scrubQuote(e)).collect(Collectors.toList());
	        	if (counter==0) {
	        		header = fields;
	        	} else {
	                record = fields;
	                map = new HashMap<>();
	                for (int i=0;i<header.size();i++) map.put(header.get(i),record.get(i));
	                records.add(map);
	        	}
	        	counter++;
	        }
	        inStream.close();
		} catch (FileNotFoundException e) {
			System.out.println("File Not Found");
			e.printStackTrace();
		}
		
	}
	
	public void dumpJSON() {
		System.out.println("{\n  \"payload\":[");
        List<String> payload = new ArrayList<>();
        records.stream().forEach((r) -> { 
        	StringBuffer rec = new StringBuffer();
        	r.entrySet().stream().forEach(e -> {
        		rec.append(e.getKey()).append(":").append(e.getValue()).append(",");
        	});
        	payload.add("{" + (rec.substring(0, rec.length()-1) + "}"));
        	rec.setLength(0);
        });
        String records = String.join(",\n",payload);
        System.out.println(records + "  ]\n}\n");
	}
	public static void main (String[] args)  {
		CSVParser csv = new CSVParser();
		try {
			csv.readFile("./testdata.txt");
			csv.dumpJSON();
		} catch (IOException e) {
			System.out.println("Error Reading File");
			e.printStackTrace();
		}
	}
}
