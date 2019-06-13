import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Scanner;

class Company {
  String companyName;
  String assetType;
  int shares;
  double price;
  double accruedInterest;
  String trade;
}

@SuppressWarnings("unchecked")
class Main {
  public static void main(String[] args) throws IOException {
    InputStreamReader reader = new InputStreamReader(System.in, StandardCharsets.UTF_8);
    BufferedReader in = new BufferedReader(reader);
    String input = in.readLine();
  
    Main portfolioMatcher = new Main();
    List<Company> companiesInPortfolio = portfolioMatcher.getCompanies(input.split(":")[0]);
    List<Company> companiesInBenchMark = portfolioMatcher.getCompanies(input.split(":")[1]);
    portfolioMatcher.printTransactions(companiesInPortfolio, companiesInBenchMark);
  
  }
  public void printTransactions(List<Company> companiesInPortfolio, List companiesInBenchMark) {
      double totalMarketValuePortfolio = calculateTotalMarketValue(companiesInPortfolio);
      double totalMarketValueBenchMark = calculateTotalMarketValue(companiesInPortfolio);
      List<Company> resultCompanies = new ArrayList();
      
      for (Company company : companiesInPortfolio) {
        Company companyInBenchMark = getSameCompanyFromBenchMarks(companiesInBenchMark, company);
        double portfolioCompanyMarketValue = 0;
        if ("STOCK".equalsIgnoreCase(company.assetType)) {
          portfolioCompanyMarketValue = company.shares * company.price;
        } else if ("BOND".equalsIgnoreCase(company.assetType)) {
          portfolioCompanyMarketValue = (company.shares * (company.price + company.accruedInterest) * 0.01);
        }
  
        double benchMarkCompanyMarketValue = 0;
        if ("STOCK".equalsIgnoreCase(companyInBenchMark.assetType)) {
          benchMarkCompanyMarketValue = (companyInBenchMark.shares * companyInBenchMark.price);
        } else if ("BOND".equalsIgnoreCase(companyInBenchMark.assetType)) {
          benchMarkCompanyMarketValue = (companyInBenchMark.shares * (companyInBenchMark.price + companyInBenchMark.accruedInterest) * 0.01);
        }
  
        String result = "";
        if (portfolioCompanyMarketValue < benchMarkCompanyMarketValue) {
          double differenceValue = benchMarkCompanyMarketValue - portfolioCompanyMarketValue;
          double sharesToBuy = 0;
  
          if ("STOCK".equalsIgnoreCase(companyInBenchMark.assetType)) {
            sharesToBuy = (differenceValue / company.price);
          } else if ("BOND".equalsIgnoreCase(companyInBenchMark.assetType)) {
              sharesToBuy = (differenceValue / (company.price * 0.01));
            }
    
            Company c= new Company();
            c.trade ="BUY";
            c.companyName = company.companyName;
            c.shares = (int) Math.round(sharesToBuy);
            resultCompanies.add(c);
            result = result + "BUY," + company.companyName + "," + (int) Math.round(sharesToBuy);
  
          } else if (portfolioCompanyMarketValue > benchMarkCompanyMarketValue) {
              double differenceValue = portfolioCompanyMarketValue - benchMarkCompanyMarketValue;
              double sharesToBuy = 0;
        
              if ("STOCK".equalsIgnoreCase(companyInBenchMark.assetType)) {
                sharesToBuy = (differenceValue / company.price);
              } else if ("BOND".equalsIgnoreCase(companyInBenchMark.assetType)) {
                sharesToBuy = (differenceValue / (company.price * 0.01));
              }
    
              Company c= new Company();
              c.trade ="SELL";
              c.companyName = company.companyName;
              c.shares = (int) Math.round(sharesToBuy);
              resultCompanies.add(c);
          }
      }
  
        Collections.sort(resultCompanies, new Comparator<Company>(){
          public int compare(Company o1, Company o2) {
            return o1.companyName.compareTo(o2.companyName);
          }
        });
    
        for(Company c: resultCompanies) {
          System.out.println(c.trade+"," + c.companyName + "," + c.shares);
        }
      }
  
  private double calculateTotalMarketValue(List<Company> companies) {
    double totalMarketValue = 0;
    for (Company company : companies) {
      if ("STOCK".equalsIgnoreCase(company.assetType)) {
        totalMarketValue = totalMarketValue + company.shares * company.price;
      } else if ("BOND".equalsIgnoreCase(company.assetType)) {
        totalMarketValue = totalMarketValue + company.shares * ((company.price + company.accruedInterest) * 0.01);
      }
    }
    return totalMarketValue;
  }
  
  public List getCompanies(String value) {
      String[] companyString = value.split("\\|");
      List companiesList = new ArrayList();
      for (int i = 0; i < companyString.length; i++) {
        Company company = getCompany(companyString[i]);
        companiesList.add(company);
      }
      return companiesList;
  }
  
  private Company getCompany(String value) {
      Company company = new Company();
      String[] companyData = value.split(",");
      company.companyName = companyData[0];
      company.assetType = companyData[1];
      company.shares = Integer.parseInt(companyData[2]);
      company.price = Double.parseDouble(companyData[3]);
      company.accruedInterest = Double.parseDouble(companyData[4]);
      return company;
  }
  
  
  private Company getSameCompanyFromBenchMarks(List<Company> companiesInBenchMark, Company targetCompany) {
      for (Company company : companiesInBenchMark) {
        if (company.companyName.equalsIgnoreCase(targetCompany.companyName)) {
          return company;
      }
  }
      return null;
    }
  }