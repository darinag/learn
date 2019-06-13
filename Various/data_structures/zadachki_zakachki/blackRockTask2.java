import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

public class Main {
  /**
   * Iterate through each line of input.
   */
  public static void main(String[] args) throws IOException {
    InputStreamReader reader = new InputStreamReader(System.in, StandardCharsets.UTF_8);
    BufferedReader in = new BufferedReader(reader);
    String line;

    line = in.readLine();
    
    String[] parts = line.split("~");

    double loanAmount = Double.parseDouble(parts[0]);
    int period = Integer.parseInt(parts[1]);
    double interest = Double.parseDouble(parts[2]);
    double downPayment = Double.parseDouble(parts[3]);

    double loanAfterDownPayment = loanAmount - downPayment;

    double monthlyRate = (interest/100.0)/12.0;
    int numberOfMonths = period * 12;

    double monthlyFixedPayment = (monthlyRate * loanAfterDownPayment) / (1 - Math.pow(1 + monthlyRate, -numberOfMonths));

    double monthlyFixedPaymentFormatted = Math.round(monthlyFixedPayment*100.0)/100.0;

    double interestPaymentYearly = monthlyFixedPayment * 12;
    
    double interestPayment = interestPaymentYearly * period - loanAfterDownPayment;

    int totalInterestPayments = (int)Math.round(interestPayment);
    
    
    String answer = "$"  + Double.toString(monthlyFixedPaymentFormatted) + "~$" +Integer.toString(totalInterestPayments);
    System.out.println(answer);
    
    
  }
}
