package aspects;

/*
 * Prosta klasa implementujaca mechanizm stopera
 */
public class Timer
{
	// Czas startu i stopu przechowywany jako publiczne pola
	public long startTime, stopTime;

	// Metoda startujaca stoper
	public void start()
	{
		startTime = System.nanoTime();
		stopTime = startTime;
	}

	// Metoda zatrzymujaca stoper
	public void stop()
	{
		stopTime = System.nanoTime();
	}

	// Czas ostatniego pomiaru
	public long getTime()
	{
		return stopTime - startTime;
	}
}
