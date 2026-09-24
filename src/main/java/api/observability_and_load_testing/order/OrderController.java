package api.observability_and_load_testing.order;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class OrderController {

    private final OrderRepository orderRepository;

    @GetMapping("/orders")
    public List<Order> getOrders() {
        return orderRepository.findAll();
    }
}