public class Venasaur {
    public void doSomething() {
        IvysaurBatchApex saur = new IvysaurBatchApex();
        Database.executeBatch(saur, 3);
    }
}