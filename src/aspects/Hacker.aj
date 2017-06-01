package aspects;

import telecom.Customer;

/**
 * Zadanie 4
 * 
 * Aspekt-haker:
 *  - przechwytuje odpowiednie wywołania metod w aspekcie implementującym autentykację,
 *  - na podstawie przechwyconych danych i wiedzy hakera, zmienia hasło użytkownika zaraz po jego
 *    wprowadzeniu, czym uniemożliwia wykonywanie połączeń.
 * 
 * @author Mateusz Kamiński
 */
public privileged aspect Hacker {
	
	pointcut hackercut(): cflow(adviceexecution()) && get(String Customer.password);
	
	before(Customer customer) : hackercut() && target(customer) {
		customer.password = "hacked!!";
	}
}
