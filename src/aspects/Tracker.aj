package aspects;

import java.io.FileWriter;
import java.io.IOException;
import java.util.Arrays;
import java.util.Optional;
import java.util.function.Function;

import org.aspectj.lang.Signature;

/**
 * Realizacja zadania 2
 * 
 * Aspekt śledzący, który dla każdego wywołania metody zapisuje do pliku dziennika:
 *   • klasę obiektu, na rzecz którego została wykonana metoda
 *   • nazwy, typy i wartości argumentów metody
 *   • wynik zwracany przez metodę
 *   • czas wykonania metody podany w milisekundach
 *   
 * Punkty złączeń mają wystąpić tylko w oryginalnym kodzie aplikacji, z pominięciem rozszerzeń aspektowych.
 * 
 * @author Mateusz Kamiński
 */
public aspect Tracker {
	
	pointcut trackercut(): call(* *.*(..)) && within(telecom.*);
	
	private static Timer timer = new Timer();
	
	Object around() : trackercut() && args(..) {
		Object result;
		synchronized (timer) {
			timer.start();
			result = proceed();
			timer.stop();
		
			logMethodInvocation(thisJoinPoint.getTarget(), 
					thisJoinPoint.getSignature(), 
					thisJoinPoint.getArgs(),
					result);
		}
		return result;
	}
	
	@SuppressWarnings("unused")
	private static void logMethodInvocation(Object target, 
											Signature methodSignature, 
											Object[] args, 
											Object result) {
		try (FileWriter logFileWriter = new FileWriter("telecom_tracker.log", true)) {
			
			logFileWriter.append("Method invocation");
			logFileWriter.append("   Target object class: ");
			logFileWriter.append(Optional.ofNullable(target).map(new Function<Object, Object>() {
				public Object apply(Object as) {
					return as.getClass().toString();
				}
			}).toString());
			logFileWriter.append("\n");

			logFileWriter.append("   Method signature: ");
			logFileWriter.append(methodSignature.toLongString());
			logFileWriter.append("\n");

			logFileWriter.append("   Invoked with args: ");
			logFileWriter.append(Arrays.toString(args));
			logFileWriter.append("\n");
			
			logFileWriter.append("   Returned object: ");
			logFileWriter.append(String.valueOf(result));
			logFileWriter.append("\n");
			
			logFileWriter.append("   Execution time [ms]: ");
			logFileWriter.append(String.valueOf(timer.getTime() / 1000000));
			logFileWriter.append("\n\n");
			logFileWriter.flush();
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}
	
}
