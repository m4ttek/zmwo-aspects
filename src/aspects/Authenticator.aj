package aspects;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;
import java.util.function.Consumer;

import telecom.Call;
import telecom.Customer;

/**
 * Zadanie 3.
 * 
 * Aspekt realizuje autentykację klienta przy wykonywaniu połączeń, na podstawie:
 * - pobiera hasło od użytkownika,
 * - weryfikuje hasło w momencie wykonywania przez użytkownika połączenia wychodzącego.
 *  
 *	Informacje o użytkownikach i hasłach mogą być przechowywane w zwykłym pliku tekstowym lub np. w
 *  serializowanym słowniku.
 * 
 * @author Mateusz Kamiński
 */
public aspect Authenticator {

	pointcut authenticatorcut(): call(* Customer.call(..));
	
	// jeśli uwierzytelnienie użytkownik nie powiedzie się, to zwracane jest wskazanie na null
	Call around(Customer callingCustomer, Customer receiver) : authenticatorcut() && target(callingCustomer) && args(receiver) {
		Call callObject = null;
		
		if (authenticateCaller(callingCustomer)) {
			callObject = proceed(callingCustomer, receiver);
		}
		
		return callObject;
	}
	
	// symuluje pobranie hasła i przeprowadza uwierzytelenie klienta
	private boolean authenticateCaller(Customer callingCustomer) {
		String passwordInput = callingCustomer.getPassword();
		return passwordInput.equals(getCustomerPassword(callingCustomer));
	}
	
	// pobiera z zewnętrznego pliku zapisane hasło
	private static String getCustomerPassword(Customer callingCustomer) {
		try (Scanner scanner = new Scanner(new File("passwords.txt"))) {
			scanner.useDelimiter("\n");
			Map<String, String> customerPasswords = new HashMap<>();
			scanner.forEachRemaining(new Consumer<String>() {
				@Override
				public void accept(String t) {
					customerPasswords.put(t.split(" ")[0], t.split(" ")[1]);
				}
			});
			return customerPasswords.get(callingCustomer.getName());
		} catch (FileNotFoundException e) {
			throw new RuntimeException(e);
		}
	}
}
