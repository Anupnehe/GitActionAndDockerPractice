import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.interactions.Actions;
import org.testng.annotations.Test;

public class login {

    @Test
    public static void RunTest(){
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--headless", "--no-sandbox", "--disable-dev-shm-usage");
        WebDriver driver = new ChromeDriver(options);

        driver.get("https://ultimateqa.com/filling-out-forms/");


        WebElement ele = driver.findElement(By.id("et_pb_contact_message_0"));
        ele.sendKeys("hello");


        WebElement submit = driver.findElement(By.xpath("//*[@type='submit']"));
        Actions actions = new Actions(driver);
        actions.moveToElement(submit).perform();

        actions.sendKeys(Keys.ENTER).perform();
        actions.keyDown(Keys.CONTROL).sendKeys("a").keyUp(Keys.CONTROL).perform();

        driver.quit();
        System.out.println("completed");

    }
}
