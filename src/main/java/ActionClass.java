import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.interactions.Actions;

public class ActionClass {
    public static void main (String [] args){

        WebDriver driver = new ChromeDriver();
        driver.get("https://ultimateqa.com/filling-out-forms/");


      WebElement ele = driver.findElement(By.id("et_pb_contact_message_0"));
        ele.sendKeys("hello");


        WebElement submit = driver.findElement(By.xpath("//*[@type='submit']"));
        Actions actions = new Actions(driver);
        actions.moveToElement(submit).perform();

        actions.sendKeys(Keys.ENTER).perform();
        actions.keyDown(Keys.CONTROL).sendKeys("a").keyUp(Keys.CONTROL).perform();
    }

}
