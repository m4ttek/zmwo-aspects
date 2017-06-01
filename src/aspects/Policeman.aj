package aspects;

import telecom.Customer;

/**
 * Zadanie 4
 * 
 * Aspekt-policjant:
 *  - anuluje działania hakera, korzystając z wiedzy o wykorzystywanych przez niego aspektach
 * 
 * @author Mateusz Kamiński
 */
public aspect Policeman {

	pointcut policemancut(): set(String Customer.password) && !within(Customer);
	
	Object around(String hackedPass) : policemancut() && args(hackedPass) {
		return null;
	}
}
