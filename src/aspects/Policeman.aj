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

	pointcut policemancut(): adviceexecution() && !within(Policeman);
	
	String around(Customer callingCustomer) : policemancut() && args(callingCustomer) {
		return callingCustomer.getPassword();
	}
}
