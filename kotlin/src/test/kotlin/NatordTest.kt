import dev.tachibana.natord.NatordPlus
import org.junit.jupiter.api.Test
import kotlin.test.assertEquals

class NatordTest {
    @Test
    fun testBasicComparison() {
        assertEquals(-1, NatordPlus.natord("a", "b"))
        assertEquals(1, NatordPlus.natord("b", "a"))
        assertEquals(0, NatordPlus.natord("a", "a"))
    }

    @Test
    fun testNumericComparison() {
        assertEquals(-1, NatordPlus.natord("a1", "a2"))
        assertEquals(1, NatordPlus.natord("a10", "a2"))
        assertEquals(-1, NatordPlus.natord("a2", "a10"))
    }

    @Test
    fun testFractionalNumbers() {
        assertEquals(-1, NatordPlus.natord("3", "3.14"))
        assertEquals(1, NatordPlus.natord("3.14", "3"))
    }
}
